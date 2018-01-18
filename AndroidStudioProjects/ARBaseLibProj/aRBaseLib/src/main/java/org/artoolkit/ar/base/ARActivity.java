/*
 *  ARActivity.java
 *  ARToolKit5
 *
 *  This file is part of ARToolKit.
 *
 *  ARToolKit is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  ARToolKit is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with ARToolKit.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  As a special exception, the copyright holders of this library give you
 *  permission to link this library with independent modules to produce an
 *  executable, regardless of the license terms of these independent modules, and to
 *  copy and distribute the resulting executable under terms of your choice,
 *  provided that you also meet, for each linked independent module, the terms and
 *  conditions of the license of that module. An independent module is a module
 *  which is neither derived from nor based on this library. If you modify this
 *  library, you may extend this exception to your version of the library, but you
 *  are not obligated to do so. If you do not wish to do so, delete this exception
 *  statement from your version.
 *
 *  Copyright 2015 Daqri, LLC.
 *  Copyright 2011-2015 ARToolworks, Inc.
 *
 *  Author(s): Julian Looser, Philip Lamb
 *
 */

package org.artoolkit.ar.base;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ConfigurationInfo;
import android.content.pm.PackageManager;
import android.graphics.PixelFormat;
import android.opengl.GLSurfaceView;
import android.opengl.GLSurfaceView.Renderer;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.Toast;

import org.artoolkit.ar.base.camera.CameraAccessHandler;
import org.artoolkit.ar.base.camera.CameraEventListener;
import org.artoolkit.ar.base.camera.CameraPreferencesActivity;
import org.artoolkit.ar.base.camera.CaptureCameraPreview;
import org.artoolkit.ar.base.rendering.ARRenderer;

/**
 * An activity which can be subclassed to create an AR application. ARActivity handles almost all of
 * the required operations to create a simple augmented reality application.
 * <p/>
 * ARActivity automatically creates a camera preview surface and an OpenGL surface view, and
 * arranges these correctly in the user interface.The subclass simply needs to provide a FrameLayout
 * object which will be populated with these UI components, using {@link #supplyFrameLayout() supplyFrameLayout}.
 * <p/>
 * To create a custom AR experience, the subclass should also provide a custom renderer using
 * {@link #supplyRenderer() Renderer}. This allows the subclass to handle OpenGL drawing calls on its own.
 */

public abstract class ARActivity extends /*AppCompat*/Activity implements View.OnClickListener {

    /**
     * Used to match-up permission user request to user response
     */
    public static final int REQUEST_CAMERA_PERMISSION_RESULT = 0;

    /**
     * Android logging tag for this class.
     */
    protected final static String TAG = "ARBaseLib::ARActivity";

    /**
     * Renderer to use. This is provided by the subclass using {@link #supplyRenderer() Renderer()}.
     */
    protected ARRenderer renderer;

    /**
     * Layout that will be filled with the camera preview and GL views. This is provided by the subclass using {@link #supplyFrameLayout() supplyFrameLayout()}.
     */
    protected FrameLayout mainLayout;

    /**
     * Camera preview which will provide video frames.
     */
    private CaptureCameraPreview preview = null;

    /**
     * GL surface to render the virtual objects
     */
    private GLSurfaceView mGlView;

    /**
     * For any square template (pattern) markers, the number of rows
     * and columns in the template. May not be less than 16 or more than AR_PATT_SIZE1_MAX.
     */
    protected int mPattSize = 16;

    /**
     * For any square template (pattern) markers, the maximum number
     * of markers that may be loaded for a single matching pass. Must be > 0.
     */
    protected int mPattCountMax = 25;

    private boolean firstUpdate = false;

    private Context mContext;
    private CameraAccessHandler mCameraAccessHandler;

    @SuppressWarnings("unused")
    public Context getAppContext() {
        return mContext;
    }

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mContext = getApplicationContext();

        // This needs to be done just only the very first time the application is run,
        // or whenever a new preference is added (e.g. after an application upgrade).
        PreferenceManager.setDefaultValues(this, R.xml.preferences, false);

        // This locks the orientation. Hereafter, any API returning display orientation data will
        // return the data representing this orientation no matter the current position of the
        // device.
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        getWindow().setFormat(PixelFormat.TRANSLUCENT);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        AndroidUtils.reportDisplayInformation(this);
    }

    private Activity mActivity = null;

    /**
     * Allows subclasses to supply a custom {@link Renderer}.
     *
     * @return The {@link Renderer} to use.
     */
    protected abstract ARRenderer supplyRenderer();

    /**
     * Allows subclasses to supply a {@link FrameLayout} which will be populated
     * with a camera preview and GL surface view.
     *
     * @return The {@link FrameLayout} to use.
     */
    protected abstract FrameLayout supplyFrameLayout();

    @Override
    protected void onStart() {
        super.onStart();

        Log.i(TAG, "onStart(): called");
        mActivity = this;
        // Use cache directory as root for native path references.
        // The AssetFileTransfer class can help with unpacking from the built .apk to the cache.
        if (!ARToolKit.getInstance().initialiseNativeWithOptions(this.getCacheDir().getAbsolutePath(), mPattSize, mPattCountMax)) {
            notifyFinish("The native library is not loaded. The application cannot continue.\n\nNavigate to ARTOOLKIT6_HOME/Source and run './build.sh android'. Copy the created ABI-directories from build-android/ to AR6J/src/main/jniLibs/");
            return;
        }

        mainLayout = supplyFrameLayout();
        if (mainLayout == null) {
            Log.e(TAG, "onStart(): Error: supplyFrameLayout did not return a layout.");
            return;
        }

        renderer = supplyRenderer();
        if (renderer == null) {
            Log.e(TAG, "onStart(): Error: supplyRenderer did not return a renderer.");
            // No renderer supplied, use default, which does nothing
            renderer = new ARRenderer();
        }
    }

    @SuppressWarnings("deprecation") // FILL_PARENT still required for API level 7 (Android 2.1)
    @Override
    public void onResume() {
        Log.i(TAG, "onResume(): called");
        super.onResume();

        if (!ARToolKit.getInstance().isNativeInited()) {
            return;
        }

        // Create the GL view
        mGlView = new GLSurfaceView(this);

        FrameListener frameListener = new FrameListenerImpl(renderer, this, mGlView);
        CameraEventListener cameraEventListener = new CameraEventListenerImpl(this, frameListener);
        mCameraAccessHandler = AndroidUtils.createCameraAccessHandler(this, cameraEventListener);

        // Check if the system supports OpenGL ES 2.0.
        final ActivityManager activityManager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        final ConfigurationInfo configurationInfo = activityManager.getDeviceConfigurationInfo();
        final boolean supportsEs2 = configurationInfo.reqGlEsVersion >= 0x20000;

        if (supportsEs2) {
            Log.i(TAG, "onResume(): OpenGL ES 2.x is supported");
             // Request an OpenGL ES 2.0 compatible context.
            mGlView.setEGLContextClientVersion(2);

        } else {
            Log.i(TAG, "onResume(): Only OpenGL ES 1.x is supported");
            throw new RuntimeException("Only OpenGL 1.x available, we need at least OpenGL 2.0.");
        }

        if (renderer != null) { //In case of using this method from UNITY we do not provide a renderer
            mGlView.setRenderer(renderer);
        }
        mGlView.setRenderMode(GLSurfaceView.RENDERMODE_WHEN_DIRTY); // Only render when we have a frame (must call requestRender()).
        mGlView.addOnLayoutChangeListener(new LayoutChangeListenerImpl(this, mCameraAccessHandler));

        Log.i(TAG, "onResume(): GLSurfaceView created");

        // Add the OpenGL view which will be used to render the video background and the virtual environment.
        mainFrameLayout.addView(mGlView, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        Log.i(TAG, "onResume(): Views added to main layout.");
        mGlView.onResume();

        if (mCameraAccessHandler.gettingCameraAccessPermissionsFromUser()) {
            //No need to go further, must ask user to allow access to the camera first.
            return;
        }

        //Load settings button
        View settingsButtonLayout = this.getLayoutInflater().inflate(R.layout.settings_button_layout, mainFrameLayout, false);
        mSettingButton = (ImageButton) settingsButtonLayout.findViewById(R.id.button_settings);
        mainFrameLayout.addView(settingsButtonLayout);
        mSettingButton.setOnClickListener(this);
    }

    @Override
    protected void onPause() {
        Log.i(TAG, "onPause(): called");

        // System hardware must be released in onPause(), so it's available to
        // any incoming activity. Removing the CameraPreview will do this for the
        // camera. Also do it for the GLSurfaceView, since it serves no purpose
        // with the camera preview gone.
        if (ARToolKit.getInstance().isNativeInited()) {
            mCamCaptureSurfaceView.closeCameraDevice();

            if (mGlView != null) {
                mGlView.onPause();
                mainFrameLayout.removeView(mGlView);
            }
        }
        super.onPause();
    }

    @Override
    public void onStop() {
        Log.i(TAG, "onStop(): Activity stopping.");
        super.onStop();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.options, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.settings) {
            startActivity(new Intent(this, CameraPreferencesActivity.class));
            return true;
        } else {
            return super.onOptionsItemSelected(item);
        }
    }

    /**
     * Returns the GL surface view.
     *
     * @return The GL surface view.
     */
    public GLSurfaceView getGLView() {
        return mGlView;
    }

    protected void showInfo() {

        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(this);

        dialogBuilder.setMessage("ARToolKit Version: " + NativeInterface.arwGetARToolKitVersion());

        dialogBuilder.setCancelable(false);
        dialogBuilder.setPositiveButton("Close", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
            }
        });

        AlertDialog alert = dialogBuilder.create();
        alert.setTitle("ARToolKit");
        alert.show();
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        View decorView = getWindow().getDecorView();
        if (hasFocus) {
            // Now can configure view to run  full screen
            decorView.setSystemUiVisibility(AndroidUtils.VIEW_VISIBILITY);
        }
    }

    @Override
    public void onClick(View v) {
        if (v.equals(mSettingButton)) {
            v.getContext().startActivity(new Intent(v.getContext(), CameraPreferencesActivity.class));
        }

    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           @NonNull String[] permissions,
                                           @NonNull int[] grantResults) {
        Log.i(TAG, "onRequestPermissionsResult(): called");

        if (requestCode == REQUEST_CAMERA_PERMISSION_RESULT) {
            if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
                notifyFinish("Application will not run with camera access denied");
            } else if (1 <= permissions.length) {
                Toast.makeText(getApplicationContext(),
                        String.format("Camera access permission \"%s\" allowed", permissions[0]),
                        Toast.LENGTH_SHORT).show();
            }
            Log.i(TAG, "onRequestPermissionsResult(): reset ask for cam access perm");
            mCamCaptureSurfaceView.resetGettingCameraAccessPermissionsFromUserState();
        } else {
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
        onStart();
    }

    public ARRenderer getRenderer() {
        return renderer;
    }

    public void notifyFinish(String errorMessage) {
        new AlertDialog.Builder(this)
                .setMessage(errorMessage)
                .setTitle("Error")
                .setCancelable(true)
                .setNeutralButton(android.R.string.ok,
                        new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int whichButton) {
                                finish();
                            }
                        })
                .show();
    }
} // end: public abstract class ARActivity extends /*AppCompat*/Activity implements CameraEventListener
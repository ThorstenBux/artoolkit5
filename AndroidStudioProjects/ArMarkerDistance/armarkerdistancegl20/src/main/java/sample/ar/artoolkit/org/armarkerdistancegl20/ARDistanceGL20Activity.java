package sample.ar.artoolkit.org.armarkerdistancegl20;

import android.os.Bundle;
import android.widget.FrameLayout;

import org.artoolkit.ar.base.ARActivity;
import org.artoolkit.ar.base.rendering.ARRenderer;
import org.artoolkit.ar.base.rendering.gles20.ARRendererGLES20;

/**
 * Created by Thorsten Bux on 25.01.2016.
 */
public class ARDistanceGL20Activity extends ARActivity {

    private FrameLayout mainView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        renderer = new ARDistanceRenderer(this);

        setContentView(R.layout.layout);
        mainView = (FrameLayout) this.findViewById(R.id.distanceGL20layout);
    }

    @Override
    protected ARRenderer supplyRenderer() {
        return renderer;
    }

    @Override
    protected FrameLayout supplyFrameLayout() {
        return mainLayout;
    }

}

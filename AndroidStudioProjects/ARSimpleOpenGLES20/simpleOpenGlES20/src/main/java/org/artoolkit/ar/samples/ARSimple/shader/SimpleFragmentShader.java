package org.artoolkit.ar.samples.ARSimple.shader;

import android.opengl.GLES20;

import org.artoolkit.ar.base.rendering.gles20.OpenGLShader;

/**
 * Created by Thorsten Bux on 21.01.2016.
 */
public class SimpleFragmentShader implements OpenGLShader {
    final String fragmentShader =
            "precision mediump float;       \n"     // Set the default precision to medium. We don't need as high of a
                    // precision in the fragment shader.
                    + "varying vec4 v_Color;          \n"     // This is the color from the vertex shader interpolated across the
                    // triangle per fragment.
                    + "void main()                    \n"     // The entry point for our fragment shader.
                    + "{                              \n"
                    + "   gl_FragColor = v_Color;     \n"     // Pass the color directly through the pipeline.
                    + "}                              \n";

    public int configureShader(){

        int fragmentShaderHandle = GLES20.glCreateShader(GLES20.GL_FRAGMENT_SHADER);
        String fragmentShaderErrorLog = "";

        if (fragmentShaderHandle != 0) {

            //Pass in the shader source
            GLES20.glShaderSource(fragmentShaderHandle, fragmentShader);

            //Compile the shader
            GLES20.glCompileShader(fragmentShaderHandle);

            //Get the compilation status.
            final int[] compileStatus = new int[1];
            GLES20.glGetShaderiv(fragmentShaderHandle, GLES20.GL_COMPILE_STATUS,compileStatus,0);

            //If the compilation failed, delete the shader
            if (compileStatus[0] == 0){
                fragmentShaderErrorLog = GLES20.glGetShaderInfoLog(fragmentShaderHandle);
                GLES20.glDeleteShader(fragmentShaderHandle);
                fragmentShaderHandle = 0;
            }
        }
        if (fragmentShaderHandle == 0)
        {
            throw new RuntimeException("Error creating fragment shader.\\n" + fragmentShaderErrorLog);
        }
        return fragmentShaderHandle;
    }
}

package org.artoolkit.ar.samples.ARSimple.shader;

import org.artoolkit.ar.base.rendering.gles20.BaseFragmentShader;

/**
 * Created by Thorsten Bux on 21.01.2016.
 */
public class SimpleFragmentShader extends BaseFragmentShader {
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
        this.setShaderSource(fragmentShader);
        return super.configureShader();
    }
}

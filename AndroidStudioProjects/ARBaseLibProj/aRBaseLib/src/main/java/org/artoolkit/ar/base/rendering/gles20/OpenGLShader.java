package org.artoolkit.ar.base.rendering.gles20;

/**
 * Created by Thorsten Bux on 21.01.2016.
 */
public interface OpenGLShader {

    String projectionMatrixString = "u_projection";
    String modelViewMatrixString = "u_modelView";
    String positionVectorString = "a_Position";

    public int configureShader();

}

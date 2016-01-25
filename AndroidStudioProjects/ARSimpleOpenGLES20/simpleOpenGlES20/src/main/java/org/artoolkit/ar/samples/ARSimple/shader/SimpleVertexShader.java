package org.artoolkit.ar.samples.ARSimple.shader;

import org.artoolkit.ar.base.rendering.gles20.BaseVertexShader;
import org.artoolkit.ar.base.rendering.gles20.OpenGLShader;

/**
 * Created by Thorsten Bux on 21.01.2016.
 */
public class SimpleVertexShader extends BaseVertexShader {


    public static String colorVectorString = "a_Color";

    final String vertexShader =
            "uniform mat4 u_MVPMatrix;        \n"     // A constant representing the combined model/view/projection matrix.

                    + "uniform mat4 " + OpenGLShader.projectionMatrixString + "; \n"		// projection matrix
                    + "uniform mat4 "+ OpenGLShader.modelViewMatrixString + "; \n"		// modelView matrix

                    + "attribute vec4 " + OpenGLShader.positionVectorString +"; \n"     // Per-vertex position information we will pass in.
                    + "attribute vec4 " + colorVectorString +"; \n"     // Per-vertex color information we will pass in.

                    + "varying vec4 v_Color;          \n"     // This will be passed into the fragment shader.

                    + "void main()                    \n"     // The entry point for our vertex shader.
                    + "{                              \n"
                    + "   v_Color = " + colorVectorString + "; \n"     // Pass the color through to the fragment shader.
                    // It will be interpolated across the triangle.
                    + "	  vec4 p = " + OpenGLShader.modelViewMatrixString + " * " + OpenGLShader.positionVectorString + "; \n "     // transform vertex position with modelview matrix
                    + "   gl_Position = " + OpenGLShader.projectionMatrixString + " \n"     // gl_Position is a special variable used to store the final position.
                    + "               * p;   			\n"     // Multiply the vertex by the matrix to get the final point in
                    + "}                              \n";    // normalized screen coordinates.

    @Override
    public int configureShader() {
        this.setShaderSource(vertexShader);
        return super.configureShader();
    }
}

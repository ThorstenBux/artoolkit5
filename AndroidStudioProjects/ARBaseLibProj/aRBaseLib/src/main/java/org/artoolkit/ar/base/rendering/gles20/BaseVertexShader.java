package org.artoolkit.ar.base.rendering.gles20;

import android.opengl.GLES20;

/**
 * Created by Thorsten Bux on 21.01.2016.
 */
public class BaseVertexShader implements OpenGLShader {

    final String vertexShader =
            "uniform mat4 u_MVPMatrix;        \n"     // A constant representing the combined model/view/projection matrix.

                    + "uniform mat4 " + OpenGLShader.projectionMatrixString + "; \n"		// projection matrix
                    + "uniform mat4 "+ OpenGLShader.modelViewMatrixString + "; \n"		// modelView matrix

                    + "attribute vec4 " + OpenGLShader.positionVectorString +"; \n"     // Per-vertex position information we will pass in.

                    + "void main()                    \n"     // The entry point for our vertex shader.
                    + "{                              \n"
                     // It will be interpolated across the triangle.
                    + "	  vec4 p = " + OpenGLShader.modelViewMatrixString + " * " + OpenGLShader.positionVectorString + "; \n "     // transform vertex position with modelview matrix
                    + "   gl_Position = " + OpenGLShader.projectionMatrixString + " \n"     // gl_Position is a special variable used to store the final position.
                    + "               * p;   			\n"     // Multiply the vertex by the matrix to get the final point in
                    + "}                              \n";    // normalized screen coordinates.

    @Override
    public int configureShader() {
        // Load in the vertex shader.
        int vertexShaderHandle = GLES20.glCreateShader(GLES20.GL_VERTEX_SHADER);
        String vertexShaderErrorLog = "";

        if (vertexShaderHandle != 0)
        {
            // Pass in the shader source.
            GLES20.glShaderSource(vertexShaderHandle, vertexShader);

            // Compile the shader.
            GLES20.glCompileShader(vertexShaderHandle);

            // Get the compilation status.
            final int[] compileStatus = new int[1];
            GLES20.glGetShaderiv(vertexShaderHandle, GLES20.GL_COMPILE_STATUS, compileStatus, 0);

            // If the compilation failed, delete the shader.
            if (compileStatus[0] == 0)
            {
                vertexShaderErrorLog = GLES20.glGetShaderInfoLog(vertexShaderHandle);
                GLES20.glDeleteShader(vertexShaderHandle);
                vertexShaderHandle = 0;
            }
        }

        if (vertexShaderHandle == 0) {
            throw new RuntimeException("Error creating vertex shader.\n" + vertexShaderErrorLog);
        }

        return vertexShaderHandle;
    }
}

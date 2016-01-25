package org.artoolkit.ar.base.rendering.gles20;

/**
 * Created by Thorsten Bux on 26.01.2016.
 */
public interface ARDrawableOpenGLES20 {
    public void draw(float[] projectionMatrix, float[] modelViewMatrix);
    public void setShaderProgram(ShaderProgram program);
}

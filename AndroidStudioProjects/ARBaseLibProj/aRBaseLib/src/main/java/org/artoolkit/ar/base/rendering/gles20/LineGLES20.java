package org.artoolkit.ar.base.rendering.gles20;

import org.artoolkit.ar.base.rendering.Line;

/**
 * Created by Thorsten Bux on 15.01.2016.
 */
public class LineGLES20 extends Line implements ARDrawableOpenGLES20{

    private ShaderProgram shaderProgram;

    /**
     * @param width Width of the vector
     */
    public LineGLES20(float width){
        shaderProgram = null;
        this.setWidth(width);
    }

    public LineGLES20(float width, ShaderProgram shaderProgram){
        this(width);
        this.shaderProgram = shaderProgram;
    }

    @Override
    public void draw(float[] projectionMatrix, float[] modelViewMatrix) {

        shaderProgram.setProjectionMatrix(projectionMatrix);
        shaderProgram.setModelViewMatrix(modelViewMatrix);

        this.setArrays();
        shaderProgram.render(this.getMVertexBuffer(), this.getmColorBuffer(),null);

    }

    @Override
    public void setShaderProgram(ShaderProgram program) {
        this.shaderProgram = program;
    }
}

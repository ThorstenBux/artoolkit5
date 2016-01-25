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

        int startLength= getStart().length;
        float[] vertex = new float[startLength +getEnd().length];

        for (int i = 0; i < vertex.length; i++){
            vertex[i] = getStart()[i];
            vertex[i+ startLength] = getEnd()[i];
        }

        shaderProgram.render(vertex);

    }

    @Override
    public void setShaderProgram(ShaderProgram program) {
        this.shaderProgram = program;
    }
}

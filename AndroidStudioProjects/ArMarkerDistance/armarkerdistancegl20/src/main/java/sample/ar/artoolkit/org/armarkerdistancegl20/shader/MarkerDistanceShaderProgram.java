package sample.ar.artoolkit.org.armarkerdistancegl20.shader;

import android.opengl.GLES20;
import org.artoolkit.ar.base.rendering.gles20.BaseShaderProgram;
import org.artoolkit.ar.base.rendering.gles20.OpenGLShader;

/**
 * Created by Thorsten Bux on 25.01.2016.
 */
public class MarkerDistanceShaderProgram extends BaseShaderProgram{

    public void setLineWidth(int lineWidth) {
        this.lineWidth = lineWidth;
    }

    private int lineWidth;

    public MarkerDistanceShaderProgram(OpenGLShader vertexShader, OpenGLShader fragmentShader, int lineWidth) {
        super(vertexShader, fragmentShader);
        this.lineWidth = lineWidth;
    }

    @Override
    public int getProjectionMatrixHandle() {
        return super.getProjectionMatrixHandle();
    }

    @Override
    public int getModelViewMatrixHandle() {
        return super.getModelViewMatrixHandle();
    }

    @Override
    protected void bindAttributes() {
        super.bindAttributes();
    }

    @Override
    public void render(float[] position) {
        setupShaderUsage();
        int coordsPerVertex = 3;

        //camPosition.length * 4 bytes per float
        GLES20.glVertexAttribPointer(this.getPositionHandle(), position.length, GLES20.GL_FLOAT, false,
                position.length/coordsPerVertex * 4, 0);
        GLES20.glEnableVertexAttribArray(this.getPositionHandle());


        //GLES20.glVertexPointer(start.length, GLES20.GL_FLOAT, 0, mVertexBuffer);

        GLES20.glLineWidth(this.lineWidth);

        GLES20.glDrawArrays(GLES20.GL_LINES, 0, position.length / coordsPerVertex);
        //GLES20.glDisableClientState(GLES20.GL_VERTEX_ARRAY);
        GLES20.glDisableVertexAttribArray(this.getPositionHandle());
    }
}

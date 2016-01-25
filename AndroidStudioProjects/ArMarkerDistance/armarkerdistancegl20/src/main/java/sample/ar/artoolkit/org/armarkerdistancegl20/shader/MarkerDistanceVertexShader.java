//package sample.ar.artoolkit.org.armarkerdistancegl20.shader;
//
//import org.artoolkit.ar.base.rendering.gles20.BaseShaderProgram;
//import org.artoolkit.ar.base.rendering.gles20.BaseVertexShader;
//import org.artoolkit.ar.base.rendering.gles20.OpenGLShader;
//
///**
// * Created by Thorsten Bux on 25.01.2016.
// */
//public class MarkerDistanceVertexShader extends BaseVertexShader implements OpenGLShader {
//
//    private String vertexShader =
//            "uniform mat4 u_MVPMatrix;        \n"     // A constant representing the combined model/view/projection matrix.
//
//                    + "uniform mat4 " + OpenGLShader.projectionMatrixString + "; \n"		// projection matrix
//                    + "uniform mat4 "+ OpenGLShader.modelViewMatrixString + "; \n"		// modelView matrix
//
//                    + "attribute vec4 " + OpenGLShader.positionVectorString +"; \n"     // Per-vertex position information we will pass in.
//
//                    + "void main()                    \n"     // The entry point for our vertex shader.
//                    + "{                              \n"
//                    + "	  vec4 p = " + OpenGLShader.modelViewMatrixString + " * " + OpenGLShader.positionVectorString + "; \n "     // transform vertex position with modelview matrix
//                    + "   gl_Position = " + OpenGLShader.projectionMatrixString + " \n"     // gl_Position is a special variable used to store the final position.
//                    + "               * p;   			\n"     // Multiply the vertex by the matrix to get the final point in
//                    + "}                              \n";    // normalized screen coordinates.
//
//    public MarkerDistanceVertexShader() {
//        super();
//    }
//
//    @Override
//    public int configureShader() {
//        super.setVertexShaderSource(vertexShader);
//        return super.configureShader();
//    }
//}

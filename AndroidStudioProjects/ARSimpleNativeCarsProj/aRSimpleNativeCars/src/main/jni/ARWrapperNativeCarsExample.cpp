/*
 *  ARWrapperNativeCarsExample.cpp
 *  ARToolKit for Android
 *
 *  Disclaimer: IMPORTANT:  This Daqri software is supplied to you by Daqri
 *  LLC ("Daqri") in consideration of your agreement to the following
 *  terms, and your use, installation, modification or redistribution of
 *  this Daqri software constitutes acceptance of these terms.  If you do
 *  not agree with these terms, please do not use, install, modify or
 *  redistribute this Daqri software.
 *
 *  In consideration of your agreement to abide by the following terms, and
 *  subject to these terms, Daqri grants you a personal, non-exclusive
 *  license, under Daqri's copyrights in this original Daqri software (the
 *  "Daqri Software"), to use, reproduce, modify and redistribute the Daqri
 *  Software, with or without modifications, in source and/or binary forms;
 *  provided that if you redistribute the Daqri Software in its entirety and
 *  without modifications, you must retain this notice and the following
 *  text and disclaimers in all such redistributions of the Daqri Software.
 *  Neither the name, trademarks, service marks or logos of Daqri LLC may
 *  be used to endorse or promote products derived from the Daqri Software
 *  without specific prior written permission from Daqri.  Except as
 *  expressly stated in this notice, no other rights or licenses, express or
 *  implied, are granted by Daqri herein, including but not limited to any
 *  patent rights that may be infringed by your derivative works or by other
 *  works in which the Daqri Software may be incorporated.
 *
 *  The Daqri Software is provided by Daqri on an "AS IS" basis.  DAQRI
 *  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 *  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 *  FOR A PARTICULAR PURPOSE, REGARDING THE DAQRI SOFTWARE OR ITS USE AND
 *  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 *
 *  IN NO EVENT SHALL DAQRI BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 *  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 *  MODIFICATION AND/OR DISTRIBUTION OF THE DAQRI SOFTWARE, HOWEVER CAUSED
 *  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 *  STRICT LIABILITY OR OTHERWISE, EVEN IF DAQRI HAS BEEN ADVISED OF THE
 *  POSSIBILITY OF SUCH DAMAGE.
 *
 *  Copyright 2015 Daqri LLC. All Rights Reserved.
 *  Copyright 2011-2015 ARToolworks, Inc. All Rights Reserved.
 *
 *  Author(s): Julian Looser, Philip Lamb
 */

#include <AR/gsub_es.h>
#include <Eden/glm.h>
#include <jni.h>
#include <ARWrapper/ARToolKitWrapperExportedAPI.h>
#include <unistd.h> // chdir()
#include <android/log.h>

// Utility preprocessor directive so only one change needed if Java class name changes
#define JNIFUNCTION_DEMO(sig) Java_org_artoolkit_ar_samples_ARSimpleNativeCars_SimpleNativeRenderer_##sig

extern "C" {
	JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoInitialise(JNIEnv* env, jobject object));
	JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoShutdown(JNIEnv* env, jobject object));
	JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoSurfaceCreated(JNIEnv* env, jobject object));
	JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoSurfaceChanged(JNIEnv* env, jobject object, jint w, jint h));
	JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoDrawFrame(JNIEnv* env, jobject obj));
};

typedef struct ARModel {
	int patternID;
	ARdouble transformationMatrix[16];
	bool visible;
	GLMmodel* obj;
	ARdouble offset;
} ARModel;

#define NUM_MODELS 2
static ARModel models[NUM_MODELS] = {0};

#define NUM_INTERACTION_MODELS 2
static ARModel interactionModels[NUM_INTERACTION_MODELS] = {0};

static float lightAmbient[4] = {0.1f, 0.1f, 0.1f, 1.0f};
static float lightDiffuse[4] = {1.0f, 1.0f, 1.0f, 1.0f};
static float lightPosition[4] = {0.0f, 0.0f, 1.0f, 0.0f};

static JavaVM *gJavaVM;

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM *vm, void *reserved)
{
    gJavaVM = vm;
    return JNI_VERSION_1_6;
}


JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoInitialise(JNIEnv* instanceOfAndroidContext, jobject object)) {
	
	const char *model0file = "Data/models/Porsche_911_GT3.obj";
	const char *model1file = "Data/models/Ferrari_Modena_Spider.obj";

	models[0].patternID = arwAddMarker("single;Data/hiro.patt;80");
	arwSetMarkerOptionBool(models[0].patternID, ARW_MARKER_OPTION_SQUARE_USE_CONT_POSE_ESTIMATION, false);
	arwSetMarkerOptionBool(models[0].patternID, ARW_MARKER_OPTION_FILTERED, true);

	models[0].obj = glmReadOBJ2(model0file, 0, 0); // context 0, don't read textures yet.
	if (!models[0].obj) {
		LOGE("Error loading model from file '%s'.", model0file);
		exit(-1);
	}
	glmScale(models[0].obj, 0.035f);
	//glmRotate(models[0].obj, 3.14159f / 2.0f, 1.0f, 0.0f, 0.0f);
	glmCreateArrays(models[0].obj, GLM_SMOOTH | GLM_MATERIAL | GLM_TEXTURE);
	models[0].visible = false;
	
	models[1].patternID = arwAddMarker("single;Data/kanji.patt;80");
	arwSetMarkerOptionBool(models[1].patternID, ARW_MARKER_OPTION_SQUARE_USE_CONT_POSE_ESTIMATION, false);
	arwSetMarkerOptionBool(models[1].patternID, ARW_MARKER_OPTION_FILTERED, true);

	models[1].obj = glmReadOBJ2(model1file, 0, 0); // context 0, don't read textures yet.
	if (!models[1].obj) {
		LOGE("Error loading model from file '%s'.", model1file);
		exit(-1);
	}
	glmScale(models[1].obj, 0.035f);
	//glmRotate(models[1].obj, 3.14159f / 2.0f, 1.0f, 0.0f, 0.0f);
	glmCreateArrays(models[1].obj, GLM_SMOOTH | GLM_MATERIAL | GLM_TEXTURE);
	models[1].visible = false;

	//Add interaction markers
    interactionModels[0].patternID = arwAddMarker("single;Data/left.patt;80");
    arwSetMarkerOptionBool(interactionModels[0].patternID, ARW_MARKER_OPTION_SQUARE_USE_CONT_POSE_ESTIMATION, false);
    arwSetMarkerOptionBool(interactionModels[0].patternID, ARW_MARKER_OPTION_FILTERED, true);
    interactionModels[0].visible = false;

    interactionModels[1].patternID = arwAddMarker("single;Data/right.patt;80");
    arwSetMarkerOptionBool(interactionModels[1].patternID, ARW_MARKER_OPTION_SQUARE_USE_CONT_POSE_ESTIMATION, false);
    arwSetMarkerOptionBool(interactionModels[1].patternID, ARW_MARKER_OPTION_FILTERED, true);
    interactionModels[1].visible = false;

    // Prepare to make JNI calls back to Java.

    // To begin, get a reference to the env and attach to it.
    JNIEnv *env;
    int isAttached = 0;
    jthrowable exception;
    if (((*gJavaVM).GetEnv((void**)&env, JNI_VERSION_1_6)) < 0) {
        // Couldn't get JNI environment, so this thread is native.
        if (((*gJavaVM).AttachCurrentThread(&env, NULL)) < 0) {
            ARLOGe("Error: Couldn't attach to Java VM.\n");
        }
        isAttached = 1;
    }

    jclass classSound = (*env).FindClass("org/artoolkit/ar/samples/ARSimpleNativeCars/Sound");
    if (!classSound) return;
    jmethodID methodIDplaySound = (*env).GetStaticMethodID(classSound, "playSound", "(I)V");
    if (!methodIDplaySound) return;
    (*env).CallStaticVoidMethod(classSound, methodIDplaySound, (jint)1);
    exception = (*env).ExceptionOccurred();
    if (exception) {
        (*env).ExceptionDescribe();
        (*env).ExceptionClear();
    }


    if (isAttached) (*gJavaVM).DetachCurrentThread(); // Clean up.

}

JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoShutdown(JNIEnv* env, jobject object)) {
}

JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoSurfaceCreated(JNIEnv* env, jobject object)) {
	glStateCacheFlush(); // Make sure we don't hold outdated OpenGL state.
	for (int i = 0; i < NUM_MODELS; i++) {
	    if (models[i].obj) {
	        glmDelete(models[i].obj, 0);
	        models[i].obj = NULL;
	    }
	}
}

JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoSurfaceChanged(JNIEnv* env, jobject object, jint w, jint h)) {
	// glViewport(0, 0, w, h) has already been set.
}

void moveLeft(){
    //Find out which model we need to modify
    for (int i = 0; i < NUM_MODELS; i++) {
        models[i].visible = arwQueryMarkerTransformation(models[i].patternID, models[i].transformationMatrix);

        if (models[i].visible) {
            models[i].offset -= 1.0;
        }
    }
}

void moveRight(){
    //Find out which model we need to modify
    for (int i = 0; i < NUM_MODELS; i++) {
        models[i].visible = arwQueryMarkerTransformation(models[i].patternID, models[i].transformationMatrix);

        if (models[i].visible) {
            models[i].offset += 1.0;
        }
    }
}

JNIEXPORT void JNICALL JNIFUNCTION_DEMO(demoDrawFrame(JNIEnv* env, jobject obj)) {
	
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); 

    // Set the projection matrix to that provided by ARToolKit.
	float proj[16];
	arwGetProjectionMatrix(proj);
	glMatrixMode(GL_PROJECTION);
	glLoadMatrixf(proj);
	glMatrixMode(GL_MODELVIEW);
	
	glStateCacheEnableDepthTest();
	glStateCacheEnableLighting();	
	glEnable(GL_LIGHT0);
	
	for (int i = 0; i < NUM_MODELS; i++) {		
		models[i].visible = arwQueryMarkerTransformation(models[i].patternID, models[i].transformationMatrix);		
			
		if (models[i].visible) {
		//Manipulate the x-Axis
			models[i].transformationMatrix[12] += models[i].offset;
			glLoadMatrixf(models[i].transformationMatrix);		
			
			glLightfv(GL_LIGHT0, GL_AMBIENT, lightAmbient);
			glLightfv(GL_LIGHT0, GL_DIFFUSE, lightDiffuse);
			glLightfv(GL_LIGHT0, GL_POSITION, lightPosition);
			
			glmDrawArrays(models[i].obj, 0);
		}
	}

	interactionModels[0].visible = arwQueryMarkerVisibility(interactionModels[0].patternID);
	interactionModels[1].visible = arwQueryMarkerVisibility(interactionModels[1].patternID);

	if(!interactionModels[0].visible) {
	    LOGE("Move Left id: %d", interactionModels[0].patternID);
	    moveLeft();
	}

	if(!interactionModels[1].visible) {
	    LOGE("Move Right id: %d", interactionModels[1].patternID);
	    moveRight();
	}

}
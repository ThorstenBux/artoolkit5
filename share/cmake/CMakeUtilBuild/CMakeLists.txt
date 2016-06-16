project("ARToolKit_Util")
cmake_minimum_required(VERSION 3.4)

INCLUDE(../config.cmake)

set(ARTK_UTIL_SRC ${ARTK_HOME}/util)

#1394/checkImage sources
file(GLOB_RECURSE checkImage_SRCS ${ARTK_UTIL_SRC}/1394/checkImage/*.c)
#1394/listCamera sources
file(GLOB_RECURSE listCamera_SRCS ${ARTK_UTIL_SRC}/1394/checkImage/*.c)
#1394/whiteBalance sources
file(GLOB_RECURSE whiteBalance_SRCS ${ARTK_UTIL_SRC}/1394/checkImage/*.c)
#calib_camera sources
file(GLOB calibCamera_SRCS ${ARTK_UTIL_SRC}/calib_camera/*.cpp)
#calib_optical sources
file(GLOB calibOptical_SRCS ${ARTK_UTIL_SRC}/calib_optical/*.c)
#calib_stereo sources
file(GLOB calibStereo_SRCS ${ARTK_UTIL_SRC}/calib_stereo/*.cpp)
#check_id sources
file(GLOB checkId_SRCS ${ARTK_UTIL_SRC}/check_id/*.c)
#checkResolution sources
file(GLOB checkResolution_SRCS ${ARTK_UTIL_SRC}/checkResolution/*.c)
#dispFeatureSet sources
file(GLOB dispFeatureSet_SRCS ${ARTK_UTIL_SRC}/dispFeatureSet/*.c)
#dispImageSet sources
file(GLOB dispImageSet_SRCS ${ARTK_UTIL_SRC}/dispImageSet/*.c)
#genMarkerSet sources
file(GLOB genMarkerSet_SRCS ${ARTK_UTIL_SRC}/genMarkerSet/*.c)
#genTexData sources
file(GLOB genTexData_SRCS ${ARTK_UTIL_SRC}/genTexData/*.c)
#mk_patt sources
file(GLOB mkPatt_SRCS ${ARTK_UTIL_SRC}/mk_patt/*.c)

#All headers to include
include_directories(${ARTK_HOME}/include
                    ${ARTK_HOME}/include/linux-x86_64
                    ${ARTK_HOME}/util/calib_optical)

#Link to the ARToolkit libs
link_directories(${OUTPUT_DIR}lib)

#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR}util/)

#Compile all executables
add_executable(checkImage ${checkImage_SRCS})
add_executable(listCamera ${listCamera_SRCS})
add_executable(whiteBalance ${whiteBalance_SRCS})
add_executable(calib_camera ${calibCamera_SRCS})
add_executable(calib_optical ${calibOptical_SRCS})
add_executable(calib_stereo ${calibStereo_SRCS})
add_executable(check_id ${checkId_SRCS})
add_executable(checkResolution ${checkResolution_SRCS})
add_executable(dispFeatureSet ${dispFeatureSet_SRCS})
add_executable(dispImageSet ${dispImageSet_SRCS})
add_executable(genMarkerSet ${genMarkerSet_SRCS})
add_executable(genTexData ${genTexData_SRCS})
add_executable(mk_patt ${mkPatt_SRCS})

set(LIBS_Simple ARgsub_lite ARgsub ARVideo AR ARICP AR glut GLU GL gstreamer-0.10 m pthread gobject-2.0 glib-2.0 dc1394 jpeg)
set(LIB_CV opencv_calib3d opencv_imgproc opencv_core z)

set_property(TARGET calib_camera PROPERTY CXX_STANDARD 11)

#Link executables with required libs
target_link_libraries(checkImage ${LIBS_Simple})
target_link_libraries(listCamera ${LIBS_Simple})
target_link_libraries(whiteBalance ${LIBS_Simple})
target_link_libraries(calib_camera ${LIB_CV} ${LIBS_Simple})
target_link_libraries(calib_optical Eden ${LIBS_Simple})
target_link_libraries(calib_stereo ${LIB_CV} ${LIBS_Simple})
target_link_libraries(check_id ARMulti ${LIBS_Simple})
target_link_libraries(checkResolution AR2 ${LIBS_Simple})
target_link_libraries(dispFeatureSet KPM AR2 ${LIBS_Simple})
target_link_libraries(dispImageSet AR2 ${LIBS_Simple})
target_link_libraries(genMarkerSet AR2 ${LIBS_Simple})
target_link_libraries(genTexData KPM AR2 ${LIBS_Simple})
target_link_libraries(mk_patt ARosg ${LIBS_Simple})

#SET_TARGET_PROPERTIES(calib_camera PROPERTIES LINKER_LANGUAGE CXX)
#SET_TARGET_PROPERTIES(calib_stereo PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(dispFeatureSet PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(genTexData PROPERTIES LINKER_LANGUAGE CXX)

INSTALL(TARGETS checkImage listCamera whiteBalance calib_camera calib_optical calib_stereo check_id checkResolution dispFeatureSet dispImageSet genMarkerSet genTexData mk_patt 
RUNTIME DESTINATION ${OUTPUT_DIR}util/)


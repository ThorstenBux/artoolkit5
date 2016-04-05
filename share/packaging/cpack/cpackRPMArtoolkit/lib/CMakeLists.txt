cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)

include(../../cpackConfiguration.cmake)
include(../../cpackArtoolkit-libConfiguration.cmake)
include(../cpackRpmConfiguration.cmake)

set(DEPENDENCIES "libjpeg-devel, freeglut-devel, libv4l-devel, libdc1394-devel, glib2-devel, gstreamer-devel, OpenSceneGraph-devel, opencv-devel")

#Include all the libs into the package
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libAR.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libAR2.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARgsub.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARgsub_lite.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARICP.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARMulti.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARosg.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARVideo.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libEden.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libKPM.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libUtil.a DESTINATION lib${LIB_POSTFIX})
install(FILES ${BUILD_ARTEFACTS_DIR}lib/libARWrapper.so DESTINATION lib${LIB_POSTFIX})

set(CPACK_RPM_PACKAGE_REQUIRES ${DEPENDENCIES})


include(CPack)

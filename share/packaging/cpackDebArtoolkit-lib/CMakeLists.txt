cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)
 
set(OUTPUT_DIR /opt/jenkins/artoolkitBuildArtifacts/64bit/)
#add the prefix lib to the output dir to not have to add it for each file
set(OUTPUT_PREFIX ${OUTPUT_DIR}lib)


INSTALL(FILES ${OUTPUT_PREFIX}AR.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}AR2.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARICP.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}KPM.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}Util.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARMulti.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARgsub.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARVideo.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}Eden.a DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARWrapper.so DESTINATION lib)
INSTALL(FILES ${OUTPUT_PREFIX}ARosg.a DESTINATION lib)

SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit runtime")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit.org runtime: Contains all neccessary libraries for ARToolKit to run. For more information visit www.ARToolKit.org. Follow us on Twitter twitter.com/artoolkit_ and GitHub https://github.com/artoolkit/artoolkit5")
SET(CPACK_PACKAGE_VENDOR "ARToolKit.org")
SET(CPACK_PACKAGE_CONTACT "info@artoolkit.org")
#TODO: read config.h
SET(CPACK_PACKAGE_VERSION_MAJOR "${MAJOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_MINOR "${MINOR_VERSION}")
SET(CPACK_PACKAGE_VERSION_PATCH "${PATCH_VERSION}")
SET(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}_${MAJOR_VERSION}.${MINOR_VERSION}.${CPACK_PACKAGE_VERSION_PATCH}")

SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libjpeg-dev, libgstreamer0.10-dev, libv4l-dev, libdc1394-22-dev, libgl1-mesa-dev, freeglut3-dev, libopenscenegraph-dev, libopencv-dev")
 
SET(CPACK_DEBIAN_PACKAGE_PRIORITY "optional")
SET(CPACK_DEBIAN_PACKAGE_SECTION "kde")
SET(CPACK_DEBIAN_ARCHITECTURE ${CMAKE_SYSTEM_PROCESSOR})


SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "ARToolKit.org") #required

INCLUDE(CPack)


#[[

file(GLOB AR_includefiles ${ARTK_HOME}/include/AR/*.h)
file(GLOB AR2_includefiles ${ARTK_HOME}/include/AR2/*.h)
file(GLOB ARWrapper_includefiles ${ARTK_HOME}/include/ARWrapper/*.h)
file(GLOB Eden_includefiles ${ARTK_HOME}/include/Eden/*.h)
file(GLOB KPM1_includefiles ${ARTK_HOME}/include/KPM/*.h)
file(GLOB OpenCV_includefiles ${ARTK_HOME}/include/linux-${ARCHITECTURE}/opencv/*.h)
#TODO: Check openCV2 headers
file(GLOB OpenCV2_includefiles ${ARTK_HOME}/include/linux-${ARCHITECTURE}/opencv2/*.h)
#TODO: Where do these go?
#file(GLOB KPM2_includefiles ${ARTK_HOME}/lib/SRC/KPM/*.h)
#file(GLOB KPMFreak_includefiles ${ARTK_HOME}/lib/SRC/KPM/FreakMatcher/*.h)

#TODO: Goes into another package
INSTALL(FILES ${AR_includefiles} DESTINATION include/AR COMPONENT artoolkit-dev)
INSTALL(FILES ${AR2_includefiles} DESTINATION include/AR2 COMPONENT artoolkit-dev)
INSTALL(FILES ${ARWrapper_includefiles} DESTINATION include/ARWrapper COMPONENT artoolkit-dev)
INSTALL(FILES ${Eden_includefiles} DESTINATION include/AREden COMPONENT artoolkit-dev)
INSTALL(FILES ${KPM1_includefiles} DESTINATION include/KPM COMPONENT artoolkit-dev)
INSTALL(FILES ${OpenCV_includefiles} DESTINATION include/linux-${ARCHITECTURE}/opencv COMPONENT artoolkit-dev)
INSTALL(FILES ${OpenCV2_includefiles} DESTINATION include/linux-${ARCHITECTURE}/opencv2 COMPONENT artoolkit-dev)
#INSTALL(FILES ${KPM2_includefiles} DESTINATION include/AR2 artoolkit-dev)
#INSTALL(FILES ${KPMFreak_includefiles} DESTINATION include/AR2 artoolkit-dev)

]]

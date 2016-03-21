cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)

include(../cpackConfiguration.cmake)
include(cpackDebConfiguration.cmake)

#TODO: Somehow the CMake build produces an ARWrapper.so file that contains debug information. We do not want that. That is why we strip it here.
execute_process(COMMAND strip -s -o ${BUILD_ARTEFACTS_DIR}lib/${BUILD_ARTEFACTS_PREFIX}ARWrapper.so ${BUILD_ARTEFACTS_DIR}lib/${BUILD_ARTEFACTS_PREFIX}ARWrapper.so)

#SETUP directory structure with correct permissions
INSTALL(DIRECTORY DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share/doc DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#Include all the libs into the package
INSTALL(DIRECTORY ${BUILD_ARTEFACTS_DIR}lib DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE 
)

##According to the packaging guidelines we need a post installation script to call `ldconfig` after installation. This is the case because we install a dynamic library (ARWrapper.so)
#change the postinst file permissions and include them into the package. Permission needs to be 755
file(INSTALL ${CMAKE_CURRENT_SOURCE_DIR}/postinst DESTINATION ${PROJECT_BINARY_DIR} PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA ${PROJECT_BINARY_DIR}/postinst;)

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "libjpeg-dev, libgstreamer0.10-dev, libv4l-dev, libdc1394-22-dev, libgl1-mesa-dev, freeglut3-dev, libopenscenegraph-dev, libopencv-dev, libc6")

##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.

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

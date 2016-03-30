cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)

include(../../cpackConfiguration.cmake)
include(../cpackDebConfiguration.cmake)
include(../../cpackArtoolkit-libConfiguration.cmake)

#TODO: Somehow the CMake build produces an ARWrapper.so file that contains debug information. We do not want that. That is why we strip it here.
execute_process(COMMAND strip -s -o ${BUILD_ARTEFACTS_DIR}lib/${BUILD_ARTEFACTS_PREFIX}ARWrapper.so ${BUILD_ARTEFACTS_DIR}lib/${BUILD_ARTEFACTS_PREFIX}ARWrapper.so)

#Include all the libs into the package
INSTALL(DIRECTORY ${BUILD_ARTEFACTS_DIR}lib DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE 
)

##According to the packaging guidelines we need a post installation script to call `ldconfig` after installation. This is the case because we install a dynamic library (ARWrapper.so)
#change the postinst file permissions and include them into the package. Permission needs to be 755
file(INSTALL ${CMAKE_CURRENT_SOURCE_DIR}/postinst DESTINATION ${PROJECT_BINARY_DIR} PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
SET(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA ${PROJECT_BINARY_DIR}/postinst;)

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS ${DEPENDENCIES})

##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.



INCLUDE(CPack)

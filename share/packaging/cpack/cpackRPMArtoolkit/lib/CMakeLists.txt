cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-lib)

include(../../cpackConfiguration.cmake)
#include(../cpackDebConfiguration.cmake)
include(../../cpackArtoolkit-libConfiguration.cmake)


#Include all the libs into the package
install(DIRECTORY ${BUILD_ARTEFACTS_DIR}lib DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE 
)

set(CPACK_RPM_PACKAGE_REQUIRES ${DEPENDENCIES})

set(CPACK_RPM_CHANGELOG_FILE ${PROJECT_BINARY_DIR}/ChangeLog.txt)

#Include all the libs into the package
INSTALL(DIRECTORY ${BUILD_ARTEFACTS_DIR}lib DESTINATION /usr DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE 
)

include(CPack)

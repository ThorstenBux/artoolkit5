cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-dev)

include(../../cpackConfiguration.cmake)
include(../cpackDebConfiguration.cmake)


#SETUP directory structure with correct permissions
INSTALL(DIRECTORY DESTINATION /usr/include DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/include/AR DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/include/AR2 DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/include/ARWrapper DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/include/AREden DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)
INSTALL(DIRECTORY DESTINATION /usr/include/KPM DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add the include files
file(GLOB AR_includefiles ${ARTK_HOME}/include/AR/*.h)
file(GLOB AR2_includefiles ${ARTK_HOME}/include/AR2/*.h)
file(GLOB ARWrapper_includefiles ${ARTK_HOME}/include/ARWrapper/*.h)
file(GLOB Eden_includefiles ${ARTK_HOME}/include/Eden/*.h)
file(GLOB KPM1_includefiles ${ARTK_HOME}/include/KPM/*.h)

INSTALL(FILES ${AR_includefiles} DESTINATION include/AR)
INSTALL(FILES ${AR2_includefiles} DESTINATION include/AR2)
INSTALL(FILES ${ARWrapper_includefiles} DESTINATION include/ARWrapper)
INSTALL(FILES ${Eden_includefiles} DESTINATION include/AREden)
INSTALL(FILES ${KPM1_includefiles} DESTINATION include/KPM)

##Add the documentation
INSTALL(DIRECTORY ${ARTK_HOME}/doc DESTINATION /usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )


#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "artoolkit-lib")


##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.

SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit SDK development")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit SDK development package. \n This package contains Contains all necessary libraries and header files to \n start developing with ARToolKit. Also the API documentation is included.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")


INCLUDE(CPack)

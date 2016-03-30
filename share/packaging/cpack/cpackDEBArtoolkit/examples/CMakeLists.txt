cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-examples)

include(../../cpackConfiguration.cmake)
include(../cpackDebConfiguration.cmake)

#Read all util files
file(GLOB AR_examples ${BUILD_ARTEFACTS_DIR}examples/*)

#Set all files from Data/ that we need to include
set(AR_utils_data "${ARTK_HOME}/bin/Data/sample1.patt" "${ARTK_HOME}/bin/Data/sample2.patt" "${ARTK_HOME}/bin/Data/hiro.patt" "${ARTK_HOME}/bin/Data/kanji.patt" "${ARTK_HOME}/bin/Data/cubeMarkerConfig.dat" "${ARTK_HOME}/bin/Data/objects.dat" "${ARTK_HOME}/bin/Data/markers.dat" "${ARTK_HOME}/bin/Data/sample.mov" "${ARTK_HOME}/bin/Data/object_data_vrml")


#TODO: Somehow the CMake build produces util files that contain debug information. We do not want that. That is why we strip it here.
foreach(util-file ${AR_examples})
    execute_process(COMMAND strip -s -o ${util-file} ${util-file})
endforeach(util-file)

#SETUP directory structure with correct permissions
INSTALL(DIRECTORY DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

INSTALL(DIRECTORY DESTINATION /usr/bin DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add the util files
INSTALL(FILES ${AR_examples} DESTINATION bin PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add data files
#Data/
INSTALL(FILES ${AR_utils_data} DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME}/Data)


#bin\Data\multi\*
INSTALL(DIRECTORY ${ARTK_HOME}/bin/Data DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#bin\OSG\*
INSTALL(DIRECTORY "${ARTK_HOME}/bin/OSG" DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#bin\Data2\*
INSTALL(DIRECTORY "${ARTK_HOME}/bin/Data2" DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#bin\DataNFT\*
INSTALL(DIRECTORY "${ARTK_HOME}/bin/DataNFT" DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

#bin\Wrl\*
INSTALL(DIRECTORY "${ARTK_HOME}/bin/Wrl" DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##End add data

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "artoolkit-lib, libc6")

##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.

SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit SDK examples")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit SDK examples package. \n This package contains all ARToolKit examples. These examples include apps that \n demonstrate simple augmented reality applications. \n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

INCLUDE(CPack)

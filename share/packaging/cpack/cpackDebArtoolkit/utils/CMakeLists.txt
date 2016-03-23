cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-utils)

include(../../cpackConfiguration.cmake)
include(../cpackDebConfiguration.cmake)

#Read all util files
file(GLOB AR_utils ${BUILD_ARTEFACTS_DIR}util/*)

#Set all data files that we need to include
set(AR_utils_data "${ARTK_HOME}/bin/Data/camera_para.dat" "${ARTK_HOME}/bin/Data/calibStereoMarkerConfig.dat" "${ARTK_HOME}/bin/Data/calib.patt" "${ARTK_HOME}/bin/Data/hiro.patt")

#TODO: Somehow the CMake build produces util files that contain debug information. We do not want that. That is why we strip it here.
foreach(util-file ${AR_utils})
    execute_process(COMMAND strip -s -o ${util-file} ${util-file})
endforeach(util-file)

#SETUP directory structure with correct permissions
INSTALL(DIRECTORY DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

INSTALL(DIRECTORY DESTINATION /usr/share/${CPACK_DEBIAN_PACKAGE_NAME}/Data DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

INSTALL(DIRECTORY DESTINATION /usr/bin DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add the util binary files
INSTALL(FILES ${AR_utils} DESTINATION bin PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add data files
INSTALL(FILES ${AR_utils_data} DESTINATION share/${CPACK_DEBIAN_PACKAGE_NAME}/Data)

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "artoolkit-lib, libc6")

##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.

SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit SDK utilities")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "ARToolKit SDK utilities package. \n This package contains all ARToolKit utilities. These utilities include apps for\n camera calibration, for optical and stereo calibration. Also several other \n useful tools are included like mk_patt to generate your own markers.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

INCLUDE(CPack)

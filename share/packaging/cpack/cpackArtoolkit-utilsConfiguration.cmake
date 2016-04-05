#Define package description
set(PACKAGE_SUMMARY "ARToolKit SDK utilities")
set(PACKAGE_DESCRIPTION "ARToolKit SDK utilities package. \n This package contains all ARToolKit utilities. These utilities include apps for\n camera calibration, for optical and stereo calibration. Also several other \n useful tools are included like mk_patt to generate your own markers.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

if(${CPACK_GENERATOR} STREQUAL "DEB")
    string(CONCAT summary "${PACKAGE_SUMMARY}" "\n " "${PACKAGE_DESCRIPTION}")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${summary})
elseif (${CPACK_GENERATOR} STREQUAL "RPM")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PACKAGE_SUMMARY})
    set(CPACK_RPM_PACKAGE_DESCRIPTION ${PACKAGE_DESCRIPTION})
endif()

#Read all util files
file(GLOB AR_utils ${BUILD_ARTEFACTS_DIR}util/*)

#Set all data files that we need to include
set(AR_utils_data "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/camera_para.dat" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/calibStereoMarkerConfig.dat" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/calib.patt" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/hiro.patt")

##Add the util binary files
install(FILES ${AR_utils} DESTINATION bin PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)

##Add data files
install(FILES ${AR_utils_data} DESTINATION share/${CPACK_PACKAGE_NAME}/Data)


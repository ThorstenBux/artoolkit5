#Package control file is required and has some important fields that need to be filled.

set(PACKAGE_SUMMARY "ARToolKit SDK examples")

set(PACKAGE_DESCRIPTION "ARToolKit SDK examples package. \n This package contains all ARToolKit examples. These examples include apps that \n demonstrate simple augmented reality applications. \n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

if(${CPACK_GENERATOR} STREQUAL "DEB")
    string(CONCAT summary "${PACKAGE_SUMMARY}" "\n " "${PACKAGE_DESCRIPTION}")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${summary})
elseif (${CPACK_GENERATOR} STREQUAL "RPM")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PACKAGE_SUMMARY})
    set(CPACK_RPM_PACKAGE_DESCRIPTION ${PACKAGE_DESCRIPTION})
endif()

#Read all example files
file(GLOB AR_examples ${BUILD_ARTEFACTS_DIR}examples/*)

#Set all files from Data/ that we need to include
set(AR_examples_data "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/sample1.patt" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/sample2.patt" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/hiro.patt" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/kanji.patt" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/cubeMarkerConfig.dat" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/objects.dat" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/markers.dat" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/sample.mov" "${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/object_data_vrml")

##Add the example files
INSTALL(FILES ${AR_examples} DESTINATION bin PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE)


##Add data files
#Data/
install(FILES ${AR_examples_data} DESTINATION share/${CPACK_PACKAGE_NAME}/Data)

#bin\Data\multi\*
file(GLOB AR_examples_Data_multi ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data/multi/*.*)
install(FILES ${AR_examples_Data_multi} DESTINATION share/${CPACK_PACKAGE_NAME}/Data/multi)

#bin\OSG\*
file(GLOB AR_examples_OSG ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/OSG/*.*)
install(FILES ${AR_examples_OSG} DESTINATION share/${CPACK_PACKAGE_NAME}/OSG)
file(GLOB AR_examples_OSG_Images ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/OSG/Images/*.*)
install(FILES ${AR_examples_OSG_Images} DESTINATION share/${CPACK_PACKAGE_NAME}/OSG/Images)

#bin\Data2\*
file(GLOB AR_examples_Data2 ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Data2/*.*)
install(FILES ${AR_examples_Data2} DESTINATION share/${CPACK_PACKAGE_NAME}/Data2 )
#bin\DataNFT\*
file(GLOB AR_examples_Data_NFT ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/DataNFT/*.*)
install(FILES ${AR_examples_Data_NFT} DESTINATION share/${CPACK_PACKAGE_NAME}/DataNFT )

#bin\Wrl\*
file(GLOB AR_examples_Wrl ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Wrl/*.*)
install(FILES ${AR_examples_Wrl} DESTINATION share/${CPACK_PACKAGE_NAME}/Wrl )
file(GLOB AR_examples_Wrl_maps ${ARTK_HOME}/share/${CPACK_PACKAGE_NAME}/Wrl/maps/*.*)
install(FILES ${AR_examples_Wrl_maps} DESTINATION share/${CPACK_PACKAGE_NAME}/Wrl/maps )

##End add data

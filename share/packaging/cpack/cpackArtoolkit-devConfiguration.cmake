#Package control file is required and has some important fields that need to be filled.

set(PACKAGE_SUMMARY "ARToolKit SDK development")

set(PACKAGE_DESCRIPTION "ARToolKit SDK development package. \n This package contains all necessary libraries and header files to \n start developing with ARToolKit. Also the API documentation is included.\n For more information visit www.ARToolKit.org. \n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

if(${CPACK_GENERATOR} STREQUAL "DEB")
    string(CONCAT summary "${PACKAGE_SUMMARY}" "\n " "${PACKAGE_DESCRIPTION}")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${summary})
elseif (${CPACK_GENERATOR} STREQUAL "RPM")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PACKAGE_SUMMARY})
    set(CPACK_RPM_PACKAGE_DESCRIPTION ${PACKAGE_DESCRIPTION})
endif()

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
INSTALL(DIRECTORY ${ARTK_HOME}/doc/ DESTINATION /usr/share/doc/${CMAKE_PROJECT_NAME} DIRECTORY_PERMISSIONS
OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE )

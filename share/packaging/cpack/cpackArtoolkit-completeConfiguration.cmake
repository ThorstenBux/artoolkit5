#Define package description
SET(PACKAGE_SUMMARY "ARToolKit SDK")
SET(PACKAGE_DESCRIPTION "Full ARToolKit installation, with libraries, header files, utilities \n and binaries. ARToolKit is a free and open source software development kit for \n augmented reality applications. This package depends on the library, \n development, utilities and example packages of ARToolKit.\n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

if(${CPACK_GENERATOR} STREQUAL "DEB")
    string(CONCAT summary "${PACKAGE_SUMMARY}" "\n " "${PACKAGE_DESCRIPTION}")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${summary})
elseif (${CPACK_GENERATOR} STREQUAL "RPM")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ${PACKAGE_SUMMARY})
    set(CPACK_RPM_PACKAGE_DESCRIPTION ${PACKAGE_DESCRIPTION})
endif()


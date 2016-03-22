cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit)

include(../../cpackConfiguration.cmake)
include(../cpackDebConfiguration.cmake)

#Name needed dependencies
SET(CPACK_DEBIAN_PACKAGE_DEPENDS "artoolkit-lib, artoolkit-dev, artoolkit-examples, artoolkit-utils")

##Include the changelog files
#Two changelog files are shipped. One that comes with the SDK and one that is in the DEB format to fullfill the DEB package needs.
install(FILES "${PROJECT_BINARY_DIR}/changelog.gz"
              "${PROJECT_BINARY_DIR}/changelog.Debian.gz"
              DESTINATION "/usr/share/doc/${CPACK_DEBIAN_PACKAGE_NAME}")
#INFO: In a regular deb file the changelog and the copyright file go directly into the DEBIAN directory. But that is not supported by CPACK. 
#As we like to provide them we ship them using the /usr/share/doc/ProjectName/ directory.

SET(CPACK_PACKAGE_DESCRIPTION "ARToolKit SDK")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Full ARToolKit installation, with libraries, header files, utilities \n and binaries. ARToolKit is a free and open source software development kit for \n augmented reality applications. This package depends on the library, \n development, utilities and example packages of ARToolKit.\n Fork us on Github https://github.com/artoolkit/artoolkit5 \n .\n Follow us on Twitter: twitter.com/artoolkit_")

INCLUDE(CPack)

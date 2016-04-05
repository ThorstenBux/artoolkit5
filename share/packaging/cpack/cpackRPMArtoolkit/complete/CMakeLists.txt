cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit)

include(../../cpackConfiguration.cmake)
include(../../cpackArtoolkit-completeConfiguration.cmake)
include(../cpackRpmConfiguration.cmake)

#Name needed dependencies
SET(CPACK_RPM_PACKAGE_REQUIRES "artoolkit-lib, artoolkit-dev, artoolkit-examples, artoolkit-utils")

INCLUDE(CPack)

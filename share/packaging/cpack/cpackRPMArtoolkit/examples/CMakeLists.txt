cmake_minimum_required(VERSION 3.4)
 
PROJECT(artoolkit-examples)

include(../../cpackConfiguration.cmake)
include(../../cpackArtoolkit-examplesConfiguration.cmake)
include(../cpackRpmConfiguration.cmake)

#Name needed dependencies
SET(CPACK_RPM_PACKAGE_REQUIRES "artoolkit-lib")

INCLUDE(CPack)

project("artoolkit-lib")
cmake_minimum_required(VERSION 3.4)

INCLUDE(../config.cmake)

#All AR lib related sources
file(GLOB_RECURSE LIB_AR_SRCS ${ARTK_SRC_DIR}/AR/*.c)
#All ARICP lib related sources
file(GLOB_RECURSE LIB_ARICP_SRCS ${ARTK_SRC_DIR}/ARICP/*.c)
#All AR2 lib related sources
file(GLOB_RECURSE LIB_AR2_SRCS ${ARTK_SRC_DIR}/AR2/*.c)
#All KPM lib related sources
file(GLOB LIB_KPM_SRCS ${ARTK_SRC_DIR}/KPM/*.c 
                        ${ARTK_SRC_DIR}/KPM/*.cpp
                        ${ARTK_SRC_DIR}/KPM/FreakMatcher/detectors/*.cpp
                        ${ARTK_SRC_DIR}/KPM/FreakMatcher/facade/visual_database_facade.cpp
                        ${ARTK_SRC_DIR}/KPM/FreakMatcher/matchers/freak.cpp
                        ${ARTK_SRC_DIR}/KPM/FreakMatcher/matchers/hough_similarity_voting.cpp
                        ${ARTK_SRC_DIR}/KPM/FreakMatcher/framework/*.cpp

)
#All Util lib related sources
file(GLOB_RECURSE LIB_Util_SRCS ${ARTK_SRC_DIR}/Util/*.c)
#All ARMulti lib related sources
file(GLOB_RECURSE LIB_ARMulti_SRCS ${ARTK_SRC_DIR}/ARMulti/*.c)
#All ARg lib related sources
file(GLOB_RECURSE LIB_ARg_SRCS ${ARTK_SRC_DIR}/Gl/arg*.c)
#All ARg lib related sources
file(GLOB_RECURSE LIB_ARgLite_SRCS ${ARTK_SRC_DIR}/Gl/gsub_lite.c ${ARTK_SRC_DIR}/Gl/gsub_mtx.c)
#All ARVideo lib related sources
file(GLOB_RECURSE LIB_ARVideo_SRCS ${ARTK_SRC_DIR}/VideoDummy/*.c ${ARTK_SRC_DIR}/Video/*.c ${ARTK_SRC_DIR}/VideoLinux1394Cam/*.c ${ARTK_SRC_DIR}/VideoLinuxV4L/*.c ${ARTK_SRC_DIR}/VideoLinuxV4L2/*.c ${ARTK_SRC_DIR}/VideoGStreamer/*.c)
#All Eden lib related sources
file(GLOB_RECURSE LIB_Eden_SRCS ${ARTK_SRC_DIR}/Eden/*.c ${ARTK_SRC_DIR}/Eden/*.cpp)
#All ARWrapper lib related sources
file(GLOB_RECURSE LIB_ARWrapper_SRCS ${ARTK_SRC_DIR}/ARWrapper/*.c ${ARTK_SRC_DIR}/ARWrapper/*.cpp)
#All AROSG lib related sources
file(GLOB_RECURSE LIB_AROSG_SRCS ${ARTK_SRC_DIR}/ARosg/*.cpp)

#message(STATUS "${LIB_ARWrapper_SRCS}")

##Find used modules
#Find OpenGL config to include
find_package(glibConfig REQUIRED)
#message(STATUS "${GLIB2_INCLUDE_DIR}")

#Find GStreamer
find_package(GStreamer REQUIRED)
#message(STATUS "GStreamer: ${GSTREAMER_INCLUDE_DIRS}")

#Find LibXML2
find_package(LibXml2 REQUIRED)
#message(STATUS "LibXML2: ${LIBXML2_INCLUDE_DIR}")

#Find OSG

#All headers to include
include_directories(${GLIB2_INCLUDE_DIR} 
                    ${GSTREAMER_INCLUDE_DIRS} 
                    ${LIBXML2_INCLUDE_DIR} 
                    ${ARTK_HOME}/include 
                    ${ARTK_HOME}/lib/SRC/KPM
                    ${ARTK_HOME}/lib/SRC/KPM/FreakMatcher
)

get_property(dirs DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
message(STATUS "INCLUDE_DIRS: ${dirs}")

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${OUTPUT_DIR}lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR}lib)

#Compile all libraries
add_library(AR ${LIB_AR_SRCS})
add_library(AR2 ${LIB_AR2_SRCS})
add_library(ARICP ${LIB_ARICP_SRCS})
add_library(KPM ${LIB_KPM_SRCS})
add_library(Util ${LIB_Util_SRCS})
add_library(ARMulti ${LIB_ARMulti_SRCS})
add_library(ARgsub ${LIB_ARg_SRCS})
add_library(ARgsub_lite ${LIB_ARgLite_SRCS})
add_library(ARVideo ${LIB_ARVideo_SRCS})
add_library(Eden ${LIB_Eden_SRCS})
add_library(ARWrapper SHARED ${LIB_Eden_SRCS})
add_library(ARosg ${LIB_AROSG_SRCS})

set_property(TARGET KPM PROPERTY CXX_STANDARD 11)

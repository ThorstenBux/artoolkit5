set(ARTK_HOME ../../..)
set(ARTK_SRC_DIR ${ARTK_HOME}/lib/SRC)

#Set the path that is used to look for additional modules. The modules them selves are used later 
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/../modules/")

#Read the CPU architecture
#EXECUTE_PROCESS( COMMAND uname -m COMMAND tr -d '\n' OUTPUT_VARIABLE ARCHITECTURE )
message( STATUS "Architecture: ${ARCHITECTURE}" )

#Copy the config.h to the needed directory
#file(RENAME ../config_LinuxSDK.h ${ARTK_HOME}/include/AR/config.h)

#We read in the config.h.in file to make configuration and then write it out as config.h
#Due to strange behaviour with semicolons (;) (cmake dropps then when reading files with FILE(READ ...) ) we have to read the file with FILE(STRINGS ...) and ensure that
#new lines are still there with NEWLINE_CONSUME.
#Unfortunately that leads to cmake adding a backslash (\) to all semicolons. We replace them prior to writing the file out later.
FILE(STRINGS ${ARTK_HOME}/include/AR/config.h.in CONFIG_H_IN NEWLINE_CONSUME)

#Enable all video modes and set GStreamer to default
#string(REPLACE <match_string> <replace_string> <output variable> <input> [<input>...])

string(REPLACE "\#undef  AR_INPUT_V4L" "\#define AR_INPUT_V4L" OUTPUT_VAR "${CONFIG_H_IN}")
string(REPLACE "\#undef  AR_INPUT_1394CAM" "\#define AR_INPUT_1394CAM" OUTPUT_VAR "${OUTPUT_VAR}")
string(REPLACE "\#undef  AR_INPUT_GSTREAMER" "\#define AR_INPUT_GSTREAMER" OUTPUT_VAR "${OUTPUT_VAR}")
string(REPLACE "\#undef  AR_DEFAULT_INPUT_GSTREAMER" "\#define AR_DEFAULT_INPUT_GSTREAMER" OUTPUT_VAR "${OUTPUT_VAR}")
string(REPLACE "\#undef AR_INPUT_1394CAM_USE_LIBDC1394_V2" "\#define AR_INPUT_1394CAM_USE_LIBDC1394_V2" OUTPUT_VAR "${OUTPUT_VAR}")
string(REPLACE "\#define   AR_INPUT_1394CAM_DEFAULT_PIXEL_FORMAT   AR_PIXEL_FORMAT_MONO" "\#define   AR_INPUT_1394CAM_DEFAULT_PIXEL_FORMAT   AR_PIXEL_FORMAT_RGB" OUTPUT_VAR "${OUTPUT_VAR}")

#Replace \; with ; as noted during reading the file and write it to config.h
string(REPLACE "\;" ";" OUTPUT_VAR "${OUTPUT_VAR}")
FILE(WRITE ${ARTK_HOME}/include/AR/config.h "${OUTPUT_VAR}")

#CMAKE compiler flags need to be set after the 'project'-command that is why we cannot define them in the 64bitLinuxConfiguration.cmake file up front
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=core2")

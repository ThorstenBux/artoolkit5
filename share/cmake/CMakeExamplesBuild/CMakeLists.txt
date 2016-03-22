project("ARToolKit_Examples")
cmake_minimum_required(VERSION 3.4)

INCLUDE(../config.cmake)

set(ARTK_EXAMPLE_SRC ${ARTK_HOME}/examples)

#SimpleLite sources
file(GLOB simpleLite_SRCS ${ARTK_EXAMPLE_SRC}/simpleLite/*.c)
#SimpleTest sources
file(GLOB simpleTest_SRCS ${ARTK_EXAMPLE_SRC}/simple/*.c)
#MultiTest sources
file(GLOB multiTest_SRCS ${ARTK_EXAMPLE_SRC}/multi/*.c)
#MultiCube sources
file(GLOB multiCube_SRCS ${ARTK_EXAMPLE_SRC}/multiCube/*.c)
#multiWin sources
file(GLOB multiWin_SRCS ${ARTK_EXAMPLE_SRC}/multiWin/*.c)
#nftSimple sources
file(GLOB nftSimple_SRCS ${ARTK_EXAMPLE_SRC}/nftSimple/*.c)
#stereo sources
file(GLOB stereo_SRCS ${ARTK_EXAMPLE_SRC}/stereo/*.c)
#simpleMovie sources
file(GLOB simpleMovie_SRCS ${ARTK_EXAMPLE_SRC}/simpleMovie/*.c)
#simpleOSG sources
file(GLOB simpleOSG_SRCS ${ARTK_EXAMPLE_SRC}/simpleOSG/*.c)
#optical sources
file(GLOB optical_SRCS ${ARTK_EXAMPLE_SRC}/optical/*.c)
#opticalStereo sources
file(GLOB opticalStereo_SRCS ${ARTK_EXAMPLE_SRC}/opticalStereo/*.c)
#nftBook sources
file(GLOB nftBook_SRCS ${ARTK_EXAMPLE_SRC}/nftBook/*.c)

#All headers to include
include_directories(${ARTK_HOME}/include
                    ${ARTK_HOME}/lib/SRC/KPM
                    ${ARTK_HOME}/lib/SRC/KPM/FreakMatcher
                    ${ARTK_HOME}/examples/stereo/
)
#Link to the ARToolkit libs
link_directories(${OUTPUT_DIR}lib/)

#set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR}examples/)

#Compile all executables
add_executable(simpleLite ${simpleLite_SRCS})
add_executable(simpleTest ${simpleTest_SRCS})
add_executable(simpleMovie ${simpleMovie_SRCS})
add_executable(simpleOSG ${simpleOSG_SRCS})
add_executable(multiTest ${multiTest_SRCS})
add_executable(multiCube ${multiCube_SRCS})
add_executable(multiWin ${multiWin_SRCS})
add_executable(nftSimple ${nftSimple_SRCS})
add_executable(nftBook ${nftBook_SRCS})
add_executable(stereo ${stereo_SRCS})
add_executable(optical ${optical_SRCS})
add_executable(opticalStereo ${opticalStereo_SRCS})

set(LIBS_Simple ARgsub_lite ARgsub ARVideo AR ARICP AR glut GLU GL gstreamer-0.10 m pthread gobject-2.0 glib-2.0 dc1394 jpeg OpenThreads)

set(LIBS_OSG ARosg osgGA osgViewer osgUtil osgFX osgDB osg)

#Link executables with required libs
target_link_libraries(simpleLite ${LIBS_Simple})
target_link_libraries(simpleTest ${LIBS_Simple})
target_link_libraries(simpleMovie ${LIBS_Simple})
target_link_libraries(simpleOSG ${LIBS_OSG}  ${LIBS_Simple})
target_link_libraries(multiTest ARMulti ${LIBS_Simple})
target_link_libraries(multiCube ARMulti ${LIBS_Simple})
target_link_libraries(multiWin ARMulti ${LIBS_Simple})
target_link_libraries(nftSimple KPM AR2 Util ${LIBS_Simple})
target_link_libraries(nftBook ${LIBS_OSG} KPM AR2 Util ${LIBS_Simple})
target_link_libraries(stereo ${LIBS_OSG} ${LIBS_Simple})
target_link_libraries(optical ${LIBS_OSG} ${LIBS_Simple})
target_link_libraries(opticalStereo ${LIBS_OSG}  ${LIBS_Simple})

SET_TARGET_PROPERTIES(nftSimple PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(nftBook PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(simpleOSG PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(stereo PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(optical PROPERTIES LINKER_LANGUAGE CXX)
SET_TARGET_PROPERTIES(opticalStereo PROPERTIES LINKER_LANGUAGE CXX)

INSTALL(TARGETS simpleLite simpleTest simpleMovie simpleOSG multiTest multiCube multiWin nftSimple nftBook stereo optical opticalStereo
RUNTIME DESTINATION ${OUTPUT_DIR}examples/)


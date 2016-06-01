set(CMAKE_SYSTEM_NAME Linux)

#If we do not set the C-Compiler cmake uses the system standard c compiler which is not what we want on the build system
set(CMAKE_C_COMPILER gcc -m64)
set(CMAKE_CXX_COMPILER g++ -m64)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=core2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=core2")


set(OUTPUT_DIR ${CMAKE_INSTALL_PREFIX})

set(ARCHITECTURE x86_64)



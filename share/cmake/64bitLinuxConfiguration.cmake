set(CMAKE_SYSTEM_NAME Linux)

#If we do not set the C-Compiler cmake uses the system standard c compiler which is not what we want on the build system
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)

set(OUTPUT_DIR ${CMAKE_INSTALL_PREFIX})

set(ARCHITECTURE x86_64)



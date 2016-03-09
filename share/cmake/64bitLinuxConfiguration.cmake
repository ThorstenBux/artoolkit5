set(CMAKE_SYSTEM_NAME Linux)

#If we do not set the C-Compiler cmake uses the system standard c compiler which is not what we want on the build system
set(CMAKE_C_COMPILER gcc -m64)
set(CMAKE_CXX_COMPILER g++ -m64)

set(OUTPUT_DIR /opt/jenkins/artoolkitBuildArtifacts/64bit/)

set(ARCHITECTURE x86_64)



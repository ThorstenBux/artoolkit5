set(CMAKE_SYSTEM_NAME Linux)

#If we do not set the C-Compiler cmake uses the system standard c compiler which is not what we want on the build system
set(CMAKE_C_COMPILER gcc -m32)
set(CMAKE_CXX_COMPILER g++ -m32)

set(OUTPUT_DIR /opt/jenkins/artoolkitBuildArtifacts/32bit/)

set(ARCHITECTURE i686)

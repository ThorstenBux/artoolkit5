rm -r CMakeFiles
rm CMakeCache.txt
rm cmake_install.cmake
rm Makefile
cmake -DCMAKE_TOOLCHAIN_FILE=../64bitLinuxConfiguration.cmake ../CMakeLibBuild/
make

rm -r CMakeFiles
rm CMakeCache.txt
rm cmake_install.cmake
rm Makefile
cmake -DCMAKE_TOOLCHAIN_FILE=../64bitLinuxConfiguration.cmake ../CMakeUtilBuild/
make

rm -r CMakeFiles
rm CMakeCache.txt
rm cmake_install.cmake
rm Makefile
cmake -DCMAKE_TOOLCHAIN_FILE=../64bitLinuxConfiguration.cmake ../CMakeExamplesBuild/
make

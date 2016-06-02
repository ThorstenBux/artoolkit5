rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake ../../CMakeLibBuild/
make install VERBOSE=1

cd ..
rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake ../../CMakeUtilBuild/
make install

cd ..
rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake ../../CMakeExamplesBuild/
make install

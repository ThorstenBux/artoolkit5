rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../32bitLinuxConfiguration.cmake ../../CMakeLibBuild/
make install

cd ..
rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../32bitLinuxConfiguration.cmake ../../CMakeUtilBuild/
make install

cd ..
rm -rf ./build
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../../32bitLinuxConfiguration.cmake ../../CMakeExamplesBuild/
make install

rm -rf ./workingDir
mkdir workingDir
cd workingDir
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake -DCMAKE_INSTALL_PREFIX=~/output/ ../../CMakeLibBuild/
make install

cd ..
rm -rf ./workingDir
mkdir workingDir
cd workingDir
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake -DCMAKE_INSTALL_PREFIX=~/output/ ../../CMakeUtilBuild/
make install VERBOSE=1

cd ..
rm -rf ./workingDir
mkdir workingDir
cd workingDir
cmake -DCMAKE_TOOLCHAIN_FILE=../../64bitLinuxConfiguration.cmake -DCMAKE_INSTALL_PREFIX=~/output/ ../../CMakeExamplesBuild/
make install

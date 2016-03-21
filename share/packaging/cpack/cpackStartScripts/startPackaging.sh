rm -rf ../cmakepackaging/*
cd ../cmakepackaging
cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit-lib/
cpack



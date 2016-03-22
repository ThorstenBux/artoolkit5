mkdir ../packages
mkdir ../cmakepackaging

echo "Do you want to build the artoolkit-lib package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit/lib/
    cpack
    mv *.deb ../packages/
fi

echo "Do you want to build the artoolkit-dev package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit/dev/
    cpack
    mv *.deb ../packages/
fi

echo "Do you want to build the artoolkit-examples package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit/examples/
    cpack
    mv *.deb ../packages/
fi

echo "Do you want to build the artoolkit-utils package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit/utils/
    cpack
    mv *.deb ../packages/
fi

echo "Do you want to build the artoolkit complete meta package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR="DEB" ../cpackDebArtoolkit/complete/
    cpack
    mv *.deb ../packages/
fi

echo "Packages generated to ../packages/"

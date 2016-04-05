mkdir ../packages
mkdir ../cmakepackaging

echo "Do you want to build DEB or RPM packages? (d or r)"
echo -n "Enter : "
read ANS 
if [ "$ANS" = "d" ] 
then
   packageGenerator="DEB"
else
   packageGenerator="RPM"
fi


echo "Do you want to build the artoolkit-lib package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR=$packageGenerator ../cpack"$packageGenerator"Artoolkit/lib/
    cpack
    mv *.${packageGenerator,,} ../packages/
fi

echo "Do you want to build the artoolkit-dev package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR=$packageGenerator ../cpack"$packageGenerator"Artoolkit/dev/
    cpack
    mv *.${packageGenerator,,} ../packages/
fi

echo "Do you want to build the artoolkit-examples package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR=$packageGenerator ../cpack"$packageGenerator"Artoolkit/examples/
    cpack
    mv *.${packageGenerator,,} ../packages/
fi

echo "Do you want to build the artoolkit-utils package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR=$packageGenerator ../cpack"$packageGenerator"Artoolkit/utils/
    cpack
    mv *.${packageGenerator,,} ../packages/
fi

echo "Do you want to build the artoolkit complete meta package? (y or n)"
echo -n "Enter : "
read ANS
if [ "$ANS" = "y" ] 
then
    rm -rf ../cmakepackaging/*
    cd ../cmakepackaging
    cmake -DCPACK_GENERATOR=$packageGenerator ../cpack"$packageGenerator"Artoolkit/complete/
    cpack
    mv *.${packageGenerator,,} ../packages/
fi

echo "Packages generated to ../packages/"

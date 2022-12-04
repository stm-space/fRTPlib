#!/bin/bash
# example
# sh build_ios_example.sh x86_64
# sh build_ios_example.sh i386
# sh build_ios_example.sh arm64
# sh build_ios_example.sh armv7

#check input
if [ -z "$1" ]
then
    echo "Error: need input param! As sh build_ios_example.sh [x86_64 | i386 | arm64 | armv7]"
    exit 1
fi

#build
root_path=`pwd`
mkdir -p build/ios
cd build/ios

if [ $1 == "x86_64" ]
then
    echo "build arch: x86_64"
    archs=("x86_64")
elif [ $1 == "i386" ]
then
    echo "build arch: i386"
    archs=("i386")
elif [ $1 == "arm64" ]
then
    echo "build arch: arm64"
    archs=("arm64")
elif [ $1 == "armv7" ]
then
    echo "build arch: armv7"
    archs=("armv7")
else
    echo "Error: need input param! As sh build_ios_example.sh [x86_64 | i386 | arm64 | armv7]"
    exit 1
fi

for arch in ${archs[@]};do
    cmake -G "Xcode" ../../ -DCMAKE_TOOLCHAIN_FILE=../../cmake/toolchains/ios.cmake -DSTM_IOS_ACTIVE_ARCH="${arch}" -DENABLE_DEMO=ON -DCMAKE_BUILD_TYPE=Debug
done

open ${root_path}/build/ios/stmrtp.xcodeproj

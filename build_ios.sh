#!/bin/bash

#build
rm -rf build/ios
mkdir -p build/ios && cd build/ios
build_path=`pwd`

SDK_LIB_NAME="libstmrtp.a"

archs=("i386" "x86_64" "armv7" "arm64")
for arch in ${archs[@]};do
    cd ${build_path}
    mkdir -p ${arch} && cd ${arch}

    cmake -G "Xcode" ../../../ -DCMAKE_TOOLCHAIN_FILE=../../../cmake/toolchains/ios.cmake -DSTM_IOS_ACTIVE_ARCH="${arch}" -DCMAKE_BUILD_TYPE=Release
    cmake --build . --config Release
done

cd ${build_path}
mkdir -p Release
lipo -create ./i386/Release-iphonesimulator/${SDK_LIB_NAME} \
./x86_64/Release-iphonesimulator/${SDK_LIB_NAME} \
./armv7/Release-iphoneos/${SDK_LIB_NAME} \
./arm64/Release-iphoneos/${SDK_LIB_NAME} \
-output ./Release/${SDK_LIB_NAME}

#show archs
lipo -info ./Release/${SDK_LIB_NAME}

#copy public header files
mkdir -p Release/include
cp ../../src/frtp.h ./Release/include/frtp.h
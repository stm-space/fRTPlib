#!/bin/bash

#build
rm -rf build/mac
mkdir -p build/mac && cd build/mac

cmake -G "Xcode" ../../ \
-DCMAKE_TOOLCHAIN_FILE=../../cmake/toolchains/mac.cmake \
-DCMAKE_C_COMPILER=`xcrun -find cc` \
-DCMAKE_CXX_COMPILER=`xcrun -find c++`

cmake --build . --config Release

#show archs
lipo -info ./Release/libstmrtp.a

#copy public header files
mkdir -p Release/include
cp ../../src/frtp.h ./Release/include/frtp.h
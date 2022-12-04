#!/bin/bash
root_path=`pwd`

#build
rm -rf build/linux
mkdir -p build/linux && cd build/linux

cmake ../../ -DCMAKE_TOOLCHAIN_FILE=../../cmake/toolchains/linux.cmake
cmake --build . --config Release

#copy public header files
mkdir -p Release/include
cp ../../src/frtp.h ./Release/include/frtp.h
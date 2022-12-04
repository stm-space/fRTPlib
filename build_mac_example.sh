#!/bin/bash
# example
# sh build_mac_example.sh

#build
root_path=`pwd`
mkdir -p build/mac
cd build/mac

cmake -G "Xcode" ../../ -DCMAKE_TOOLCHAIN_FILE=../../cmake/toolchains/mac.cmake -DENABLE_DEMO=ON -DCMAKE_BUILD_TYPE=Debug

open ${root_path}/build/mac/stmrtp.xcodeproj

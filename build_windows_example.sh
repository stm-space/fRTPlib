#!/bin/bash
# example
# sh build_windows_example.sh x86
# sh build_windows_example.sh x64

#check input
if [ -z "$1" ]
then
    echo "Error: need input param! As sh build_windows_example.sh [x86 | x64]"
    exit 1
fi

#build
root_path=`pwd`
BUILD_TYPE="Debug"

mkdir -p build/windows 
cd build/windows
BUILD_PATH=`pwd`

if [ $1 == "x86" ]
then
    echo "build arch: x86"
    archs=("Win32")
elif [ $1 == "x64" ]
then
    echo "build arch: x64"
    archs=("x64")
else
    echo "Error: need input param! As sh build_windows_example.sh [x86 | x64]"
    exit 1
fi

for arch in ${archs[@]};do
    cd ${BUILD_PATH}
    mkdir -p ${arch} && cd ${arch}

    cmake ../../../ -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -A ${arch} -DSTM_BUILD_SHARED=ON
done

start ${root_path}/build/windows/$1/stmrtp.sln

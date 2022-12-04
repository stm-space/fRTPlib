#!/bin/bash
# example
# sh build_windows.sh
#
# sh build_windows.sh aaa/bbb/ccc/
# aaa/bbb/ccc/ is output path

root_path=`pwd`
BUILD_TYPE="Release"

#check input
if [ -z "$1" ]
then
    output_path=${root_path}
else
    output_path=$1
fi
echo "output_path: ${output_path}"

rm -rf ${output_path}/build/windows
mkdir -p ${output_path}/build/windows && cd ${output_path}/build/windows
BUILD_PATH=`pwd`

archs=("Win32" "x64")
for arch in ${archs[@]};do
    echo "build arch: ${arch}"

    cd ${BUILD_PATH}
    mkdir -p ${arch} && cd ${arch}
    
    cmake ${root_path} -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -A ${arch} -DSTM_BUILD_SHARED=ON

    cmake --build . --config ${BUILD_TYPE} --target stmrtp
done

#copy libs
cd ${BUILD_PATH}
mkdir -p ${BUILD_TYPE}/lib
for arch in ${archs[@]};do
    mkdir -p ${BUILD_TYPE}/lib/${arch}
    cp -rf ./${arch}/${BUILD_TYPE}/* ./${BUILD_TYPE}/lib/${arch}/
done

#copy public header files
cd ${BUILD_PATH}
mkdir -p ${BUILD_TYPE}/include
cp -rf ${root_path}/src/frtp.h ./${BUILD_TYPE}/include/

#rename filepath
cd ${BUILD_PATH}/${BUILD_TYPE}/lib
mv Win32 x86
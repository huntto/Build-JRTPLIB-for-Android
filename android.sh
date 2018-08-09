#!/bin/sh

BUILD_ANDROID_ARCH_ABI='armeabi-v7a'


for valid_arch_abi in '86' 'x86_64' 'mips' 'mips64' 'armeabi' 'armeabi-v7a' 'arm64-v8a'; do
	if [ "$1" = "$valid_arch_abi" ]; then
		BUILD_ANDROID_ARCH_ABI=${valid_arch_abi}
		break
	fi
done

if [ -z $2 ];then # null
	API_LEVEL=21
elif [ $2 = ~^[0-9] ];then # not number
	API_LEVEL=21
elif [ $2 -lt 9 ];then
    API_LEVEL=9
elif [ $2 -gt 50 ];then
    API_LEVEL=21
else
	API_LEVEL=$2
fi

export API_LEVEL

echo "Build ${BUILD_ANDROID_ARCH_ABI} ${API_LEVEL}"
export BUILD_ANDROID_ARCH_ABI

if [ -n $ANDROID_NDK_HOME ]; then
	NDK_ROOT=$ANDROID_NDK_HOME
elif [ -n $NDK_HOME ]; then
	NDK_ROOT=$NDK_HOME
elif [ -n $NDK_PATH ]; then
	NDK_ROOT=$NDK_PATH
fi

if [ -z $NDK_ROOT ]; then
	echo "Can not find path of NDK_ROOT..."
	exit 1
fi

echo "NDK_ROOT=$NDK_ROOT"
export NDK_ROOT

PROJECT_PATH=`pwd`

mkdir android_build
cd android_build
mkdir jthread

mkdir out
cd out
mkdir ${BUILD_ANDROID_ARCH_ABI}


echo "Building JThread..."
cd ${PROJECT_PATH}/android_build/jthread
mkdir ${BUILD_ANDROID_ARCH_ABI}
cd ${BUILD_ANDROID_ARCH_ABI}

cmake -DCMAKE_TOOLCHAIN_FILE=${PROJECT_PATH}/toolchain.cmake \
		-DCMAKE_SYSTEM_VERSION=${API_LEVEL} \
		-DCMAKE_ANDROID_ARCH_ABI=${BUILD_ANDROID_ARCH_ABI} \
		-DCMAKE_ANDROID_NDK=${NDK_ROOT} \
		-DCMAKE_INSTALL_PREFIX=${PROJECT_PATH}/android_build/out/${BUILD_ANDROID_ARCH_ABI} \
		-G "Ninja" ${PROJECT_PATH}/JThread/ && ninja && ninja install


echo "Building JRTPLIB..."
cd ${PROJECT_PATH}/android_build
mkdir jrtplib
cd jrtplib
mkdir ${BUILD_ANDROID_ARCH_ABI}
cd ${BUILD_ANDROID_ARCH_ABI}

cmake -DCMAKE_TOOLCHAIN_FILE=${PROJECT_PATH}/toolchain.cmake \
		-DJRTPLIB_USE_BIGENDIAN=FALSE \
		-DCMAKE_SYSTEM_VERSION=${API_LEVEL} \
		-DCMAKE_ANDROID_ARCH_ABI=${BUILD_ANDROID_ARCH_ABI} \
		-DCMAKE_ANDROID_NDK=${NDK_ROOT} \
		-DCMAKE_INSTALL_PREFIX=${PROJECT_PATH}/android_build/out/${BUILD_ANDROID_ARCH_ABI} \
		-DCMAKE_FIND_ROOT_PATH=${PROJECT_PATH}/android_build/out/${BUILD_ANDROID_ARCH_ABI} \
		-G "Ninja" ${PROJECT_PATH}/JRTPLIB/ && ninja && ninja install
# HOW TO USE

1. install [ninja](https://ninja-build.org/), like
```
brew install ninja
```

2. set `NDK_ROOT`, like
```
NDK_ROOT=${HOME}/Library/Android/sdk/ndk-bundle
export NDK_ROOT
```
3. clone this repository
```
git clone https://github.com/huntto/Build-JRTPLIB-for-Android --recursive
```
4. change directory
```
cd Build-JRTPLIB-for-Android
```
run build shell
```
./android.sh
```
or specify android-arch-abi and api-level like
```
./android.sh arm64-v8a 24
```
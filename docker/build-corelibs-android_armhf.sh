#!/bin/sh  -e

#
# Build the Android artifacts inside the circleci linux container
#
set -e

if ! test -d ${BUILD_DIR}; then
  echo "BUILD_DIR does not exist"
  exit 1
fi

if ! test -e ${SRC_DIR}/resources/opencpn.rc.in; then
  echo "SRC_DIR must be set to OpenCPN sources"
  exit 1
fi

cd ${BUILD_DIR}
cmake \
  -DCMAKE_BUILD_TYPE=Release \
  -DOCPN_TARGET_TUPLE:STRING="Android-armhf;16;armhf" \
  -Dtool_base="/home/circleci/android-sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64"\
  ${SRC_DIR}

make

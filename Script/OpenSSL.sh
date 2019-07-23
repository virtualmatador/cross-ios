#!/bin/sh

#  OpenSSL.sh
#  cross
#
#  Created by Ali Asadpoor on 7/18/19.
#  Copyright © 2019 shaidin. All rights reserved.

if [ -d openssl/${ARCHS}/build/include/openssl/ ] && \
    [ -f openssl/${ARCHS}/build/lib/libcrypto.a ] && \
    [ -f openssl/${ARCHS}/build/lib/libssl.a ]
then
    echo "INFO: openssl ${ARCHS} is up to date."
    exit
fi

export CC="${DEVELOPER_BIN_DIR}/gcc -arch ${ARCHS}";
export CROSS_TOP="${PLATFORM_DIR}/Developer"
export CROSS_SDK="${SDK_DIR}"
export BUILD_TOOLS="${DEVELOPER_DIR}"

if [ "${ARCHS}" == "x86_64" ]
then
    flaver="darwin64-x86_64-cc"
elif [ "${ARCHS}" == "arm64" ]
then
    flaver="ios64-cross"
else
    echo "ERROR: Unknown architecture ${ARCHS}"
    exit -1
fi

mkdir -p "openssl/${ARCHS}/"
cd "openssl/${ARCHS}/"

../../../openssl/Configure "${flaver}" no-asm no-shared --prefix="$(pwd)/build/"
if [ $? -ne 0 ]
then
    echo "ERROR: Configure ${ARCHS}"
    exit -1
fi

make
if [ $? -ne 0 ]
then
    echo "ERROR: make ${ARCHS}"
    exit -1
fi

make install
if [ $? -ne 0 ]
then
    echo "ERROR: install ${ARCHS}"
    exit -1
fi

cd ../../

#!/bin/sh

#  Prebuilt.sh
#  cross
#
#  Created by Null on 7/18/19.
#  Copyright © 2019 shaidin. All rights reserved.

echo "info.plist generating ..."
IFS=. idn=(${cross_identifier})
IFS=. vsn=(${cross_version})
cp -f "cross/template-info.plist" "cross/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier '${idn[0]}.${idn[1]}.${idn[2]}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '${idn[2]}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${vsn[0]}.${vsn[1]}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${vsn[2]}'" "cross/info.plist"
echo "info.plist generated."

echo "main.cpp generating ..."
main_cpp="// Auto generated file\n"
for source in ../../src/*.cpp
do
    main_cpp="${main_cpp}#include \"../${source}\"\n"
done
if [ ! -f "cross/main.cpp" ]
then
    touch "cross/main.cpp"
fi
main_cpp_old=$(<"cross/main.cpp")
if [ "${main_cpp}" != "${main_cpp_old}" ]
then
    echo "${main_cpp}" > "cross/main.cpp"
fi
echo "main.cpp generated."

Script/OpenSSL.sh
if [ $? -ne 0 ]
then
    echo "ERROR: building openssl ${ARCHS}"
    exit -1
fi

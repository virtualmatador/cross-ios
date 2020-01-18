#!/bin/sh

#  Prebuilt.sh
#  cross
#
#  Created by Null on 7/18/19.
#  Copyright © 2019 shaidin. All rights reserved.

echo "info.plist generating ..."
IFS=. idn=(${cross_identifier})
cp -f "cross/template-info.plist" "cross/Info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleIdentifier '${cross_identifier}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleName '$(tr '[:lower:]' '[:upper:]' <<< ${idn[2]:0:1})${idn[2]:1}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString '${cross_version}'" "cross/info.plist"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion '${cross_release_number}'" "cross/info.plist"
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

sips --resampleWidth 40 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-20@2.png
sips --resampleWidth 60 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-20@3.png
sips --resampleWidth 58 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-29@2.png
sips --resampleWidth 87 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-29@3.png
sips --resampleWidth 80 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-40@2.png
sips --resampleWidth 120 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-40@3.png
sips --resampleWidth 120 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-60@2.png
sips --resampleWidth 180 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-60@3.png
sips --resampleWidth 1024 ../../assets/icon.png --out cross/Assets.xcassets/AppIcon.appiconset/icon-1024@1.png

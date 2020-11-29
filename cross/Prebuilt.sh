#!/bin/sh

#  Prebuilt.sh
#  cross
#
#  Created by Null on 7/18/19.
#  Copyright © 2019 shaidin. All rights reserved.

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

qlmanage -t -s 20 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@1.png
qlmanage -t -s 40 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@2.png
qlmanage -t -s 60 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@3.png
qlmanage -t -s 29 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@1.png
qlmanage -t -s 58 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@2.png
qlmanage -t -s 87 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@3.png
qlmanage -t -s 40 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@1.png
qlmanage -t -s 80 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@2.png
qlmanage -t -s 120 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@3.png
qlmanage -t -s 120 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-60@2.png
qlmanage -t -s 180 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-60@3.png
qlmanage -t -s 76 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-76@1.png
qlmanage -t -s 152 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-76@2.png
qlmanage -t -s 167 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-83.5@2.png
qlmanage -t -s 1024 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-1024@1.png

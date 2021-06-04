cmake_minimum_required(VERSION 3.20)

include("${CMAKE_CURRENT_SOURCE_DIR}/../core/manifest.cmake")
string(TOLOWER ${cross_target} project_name)

#set(CMAKE_OSX_SYSROOT /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS14.5.sdk CACHE STRING "System root for iOS" FORCE)
set(CMAKE_Swift_LANGUAGE_VERSION 5.4)
set(CMAKE_SYSTEM_NAME iOS)
set(CMAKE_SYSTEM_VERSION 14.5)
#set(CMAKE_MACOSX_BUNDLE On)

project(${project_name} LANGUAGES Swift CXX VERSION ${cross_version})



set(MACOSX_BUNDLE_BUNDLE_NAME ${cross_target})
set(MACOSX_BUNDLE_BUNDLE_VERSION ${CMAKE_PROJECT_VERSION_PATCH})
#set(MACOSX_BUNDLE_COPYRIGHT NSHumanReadableCopyright)
set(MACOSX_BUNDLE_GUI_IDENTIFIER ${cross_identifier})
#set(MACOSX_BUNDLE_ICON_FILE CFBundleIconFile)
set(MACOSX_BUNDLE_INFO_STRING ${cross_identifier})
#set(MACOSX_BUNDLE_LONG_VERSION_STRING CFBundleLongVersionString)
set(MACOSX_BUNDLE_SHORT_VERSION_STRING ${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR})

add_executable(${CMAKE_PROJECT_NAME}
    cross/AppDelegate.swift
    cross/RootController.swift
    cross/ViewController.swift
    cross/WebView.swift
    cross/ImageView.swift
)
set_target_properties(${CMAKE_PROJECT_NAME} PROPERTIES
    XCODE_ATTRIBUTE_SWIFT_OBJC_BRIDGING_HEADER "cross/BridgeCore.h"
    XCODE_ATTRIBUTE_DEVELOPMENT_TEAM "QH3KDF7L87"
)

file(GLOB app_files ../../src/*.cpp)
file(GLOB core_files ../core/src/*.cpp)
add_library(bridge
    cross/BridgeCore.cpp
    ${app_files}
    ${core_files}
)
set_target_properties(bridge PROPERTIES
    CXX_STANDARD 17
)

target_link_libraries(${CMAKE_PROJECT_NAME}
    "-framework UIKit"
    bridge
    stdc++
)

# qlmanage -t -s 20 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@1.png
# qlmanage -t -s 40 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@2.png
# qlmanage -t -s 60 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-20@3.png
# qlmanage -t -s 29 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@1.png
# qlmanage -t -s 58 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@2.png
# qlmanage -t -s 87 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-29@3.png
# qlmanage -t -s 40 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@1.png
# qlmanage -t -s 80 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@2.png
# qlmanage -t -s 120 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-40@3.png
# qlmanage -t -s 120 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-60@2.png
# qlmanage -t -s 180 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-60@3.png
# qlmanage -t -s 76 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-76@1.png
# qlmanage -t -s 152 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-76@2.png
# qlmanage -t -s 167 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-83.5@2.png
# qlmanage -t -s 1024 -o cross/Assets.xcassets/AppIcon.appiconset/ ../../icon.svg && mv cross/Assets.xcassets/AppIcon.appiconset/icon.svg.png cross/Assets.xcassets/AppIcon.appiconset/icon-1024@1.png

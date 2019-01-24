#!/bin/bash

VERSION="5.10"
TYPE="static"
TARGET_FOLDER="qt-${VERSION}-${TYPE}-mingw-w64-x86_64"

# Build initial dynamic package.
cd "mingw-$VERSION$TYPE"
rm -rf ./bin ./pkg ./src ./$TARGET_FOLDER ./Qt5* ./*log
makepkg -sLf

# Copy all package stuff from "pkg" subfolder.
mkdir "$TARGET_FOLDER"
mv ./pkg/mingw-w64-x86_64-qt5-static/mingw64/qt5-static/* "./$TARGET_FOLDER"

# Deploy dependent DLLs.
cp ../tools/qtbinpatcher.exe "$TARGET_FOLDER/bin" -v

# Create archive.
../tools/7za a -t7z "$TARGET_FOLDER.7z" "./$TARGET_FOLDER" -mmt -mx9
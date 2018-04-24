#!/bin/bash

VERSION="5.10"
TYPE="dynamic"
TARGET_FOLDER="qt-${VERSION}-${TYPE}-mingw-w64-x86_64"

# Build initial dynamic package.
cd "mingw-$VERSION-x64"
rm -rf ./bin ./pkg ./src ./$TARGET_FOLDER ./Qt5* ./*log
makepkg -sLf

# Copy all package stuff from "pkg" subfolder.
mkdir "$TARGET_FOLDER"
mv ./pkg/mingw-w64-x86_64-qt5/mingw64/* "./$TARGET_FOLDER"

# Copy all dependencies.
echo "d:\\msys64\\mingw64\\" > "qt_paths.txt"

# Generate lists of dependent DLLs.
for f in $TARGET_FOLDER/bin/*.dll
do
  ../tools/FindDependencies.exe $f qt_paths.txt
done

# Copy dependent DLLs into single folder.
for f in ./*/copydlls.bat
do
  $f
done

# Deploy dependent DLLs.
cp ./bin/* "$TARGET_FOLDER/bin" -v
cp ../tools/qtbinpatcher.exe "$TARGET_FOLDER/bin" -v

# Create archive.
../tools/7za a -t7z "$TARGET_FOLDER.7z" "./$TARGET_FOLDER" -mmt -mx9
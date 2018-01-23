# mingw-w64-qt5-builds
This is attempt to build Qt 5 libraries in minimalistic mode. Output binaries have fewer dependencies, are lighter and thus are smaller.

This projects aims to provide only x64 variant of Qt 5 library and its dependencies. Both release and debug builds are provided.

All original licenses of all Qt components are respected!!!

**You can support me on [Liberapay](https://liberapay.com/martinrotter).**

## How this differs from official Qt Windows binaries?
Well, there are some differences:

* these binaries are compiled with **MinGW-w64** toolchain (with help of [MSYS2](http://www.msys2.org/)) and are **x64** (while official Windows MinGW Qt binaries are only x86 and used MinGW is outdated),
* **some features and modules are disabled**, which makes dependency tree smaller (details are specified in description of each release),
* distribution is relocatable (via `qtbinpatcher.exe`) and coinstallable with original MSYS2 Qt 5 packages,
* debug/release builds are available,
* static/dynamic builds are available.

## How to use
1. Install [MSYS2](http://www.msys2.org/) and launch its shell.
1. Update all MSYS2 packages with `pacman -Syu`.
1. Install MinGW-w64 x64 compiler toolchain and debugger with `pacman -S mingw-w64-x86_64-toolchain`. 
1. Download [prebuilt Qt binaries](https://github.com/martinrotter/mingw-w64-qt5-builds/releases) and unpack them to folder of your choice, for example `C:\Qt\5.1.0-mingw-w64`.
1. Use MSYS2 shell to navigate to folder `C:\Qt\5.1.0-mingw-w64\bin` and run `qtbinpatcher.exe` and wait for it to finish its job. At this point, installation is complete and Qt library is ready for usage.
1. Optionally, install Qt Creator via `pacman -S mingw-w64-x86_64-qt-creator` and add new compiler/qt/kit.

Special thanks to MSYS2 team for their amazing job.
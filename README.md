# qt5-minimalistic-builds
This is attempt to build Qt 5 libraries in minimalistic mode. Output binaries have fewer dependencies, are lighter and thus smaller.

**All original licenses of all used components (Qt, qtbinpatcher, MinGW-w64, OpenSSL, MSVC) are respected with the additional exception that compiling, linking, and/or using OpenSSL is allowed. Unmodified source code of Qt is used and the license of produced Qt binaries is the same as license used in original OSS Qt libraries.  The build phase of these prebuilt binaries is reproducible, see repository files for build scripts.**

## How this differs from official Qt Windows binaries?
Well, there are some differences:

* **all new builds are compiled including slimmed version of QtWebEngine !!!,**
* these binaries are compiled with ~~MinGW-w64 or~~ **MSVC2019** toolchain with latest updates and are **x64**,
* **some features and modules are disabled**, which makes dependency tree smaller (details are specified in description of each release),
* distribution is relocatable (via `qtbinpatcher.exe`),
* debug/release builds are available,
* latest manually compiled OpenSSL libraries are used,
* allmost all 3rd-party libs used by Qt are compiled directly into libraries,
* link-time optimizations (`/LTCG` and `/GL`) are enabled in MSVC2019 static builds.

## How to use
1. Install Visual Studio 2019 or just Build Tools.
1. Download [prebuilt Qt binaries](https://github.com/martinrotter/qt5-minimalistic-builds/releases) and unpack them to folder of your choice, for example `C:\Qt\XX`.
1. Use command line to navigate to folder `C:\Qt\XX\bin` and run `qtbinpatcher.exe` and wait for it to finish its job. At this point, installation is complete and Qt library is ready for use.

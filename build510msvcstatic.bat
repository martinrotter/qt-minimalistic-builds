CALL "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
SET _ROOT=D:\mingw-w64-qt5-builds\\5.10msvc
SET PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
SET _ROOT=

D:
mkdir D:\mingw-w64-qt5-builds\5.10msvcbuild
cd D:\mingw-w64-qt5-builds\5.10msvcbuild

D:\mingw-w64-qt5-builds\5.10msvc\configure -debug-and-release -opensource -confirm-license -platform win32-msvc2017 -opengl desktop -no-qml-debug -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdeclarative -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtcharts -skip qtgraphicaleffects -skip qtlocation -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebglplugin -skip qttools -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -mp -optimize-size -D "JAS_DLL=0" -static -static-runtime -prefix D:\mingw-w64-qt5-builds\5.10msvcbuild -ltcg

..\tools\jom.exe

nmake install
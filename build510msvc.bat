CALL "c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64

D:

:: Nainstalovat oficiální OpenSSL instalátor.
:: Nainstalovat do výchozího adresáře.

:: Build Qt.
SET _ROOT=D:\mingw-w64-qt5-builds\5.10msvc
SET PATH=%_ROOT%\qtbase\bin;%_ROOT%\gnuwin32\bin;%PATH%
SET _ROOT=

mkdir D:\mingw-w64-qt5-builds\5.10msvcbuild
cd D:\mingw-w64-qt5-builds\5.10msvcbuild

D:\mingw-w64-qt5-builds\5.10msvc\configure -debug-and-release -opensource -confirm-license -platform win32-msvc2017 -opengl desktop -no-qml-debug -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdeclarative -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtcharts -skip qtgraphicaleffects -skip qtlocation -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebglplugin -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtscript -mp -optimize-size -shared -static-runtime -prefix D:\Qt\5.10msvc -ltcg -ssl -openssl -openssl-linked -I C:\openssl\include64 -L C:\openssl\lib64 OPENSSL_LIBS="-lUser32 -lAdvapi32 -lGdi32 -llibeay32MD -lssleay32MD"

..\tools\jom.exe

nmake install
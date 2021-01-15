# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "5.15"
$version = "5.15.2"

$qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".zip"
$qt_archive_file = $pwd.Path + "\qt-" + $version + ".zip"
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

$tools_folder = $pwd.Path + "\tools\"
$type = "static"
$prefix_base_folder = "qt-" + $version + "-" + $type + "-msvc2019-x86_64"
$prefix_folder = $pwd.Path + "\" + $prefix_base_folder
$build_folder = $pwd.Path + "\bld"

# OpenSSL
# 1.1.1d
# Install steps:
#   1. Download, unpack openssl to folder "C:\xx".
#   2. Install system-wide perl, nasm.
#   3. Run MVSC command prompt and navigate to "C:\xx" folder.
#   4. Run "perl Configure VC-WIN64A --prefix=C:\xx --openssldir=C:\xx -static".
#   5. Manually edit "makefile" and add /GL /MT to compiler flags and /LTCG to linker flags, then run "nmake" and "make install".
$openssl_base_folder = "c:\Programy\OpenSSL\bin-static"
$openssl_include_folder = $openssl_base_folder + "\include"
$openssl_libs_folder = $openssl_base_folder + "\lib"
$openssl_bin_folder = $openssl_base_folder + "\bin"

# Download Qt sources, unpack.
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

& "$qt_src_base_folder\configure.bat" -debug-and-release -opensource -confirm-license -platform win32-msvc2017 -opengl desktop -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -qt-doubleconversion -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebview -skip qtscript -skip qtwebengine -mp -optimize-size -D "JAS_DLL=0" -static -feature-relocatable -ltcg -prefix $prefix_folder MYSQL_LIBS="-lAdvapi32 -lshlwapi -lWs2_32 -lmariadbclient" -openssl-linked -I $openssl_include_folder -L $openssl_libs_folder OPENSSL_LIBS="-lUser32 -lAdvapi32 -lGdi32 -lWS2_32 -lCRYPT32 -llibcrypto -llibssl"

# Compile.
nmake
nmake install

# Copy OpenSSL.
cp "$tools_folder\qtbinpatcher.*" "$prefix_folder\bin\"
cp "$openssl_libs_folder\*" "$prefix_folder\lib\" -Recurse
cp "$openssl_include_folder\openssl" "$prefix_folder\include\" -Recurse

# Fixup OpenSSL DLL paths and MySQL paths.
$openssl_libs_folder_esc = $openssl_libs_folder -replace '\\','\\'

gci -r -include "*.prl" $prefix_folder | foreach-object { $a = $_.fullname; (get-content $a).Replace($openssl_libs_folder_esc, '$$$$[QT_INSTALL_LIBS]\\') | set-content $a }

# Create final archive.
& "$tools_folder\7za.exe" a -t7z "${prefix_base_folder}.7z" "$prefix_folder" -mmt -mx9

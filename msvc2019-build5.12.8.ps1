# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "5.12"
$version = "5.12.8"

$qt_sources_url = "https://download.qt.io/official_releases/qt/" + $version_base + "/" + $version + "/single/qt-everywhere-src-" + $version + ".zip"
$qt_archive_file = $pwd.Path + "\qt-" + $version + ".zip"
$qt_src_base_folder = $pwd.Path + "\qt-everywhere-src-" + $version

$tools_folder = $pwd.Path + "\tools\"
$type = "dynamic"
$prefix_base_folder = "qt-" + $version + "-" + $type + "-msvc2019-x86_64"
$prefix_folder = $pwd.Path + "\" + $prefix_base_folder
$build_folder = $pwd.Path + "\bld"

# OpenSSL
# 1.1.1d
# Install steps:
#   1. Download, unpack openssl to folder "C:\openssl111d".
#   2. Install system-wide perl, nasm.
#   3. Run MVSC command prompt and navigate to openssl folder.
#   4. Run "perl Configure VC-WIN64A --prefix=c:\openssl111 --openssldir=C:\openssl111" and then run "nmake" and "make install".
$openssl_base_folder = "c:\Programy\OpenSSL\bin"
$openssl_include_folder = $openssl_base_folder + "\include"
$openssl_libs_folder = $openssl_base_folder + "\lib"
$openssl_bin_folder = $openssl_base_folder + "\bin"

# MySQL
$mysql_include_folder = "c:\\Programy\\MySQL\\include"
$mysql_lib_folder = "c:\\Programy\\MySQL\\lib"

# Download Qt sources, unpack.
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

& "$qt_src_base_folder\configure.bat" -debug-and-release -opensource -confirm-license -platform win32-msvc2017 -opengl desktop -no-iconv -no-dbus -no-icu -no-fontconfig -no-freetype -qt-harfbuzz -qt-doubleconversion -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtlocation -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebview -skip qtscript -no-feature-webengine-v8-snapshot -no-feature-webengine-v8-snapshot-support -no-feature-webengine-geolocation -no-feature-webengine-pepper-plugins -no-feature-webengine-printing-and-pdf -no-feature-webengine-webchannel -no-feature-webengine-proprietary-codecs -no-feature-webengine-kerberos -no-feature-webengine-spellchecker -no-feature-webengine-webrtc -no-feature-webengine-sanitizer -no-feature-webengine-ui-delegates -no-feature-webengine-testsupport -mp -optimize-size -shared -prefix $prefix_folder -openssl-linked -I $mysql_include_folder -L $mysql_lib_folder -I $openssl_include_folder -L $openssl_libs_folder OPENSSL_LIBS="-lUser32 -lAdvapi32 -lGdi32 -llibcrypto -llibssl"

# Compile.
#& "$tools_folder\jom.exe"
nmake
nmake install

# Copy qtbinpatcher, OpenSSL, MySQL.
cp "$tools_folder\qtbinpatcher.*" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*.dll" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*.exe" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*.pdb" "$prefix_folder\bin\"
cp "$openssl_libs_folder\*" "$prefix_folder\lib\" -Recurse
cp "$openssl_include_folder\openssl" "$prefix_folder\include\" -Recurse

cp "$mysql_lib_folder\libmysql.*" "$prefix_folder\bin\"
cp "$mysql_lib_folder\libmysql.*" "$prefix_folder\lib\"

# Fixup OpenSSL DLL paths and MySQL paths.
$openssl_libs_folder_esc = $openssl_libs_folder -replace '\\','\\'
$mysql_lib_folder_esc = $mysql_lib_folder -replace '\\','\\'

gci -r -include "*.prl" $prefix_folder | foreach-object { $a = $_.fullname; (get-content $a).Replace($openssl_libs_folder_esc, '$$$$[QT_INSTALL_LIBS]\\') | set-content $a }

gci -r -include "*.prl" $prefix_folder | foreach-object { $a = $_.fullname; (get-content $a).Replace($mysql_lib_folder_esc, '$$$$[QT_INSTALL_LIBS]\\') | set-content $a }

# Create final archive.
& "$tools_folder\7za.exe" a -t7z "${prefix_base_folder}.7z" "$prefix_folder" -mmt -mx9

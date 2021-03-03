# 1. Start Visual Studio x64 Native Tools command line.
# 2. Run powershell.exe from Native Tools cmd.
# 3. cd to path of qt5-minimalistic-builds repo.

$version_base = "6.0"
$version = "6.0.1"

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

# SQL.
$mysql_include_folder = "c:\Programy\MariaDB\include"
$mysql_lib_folder = "c:\Programy\MariaDB\lib"
$mysql_lib = "$mysql_lib_folder\libmariadb.lib"

$postgre_include_folder = "c:\Programy\PostgreSQL\include"
$postgre_lib_folder = "c:\Programy\PostgreSQL\lib"
$postgre_bin_folder = "c:\Programy\PostgreSQL\bin"
$postgre_lib = "$postgre_lib_folder\libpq.lib"

# Download Qt sources, unpack.
$ProgressPreference = 'SilentlyContinue'
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols

Invoke-WebRequest -Uri $qt_sources_url -OutFile $qt_archive_file
& "$tools_folder\7za.exe" x $qt_archive_file

# Configure.
mkdir $build_folder
cd $build_folder

$env:OPENSSL_LIBS = "-lUser32 -lAdvapi32 -lGdi32 -llibcrypto -llibssl"

& "$qt_src_base_folder\configure.bat" -cmake -debug-and-release -opensource -confirm-license -opengl desktop -no-dbus -no-icu -no-fontconfig -nomake examples -nomake tests -skip qt3d -skip qtactiveqt -skip qtcanvas3d -skip qtconnectivity -skip qtdatavis3d -skip qtdoc -skip qtgamepad -skip qtlocation -skip qtnetworkauth -skip qtpurchasing -skip qtremoteobjects -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwebview -skip qtscript -mp -optimize-size -shared -prefix $prefix_folder -openssl-linked -DOPENSSL_ROOT_DIR="$openssl_base_folder" -- -DMySQL_INCLUDE_DIRS="$mysql_include_folder" -DMySQL_LIBRARIES="$mysql_lib" -DPostgreSQL_INCLUDE_DIRS="$postgre_include_folder" -DPostgreSQL_LIBRARY="$postgre_lib"

# Compile.
cmake --build .
cmake --install . --config Release
cmake --install . --config Debug

# Copy libs.
cp "$openssl_bin_folder\*.dll" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*.exe" "$prefix_folder\bin\"
cp "$openssl_bin_folder\*.pdb" "$prefix_folder\bin\"
cp "$openssl_libs_folder\*" "$prefix_folder\lib\" -Recurse
cp "$openssl_include_folder\openssl" "$prefix_folder\include\" -Recurse

cp "$mysql_lib_folder\lib*.dll" "$prefix_folder\bin\"
cp "$mysql_lib_folder\lib*.lib" "$prefix_folder\lib\"

cp "$postgre_bin_folder\libpq.dll" "$prefix_folder\bin\"
cp "$postgre_bin_folder\libintl-8.dll" "$prefix_folder\bin\"
cp "$postgre_bin_folder\libiconv-2.dll" "$prefix_folder\bin\"
cp "$postgre_lib_folder\libpq.lib" "$prefix_folder\lib\"

# Create final archive.
& "$tools_folder\7za.exe" a -t7z "${prefix_base_folder}.7z" "$prefix_folder" -mmt -mx9

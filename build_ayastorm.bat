@echo off
set PYTHONUTF8=1
set AUTOBUILD_VSVER=180
set AUTOBUILD_WIN_VSTOOLSET=v145
set AUTOBUILD_VARIABLES_FILE=C:\work_ayastorm\fs-build-variables\variables
set AUTOBUILD_CONFIG_FILE=my_autobuild.xml
set PATH=C:\cygwin64\bin;%PATH%

cd C:\work_ayastorm\phoenix-firestorm

echo [1] Modifying special characters...
python fixall2.py

echo [2] Deleting previous build...
rmdir /s /q build-vc180-64

echo [3] Configuring...
autobuild configure -A 64 -c ReleaseFS_open -- --fmodstudio -DLL_TESTS:BOOL=FALSE --package --chan AYAstorm-release
if errorlevel 1 (
    echo Configure失敗
    pause
    exit /b 1
)

echo [4] Building...
autobuild build -A 64 -c ReleaseFS_open --no-configure
if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo Complete!
pause

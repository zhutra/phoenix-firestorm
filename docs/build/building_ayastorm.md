# AYAstorm Viewer Build Instructions

Linux / Windows
April 2026

---

## Linux Build Steps

### 1. Required Environment

- Ubuntu 22.04 LTS (x86_64)
- 16 GB RAM or more, 64 GB storage or more
- GCC 11 (Ubuntu 22.04 default)
- Python 3 (venv recommended)

### 2. Install Required Packages (one-time)

```bash
sudo apt install libgl1-mesa-dev libglu1-mesa-dev libpulse-dev build-essential \
  python3-pip git libssl-dev libxinerama-dev libxrandr-dev \
  libfontconfig-dev libfreetype6-dev gcc-11 cmake
```

### 3. Create Directories and Clone Repositories

```bash
mkdir ~/work_ayastorm && cd ~/work_ayastorm
git clone https://github.com/mayatonton/phoenix-firestorm.git
cd phoenix-firestorm
git checkout ayastorm-release

# Build variables repository
cd ~/work_ayastorm
git clone https://github.com/FirestormViewer/fs-build-variables.git
```

### 4. Set Up Python venv and autobuild (one-time)

```bash
cd ~/work_ayastorm/phoenix-firestorm
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 5. Environment Variables

Run before each build, or add to `~/.bashrc`:

```bash
source ~/work_ayastorm/phoenix-firestorm/.venv/bin/activate
export AUTOBUILD_VARIABLES_FILE=$HOME/work_ayastorm/fs-build-variables/variables
```

### 6. FMOD Setup (one-time)

Create a free account at https://www.fmod.com and download the Linux **FMOD Studio API** (version 2.03.07).

```bash
cd ~/work_ayastorm
# AYAstorm uses a fork that stages libopus bundled with the SDK (for Opus 5.1 surround support)
git clone https://github.com/mayatonton/3p-fmodstudio.git
cp ~/Downloads/fmodstudioapi20307linux.tar.gz ~/work_ayastorm/3p-fmodstudio/
cd ~/work_ayastorm/3p-fmodstudio
autobuild build -A 64 --all
autobuild package -A 64 --results-file result.txt
cat result.txt  # check md5 hash
```

Register the md5 from result.txt with Firestorm:

```bash
cd ~/work_ayastorm/phoenix-firestorm
autobuild installables edit fmodstudio platform=linux64 \
  hash=<md5-value> \
  url=file:///home/{user name}/work_ayastorm/3p-fmodstudio/fmodstudio-2.03.07-linux64-*.tar.bz2
```

### 7. configure (first run or after --clean)

```bash
cd ~/work_ayastorm/phoenix-firestorm
autobuild configure -A 64 -c ReleaseFS_open --   --fmodstudio -DLL_TESTS:BOOL=FALSE --package --chan AYAstorm-release
```

### 8. Build

```bash
autobuild build -A 64 -c ReleaseFS_open --no-configure
```

### 9. Clear Cache and Install

```bash
cd ~/work_ayastorm/phoenix-firestorm
autobuild configure -A 64 -c ReleaseFS_open --   --fmodstudio -DLL_TESTS:BOOL=FALSE --package --chan AYAstorm-release
autobuild build -A 64 -c ReleaseFS_open

cd ~/work_ayastorm/phoenix-firestorm/build-linux-x86_64/newview/packaged
rm -rf ~/ayastorm/
rm -rf ~/.local/share/applications/ayastorm-viewer.desktop
./install.sh
rm -rf ~/.ayastorm_x64/cache/
```

### 10. Run

```bash
~/ayastorm/ayastorm
```

---

## Windows Build Steps

### 1. Install Required Tools (one-time)

> **Important:** Do all work in **cmd.exe (Command Prompt) as Administrator**, not PowerShell.

#### Visual Studio 2022 Community (free)

- Run as Administrator
- Check "Desktop development with C++"

#### Git for Windows

- Select "Checkout as-is, commit as-is" (**important!**)

#### CMake 4.1.2 or newer

- Select "Add CMake to the system PATH for all users"

#### Cygwin 64

- Run as Administrator
- Add package: `Devel/patch`

#### Python 3

- Run as Administrator
- Check "Add Python to PATH"
- Install to: `C:\Python3`

#### NSIS (for installer creation)

- Download from https://nsis.sourceforge.io

### 2. Clone Repositories

```cmd
c:
mkdir work_ayastorm
cd work_ayastorm
git clone https://github.com/mayatonton/phoenix-firestorm.git
cd phoenix-firestorm
git checkout ayastorm-release

cd c:\work_ayastorm
git clone https://github.com/FirestormViewer/fs-build-variables.git
```

### 3. Set Up autobuild (one-time)

```cmd
cd c:\work_ayastorm\phoenix-firestorm
pip install -r requirements.txt
```

### 4. Environment Variables

Run in **Administrator cmd** before each build:

```cmd
set PYTHONUTF8=1
set AUTOBUILD_VSVER=170
set AUTOBUILD_VARIABLES_FILE=c:\work_ayastorm\fs-build-variables\variables
set PATH=C:\cygwin64\bin;%PATH%
set AUTOBUILD_CONFIG_FILE=my_autobuild.xml
```

> `my_autobuild.xml` is created after FMOD setup.

### 5. FMOD Setup (one-time)

Create a free account at https://www.fmod.com and download the Windows **FMOD Studio API** (version 2.03.07).

```cmd
cd c:\work_ayastorm
:: AYAstorm uses a fork that stages libopus bundled with the SDK (for Opus 5.1 surround support)
git clone https://github.com/mayatonton/3p-fmodstudio.git
copy fmodstudioapi20307win-installer.exe c:\work_ayastorm\3p-fmodstudio\
cd c:\work_ayastorm\3p-fmodstudio
autobuild build -A 64 --all
autobuild package -A 64 --results-file result.txt
type result.txt
```

Register the md5 from result.txt with Firestorm:

```cmd
cd c:\work_ayastorm\phoenix-firestorm
copy autobuild.xml my_autobuild.xml
set AUTOBUILD_CONFIG_FILE=my_autobuild.xml
autobuild installables edit fmodstudio platform=windows64 ^
  hash=<md5-value> ^
  url=file:///c:/work_ayastorm/3p-fmodstudio/fmodstudio-2.03.07-windows64-*.tar.bz2
```

### 6. configure (Legacy)

After setting environment variables in Administrator cmd:

```cmd
cd c:\work_ayastorm\phoenix-firestorm
rmdir /s /q build-vc170-64
autobuild configure -A 64 -c ReleaseFS_open -- --fmodstudio -DLL_TESTS:BOOL=FALSE --package --chan AYAstorm-release
```

### 7. Build (Legacy)

```cmd
autobuild build -A 64 -c ReleaseFS_open --no-configure
```

### 8. Installer Location (Legacy)

```
c:\work_ayastorm\phoenix-firestorm\build-vc170-64\newview\Release\
Phoenix-FirestormOS-Ayastorm-release_LEGACY-7-2-4-80621_Setup.exe
```

### 9. configure (AVX2)

After setting environment variables in Administrator cmd:

```cmd
cd c:\work_ayastorm\phoenix-firestorm
rmdir /s /q build-vc170-64
autobuild configure -A 64 -c ReleaseFS_open -- --fmodstudio --avx2 -DLL_TESTS:BOOL=FALSE --package --chan AYAstorm-release
```

### 10. Build (AVX2)

```cmd
autobuild build -A 64 -c ReleaseFS_AVX2 --no-configure
```

### 11. Installer Location (AVX2)

```
c:\work_ayastorm\phoenix-firestorm\build-vc170-64\newview\Release\
Phoenix-FirestormOS-AYAstorm-release_AVX2-7-2-4-80621_Setup.exe
```

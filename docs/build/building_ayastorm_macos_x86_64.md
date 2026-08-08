# AYAstorm macOS Build Instructions (x86_64)

Date: 2026-05-06 \
Target example: `feature/macos-x86_64-build` (based on `ayastorm-release`) \
Output example: `Phoenix-FirestormOS-AYAstorm-release_x86_64-7-2-4-80834.dmg`

This document describes the procedure for creating a macOS x86_64 distribution DMG for AYAstorm on Monterey. For general macOS build requirements for the Firestorm viewer itself, also refer to `doc/building_macos.[...]

## Prerequisites

- macOS 12.x
- Xcode 13.x or 14.x
- CMake
- [ripgrep](https://ports.macports.org/port/ripgrep/)
- Python 3.9 compatible venv
- `autobuild`
- `fs-build-variables`
- FMOD Studio API 2.03.07 installer for macOS
- If enabling FMOD, `my_autobuild.xml` with registered FMOD package

Work directory example:

```bash
export WORK="$HOME/work_ayastorm"
export REPO="$WORK/phoenix-firestorm"
export FS_BUILD_VARIABLES="$WORK/fs-build-variables/variables"
export FMOD_REPO="$WORK/3p-fmodstudio"
export TARGET_REF="feature/macos-x86_64-build"
export AYA_BUILD_ID="80834"
```

`AYA_BUILD_ID` is the autobuild build id to be included in the artifact name on the Release page. For release distributions, the build id from CI / autobuild is explicitly specified and aligned, rathe[...]

## Source Acquisition

```bash
mkdir -p "$WORK"
cd "$WORK"

git clone https://github.com/zhutra/phoenix-firestorm.git "$REPO"
git clone https://github.com/FirestormViewer/fs-build-variables.git "$WORK/fs-build-variables"

cd "$REPO"
git checkout "$TARGET_REF"
git status --short
```

If using an existing worktree, specify its path as `REPO` and verify differences with `git status --short` before building. Do not perform a Release build while including unnecessary diffs.

## Python / autobuild

```bash
cd "$REPO"

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
autobuild --version
```

To allow Python launched from `xcodebuild` to reference venv packages, pass site-packages to `PYTHONPATH`.

```bash
export PYTHON_SITE="$(python -c 'import site; print(site.getsitepackages()[0])')"
export PYTHONPATH="$PYTHON_SITE"
```

## FMOD Studio API

For AYAstorm Release builds, configure with the `--fmodstudio` flag. Therefore, pre-package FMOD Studio API with autobuild and register it in `my_autobuild.xml`.

Obtain the FMOD Studio API for macOS from the official FMOD website. Use the FMOD Studio API installer, not the FMOD Studio Tool.

In this work environment, use an existing local clone for FMOD package creation.

```bash
export FMOD_REPO="$WORK/3p-fmodstudio"

cd "$WORK"
git clone https://github.com/mayatonton/3p-fmodstudio.git "$FMOD_REPO"
git -C "$FMOD_REPO" remote -v
```

Place the downloaded macOS FMOD Studio API installer `.dmg` in `$FMOD_REPO`.

```bash
cd "$FMOD_REPO"
ls -lh *.dmg

autobuild build -A 32 --all
autobuild package -A 32 --results-file result.txt
cat result.txt
```

The package path and md5 hash are output to `result.txt`. Register the created `fmodstudio-*-darwin-*.tar.bz2` in the viewer side `my_autobuild.xml`.

```bash
cd "$REPO"
cp -n autobuild.xml my_autobuild.xml
export AUTOBUILD_CONFIG_FILE="my_autobuild.xml"

export FMOD_PACKAGE="$(find "$FMOD_REPO" -maxdepth 1 -name 'fmodstudio-*-darwin-*.tar.bz2' -print -quit)"
export FMOD_HASH="<md5 hash from result.txt>"

autobuild installables edit fmodstudio platform=darwin \
  hash="$FMOD_HASH" \
  url="file://$FMOD_PACKAGE"
```

After registration, verify that `fmodstudio` / `darwin` in `my_autobuild.xml` points to the created package.

```bash
rg -n 'fmodstudio|darwin|file://' my_autobuild.xml
```

If building without FMOD, remove `--fmodstudio` from the configure step onward.

## Dullahan Audio Callback

The default AYAstorm Mac build procedure enables the Dullahan audio callback path.

If the `t-noami/dullahan` fork's installable (`dullahan_aya_audio`) exists in `autobuild.xml` or `my_autobuild.xml`:

```bash
-DLL_DULLAHAN_AUDIO_CALLBACK:BOOL=TRUE
```

If the `t-noami/dullahan` fork does not exist and the upstream `secondlife/dullahan` installable (`dullahan`) exists:

```bash
-DLL_DULLAHAN_AUDIO_CALLBACK:BOOL=FALSE
```

After configure, verify the `LL_DULLAHAN_AUDIO_CALLBACK:BOOL=` value in `build-darwin/CMakeCache.txt`.

## Environment Variables

```bash
cd "$REPO"

export DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
export AUTOBUILD_BUILD_ID="$AYA_BUILD_ID"
export AUTOBUILD_VARIABLES_FILE="$FS_BUILD_VARIABLES"
export AUTOBUILD_CONFIG_FILE="my_autobuild.xml"
export CLANG_MODULE_CACHE_PATH="$REPO/build-darwin/ModuleCache"
```

## Configure

To build clean:

```bash
cd "$REPO"
rm -rf build-darwin
```

Configure:

```bash
autobuild configure -A 32 -c ReleaseFS_open -- \
  --fmodstudio \
  --openal \
  --package \
  --chan AYAstorm-release \
  -DLL_TESTS:BOOL=FALSE \
  -DLL_DULLAHAN_AUDIO_CALLBACK:BOOL=TRUE
```

After configure, verify major settings.

```bash
rg -n 'CMAKE_BUILD_TYPE|ADDRESS_SIZE|CMAKE_OSX_ARCHITECTURES|VIEWER_CHANNEL|USE_FMODSTUDIO|USE_OPENAL|OPENSIM|PACKAGE|VIEWER_BINARY_NAME|LL_DULLAHAN_AUDIO_CALLBACK' \
  build-darwin/CMakeCache.txt
```

Expected values example:

```text
ADDRESS_SIZE:STRING=32
CMAKE_BUILD_TYPE:STRING=Release
CMAKE_OSX_ARCHITECTURES:STRING=x86_64
OPENSIM:BOOL=ON
PACKAGE:BOOL=ON
USE_FMODSTUDIO:BOOL=ON
USE_OPENAL:BOOL=ON
VIEWER_BINARY_NAME:STRING=ayastorm-bin
VIEWER_CHANNEL:STRING=Firestorm-AYAstorm-release
LL_DULLAHAN_AUDIO_CALLBACK:BOOL=TRUE
```

## Build / Package

Execute the `llpackage` scheme in Release configuration.

```bash
cd "$REPO/build-darwin"

DEVELOPER_DIR="$DEVELOPER_DIR" \
AUTOBUILD_BUILD_ID="$AYA_BUILD_ID" \
PYTHONPATH="$PYTHONPATH" \
AUTOBUILD_VARIABLES_FILE="$FS_BUILD_VARIABLES" \
AUTOBUILD_CONFIG_FILE="$AUTOBUILD_CONFIG_FILE" \
CLANG_MODULE_CACHE_PATH="$CLANG_MODULE_CACHE_PATH" \
xcodebuild \
  -project Firestorm.xcodeproj \
  -scheme llpackage \
  -configuration Release \
  -derivedDataPath "$REPO/build-darwin/DerivedData" \
  CLANG_MODULE_CACHE_PATH="$CLANG_MODULE_CACHE_PATH" \
  build
```

If `hdiutil create` fails during DMG creation with "device not configured", sandbox or permission restrictions are blocking disk image operations.

## Artifacts

```bash
export DMG="$REPO/build-darwin/newview/Phoenix-FirestormOS-AYAstorm-release_x86_64-7-2-4-${AYA_BUILD_ID}.dmg"
export APP="$REPO/build-darwin/newview/Release/AYAstorm.app"

ls -lh "$DMG"
```

Artifact example:

```text
build-darwin/newview/Phoenix-FirestormOS-AYAstorm-release_x86_64-7-2-4-80834.dmg
```

## Verification

Basic verification of local app / DMG:

```bash
hdiutil verify "$DMG"
codesign --verify --deep --strict --verbose=2 "$APP"
lipo -archs "$APP/Contents/MacOS/AYAstorm"
/usr/libexec/PlistBuddy -c 'Print :CFBundleIconFile' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$APP/Contents/Info.plist"
/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Contents/Info.plist"
```

Expected values:

```text
hdiutil verify: VALID
codesign: valid on disk / satisfies its Designated Requirement
lipo: i386
CFBundleIconFile: ayastorm_icon.icns
CFBundleVersion: 7.2.4.80834
CFBundleShortVersionString: 7.2.4.80834
```

Verify that login information or local environment information is not mixed in. Confirm that both produce no output.

```bash
export LOCAL_USER="$(id -un)"

rg -a -l "$LOCAL_USER|/Users/$LOCAL_USER" "$APP/Contents"

find "$APP" \
  -iname 'account_history*' \
  -o -iname 'bin_conf.dat' \
  -o -iname 'cookies*' \
  -o -iname '*credentials*' \
  -o -iname '*saved_password*'
```

Also verify the app inside the DMG.

```bash
hdiutil attach -nobrowse -readonly "$DMG"
```

From the `hdiutil attach` output, identify the device and mount point, and replace the following `diskX`.

```bash
export DMG_MOUNT="/Volumes/AYAstorm Installer"
export DMG_APP="$DMG_MOUNT/FirestormOS-AYAstorm-release.app"

codesign --verify --deep --strict --verbose=2 "$DMG_APP"
rg -a -l "$LOCAL_USER|/Users/$LOCAL_USER" "$DMG_APP/Contents"
find "$DMG_APP" \
  -iname 'account_history*' \
  -o -iname 'bin_conf.dat' \
  -o -iname 'cookies*' \
  -o -iname '*credentials*' \
  -o -iname '*saved_password*'

md5 "$DMG_MOUNT/.VolumeIcon.icns" \
  "$REPO/indra/newview/icons/ayastorm/ayastorm_icon.icns"

hdiutil detach -force /dev/diskX
```

## Code Signing and Local Path Mitigation

To avoid `Code Signature Invalid` and local build path contamination, strip local symbols from Mach-O in Release packages before re-signing.

- `indra/cmake/00-Common.cmake`
  - Specifies `-ffile-prefix-map`, `-fmacro-prefix-map`, `-fdebug-prefix-map` for Darwin / Clang
- `indra/newview/viewer_manifest.py`
  - Executes `strip -S -x` on Mach-O within bundle during packaging
  - Re-signs nested apps / dylibs afterward

A code signature invalid warning may appear during the strip process, but this is expected as re-signing occurs immediately after. Always execute `codesign --verify --deep --strict` before distributio[...]

## Notes

- DMG filename should include `x86_64` for Release distribution.
- App name remains `AYAstorm.app`.
- App name inside DMG is `FirestormOS-AYAstorm-release.app`.
- If performing notarization before distribution, separately verify Developer ID and notary settings.
- If an existing app is manually edited, always execute re-signing and `codesign --verify --deep --strict`.

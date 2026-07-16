# AYAstorm

<img align="left" width="100" height="100" src="indra/newview/icons/ayastorm/ayastorm_512.png" alt="AYAstorm logo"/>

[**AYAstorm**](https://github.com/mayatonton/phoenix-firestorm) is a custom Second Life viewer based on **Firestorm**. It adds rendering enhancements, UI improvements, and first-class Japanese language support.

**This** fork introduces extra lighting controls to help achieve a **neutral**, modern-day look reminiscent of pre-PBR Second Life, while avoiding the constant _crashes_ of old viewer builds.

[![Download](https://badgen.net/badge/icon/v7.2.4-ayastorm-r31-bugfix-2?icon=windows&label&color=157cca)](https://github.com/zhutra/phoenix-firestorm/releases/latest) [![Download](https://badgen.net/badge/icon/coming%20soon?icon=linux&label&color=f4bc00)](https://github.com/zhutra/phoenix-firestorm/releases/latest) [![Download](https://badgen.net/badge/icon/coming%20soon?icon=apple&label&color=a2aaad)](https://github.com/zhutra/phoenix-firestorm/releases/latest)

## Features

### Lighting

Open from the **AYAstorm** top menu → **AYAstorm Controls**, or press `Alt+C`.

<p align="center">
    <img alt="AYAstorm Controls" src="https://github.com/user-attachments/assets/138a9beb-b412-4649-a4fa-ac197c23ccf0" />
</p>

- **Force fullbright everywhere** - If on (and fullbright is enabled), all surfaces render as fullbright regardless of material settings
- **Enable PBR materials** - If off, PBR Metallic Roughness materials are suppressed and surfaces fall back to Textures (Blinn-Phong)
- **Enable normal textures** - If off, bumpiness (normal/bump map) textures are suppressed globally
- **Enable specular textures** - If off, shininess (specular) textures are suppressed globally

> **Note**: The list above highlights only the settings newly introduced in this release. AYAstorm Controls incorporated many other tuning options, also included. For the full list and details, refer to the [AYAstorm repository](https://github.com/mayatonton/phoenix-firestorm/#ayastorm-controls).

### General

Open from the **AYAstorm** top menu → **AYAstorm Controls**, or press `Alt+C`.

<p align="center">
    <img alt="AYAstorm Controls" src="https://github.com/user-attachments/assets/e6165ae6-d52b-4740-8682-f22e0d62ccd7" />
</p>

- **Render reflection probes** - If off, reflection probe prims are hidden from the scene. Does not affect probe-based reflections on other surfaces

> **Note**: The list above highlights only the settings newly introduced in this release. AYAstorm Controls incorporated many other tuning options, also included. For the full list and details, refer to the [AYAstorm repository](https://github.com/mayatonton/phoenix-firestorm/#ayastorm-controls).

### Other

<img alt="Discord" src="https://github.com/user-attachments/assets/35d76d34-ebfe-4143-ba43-8e4c5adfb92e" />

- **Discord Rich Presence** - Aligned with the official [Second Life viewer](https://github.com/secondlife/viewer), so your status reads playing Second Life

## Download

Pre-built binaries are available from [**GitHub Releases**](https://github.com/zhutra/phoenix-firestorm/releases/latest).

| OS | File | How to use |
|----|------|------|
| Windows (x64) | `Phoenix-FirestormOS-AYAstorm-release_AVX2-*_Setup.exe` | NSIS installer. Download and run |
| Linux (x64) | Coming soon | — |
| macOS | Coming soon | — |

> **For older CPUs without AVX2 (Windows only)**: If you run the AVX2 build above, the installer will show a message before installation begins. Download `Phoenix-FirestormOS-AYAstorm-release_LEGACY-*_Setup.exe` instead. AVX2 is supported on most Intel / AMD CPUs from 2013 onward, so the AVX2 build works for most users.

**Linux install example:**

```bash
tar xf Phoenix-FirestormOS-AYAstorm-release_LEGACY-*.tar.xz
cd Phoenix-FirestormOS-AYAstorm-release_LEGACY-*/
./install.sh
~/ayastorm/ayastorm
```

## Building

AYAstorm-specific build guide (Linux / Windows):

- [AYAstorm Build Guide](docs/build/building_ayastorm.md)

Upstream Firestorm build guides (refer to these for Mac):

- [Windows](doc/building_windows.md)
- [Mac](doc/building_macos.md)
- [Linux](doc/building_linux.md)

## Contributors

### AYAstorm

<a href="https://github.com/mayatonton"><img src="https://github.com/mayatonton.png?size=100" width="80" height="80" alt="mayatonton" style="border-radius: 50%; margin-right: 2rem;"/></a> <a href="https://github.com/t-noami"><img src="https://github.com/t-noami.png?size=100" width="80" height="80" alt="t-noami" style="border-radius: 50%;"/></a>

**[mayatonton](https://github.com/mayatonton)** — Creator / Maintainer  
**[t-noami](https://github.com/t-noami)** — Co-Maintainer

### Built on Firestorm

AYAstorm is a fork of [**Phoenix Firestorm**](https://www.firestormviewer.org), which is itself an open-source viewer derived from the official [Second Life](https://github.com/secondlife/viewer) client, licensed under LGPL.

Huge thanks to the Firestorm team and all upstream contributors whose work AYAstorm builds upon.

### Have an idea?

[![Form](https://img.shields.io/badge/submit%20your%20suggestions-grey?style=for-the-badge&logo=googleforms)](https://zhutra.fillout.com/suggestions)

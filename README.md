[![Download](https://img.shields.io/github/v/release/zhutra/phoenix-firestorm?label=⇓%20Download&style=for-the-badge&color=147ecd)](https://github.com/zhutra/phoenix-firestorm/releases/latest)

<img align="left" width="100" height="100" src="indra/newview/icons/ayastorm/ayastorm_512.png" alt="AYAstorm logo"/>

**AYAstorm is a custom Second Life viewer based on [Firestorm](https://www.firestormviewer.org).**
It adds rendering enhancements, UI improvements, and first-class Japanese language support.

---

## Features

### AYAstorm Controls

Open from the **AYAstorm** menu (between Build and Help) → `AYAstorm Controls...`, or press `Alt+C`.

![AYAstorm Controls](docs/images/ayastorm_controls.png)

A single floater that surfaces AYAstorm's preset master switches and 11 rendering categories on the left tab strip. Every control has a `D` button to snap back to the AYAstorm preset default, so you can live A/B-tune without hunting through debug settings.

- **General** — Master switches for SSAO / Glow & Bloom / Render Attached Particles, plus the Reflection probe quality slider. Use this tab as the top-level on/off panel before diving into per-effect tuning

- **Shadows** — Shadow Detail level (off / sun only / sun + spot + projector), automatic vs. manual cascade distance, shadow blur size, resolution scale, and shadow far clip. Lets you balance softness against shadow draw distance

- **SSAO** — SSAO master toggle (mirrors General tab), `Blur deferred lights` toggle, and AO tuning sliders. Adjust contact shadow strength and falloff

- **DoF & Camera** — Depth of Field master, **High-quality DoF (4× CoF, depth-gated)**, front-of-focus blur, alpha-blended-surface depth inclusion, plus camera-side AYAstorm preset values (focal length / aperture / etc.) and a DoF-coupled chromatic aberration strength slider

- **SSR** — Screen Space Reflections master toggle and six quality-tuning sliders (step count, max distance, etc.). Adds wet-floor / glass reflections on top of the deferred opaque buffer

- **Motion Blur** — Motion Blur master toggle, separate `Blur self avatar` and `Blur other avatars` switches, plus an Antialiasing sub-section

- **Glow & Volumetric** — Glow / Bloom intensity tuning, **Volumetric Lighting (AYA godrays)** with directional fade (sun-below-horizon), and a separate **Godrays (sun-facing beam)** pass for the brighter on-axis variant

- **Lighting** — Enable fullbright textures (global), render in-world point/spot lights, render own attached lights, render others' attached lights — the four switches that decide how much the local-light pipeline contributes to the scene

- **Post-process** — Contrast Adaptive Sharpening (CAS) and Post FX sliders, applied as the final post-process pass over the framebuffer

- **Atmosphere & sky** — Sky depth & sun glare, distant blue haze, and a morning blue / evening warm tint — AYAstorm View's signature atmosphere shaping on top of EEP

- **Skin SSS** — Subsurface Scattering for skin translucency: master switch, blur radius / strength / etc. parameters, and a target-mesh-UUID whitelist with `Lock editing (prevent accidental changes)` and `Reset all to defaults`

> Tip: change the **View Mode** (Firestorm / AYAstorm View) in Preferences → Graphics. Restart the viewer after switching to apply.

### Rendering

Configurable from Preferences → Graphics → Rendering tab.

![Preferences - Rendering](docs/images/preferences_graphics_rendering.png)

- **Shadow Softness** — New slider to soften shadow edges

- **Selectable Tone Mappers** — Upstream Firestorm hard-codes Khronos Neutral internally; AYAstorm exposes a UI selector with five options:
  - Khronos Neutral / ACES / Filmic (Uncharted 2) / Uchimura (GT) / Filmic (BD Style)

- **Color Grading Controls** — Adjustable Saturation, Contrast, Color Temperature, and Brightness sliders (with a `Reset Color Grading` button) added to the UI

- **Color LUT (.cube) Loading** — Apply 3D LUT files (`.cube`) for post-process color grading. Seven presets are bundled (`teal_orange`, `warm`, `cold_war`, `sepia`, `cool`, `cinematic`, `film_noir`), but the primary goal is to let **users load their own `.cube` files to fully customize the look of the viewer**. Pick a LUT via `Browse...` and adjust `LUT Intensity` to taste

---

## Download

Pre-built binaries are available from **[GitHub Releases](https://github.com/mayatonton/phoenix-firestorm/releases/latest)**.

| OS | File | How to use |
|----|------|------|
| Windows (x64) | `Phoenix-FirestormOS-AYAstorm-release_AVX2-*_Setup.exe` | NSIS installer. Download and run |
| Linux (x64) | `Phoenix-FirestormOS-AYAstorm-release_LEGACY-*.tar.xz` | Extract anywhere and run the bundled `install.sh` |
| macOS | (Coming soon) | — |

> **For older CPUs without AVX2 (Windows only)**: If you run the AVX2 build above, the installer will show a message before installation begins. Download `Phoenix-FirestormOS-AYAstorm-release_LEGACY-*_Setup.exe` instead. AVX2 is supported on most Intel / AMD CPUs from 2013 onward, so the AVX2 build works for most users.

**Linux install example:**

```bash
tar xf Phoenix-FirestormOS-AYAstorm-release_LEGACY-*.tar.xz
cd Phoenix-FirestormOS-AYAstorm-release_LEGACY-*/
./install.sh
~/ayastorm/ayastorm
```

---

## Build Instructions

AYAstorm-specific build guide (Linux / Windows):

- [AYAstorm Build Guide](docs/build/building_ayastorm.md)

Upstream Firestorm build guides (refer to these for Mac):

- [Windows](doc/building_windows.md)
- [Mac](doc/building_macos.md)
- [Linux](doc/building_linux.md)

---

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

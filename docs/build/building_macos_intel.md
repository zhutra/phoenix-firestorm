# Build Instructions for macOS Intel (Monterey & Legacy Macs)

**For Intel-based Macs running macOS Monterey 12.x or older**

This guide is tailored for users with older Intel Macs that cannot upgrade to newer macOS versions. This document adapts the Firestorm build process for compatibility with Monterey and includes detailed explanations for complete beginners.

## System Requirements

- **macOS**: 10.13 (High Sierra) or later — Monterey (12.x) is ideal for this guide
- **Architecture**: Intel (x86_64) — Not compatible with Apple Silicon Macs
- **RAM**: At least 8GB recommended (16GB is better for smoother compilation)
- **Disk Space**: ~30-40GB free space for build artifacts and dependencies
- **Network**: Stable internet connection during initial setup and dependency downloads

## Prerequisites Overview

You need to install these tools in order:

1. **Xcode 11.7** — Apple's developer toolkit (most important)
2. **CMake 3.16.0+** — Build system generator
3. **Python 3.7+** — Scripting language (usually pre-installed on macOS)
4. **pip** — Python package manager
5. **Autobuild** — Firestorm's custom build tool
6. **Git** — Version control (usually pre-installed on macOS)

---

## Part 1: Getting a Terminal Window Open

All commands in this guide are typed into a **Terminal**. Here's how to open one:

1. Open **Finder** (click the blue face icon in your Dock, or press `Cmd + Space`)
2. Search for "Terminal" 
3. Open **Terminal.app**
4. Keep this window open throughout the entire guide

You'll copy and paste commands from this guide directly into Terminal. Don't close it between sections!

---

## Part 2: Installing Xcode 11.7

Xcode is Apple's developer toolkit. **You MUST install version 11.7** — newer versions won't work on Monterey.

### Step 1: Sign up for Apple Developer Account (Free)

1. Go to [https://developer.apple.com/download](https://developer.apple.com/download)
2. Click "Sign in" and log in with your Apple ID (create one if you don't have it)
3. You don't need a paid developer account — the free one works fine

### Step 2: Download Xcode 11.7

Once logged in:

1. Search for "Xcode 11.7" in the downloads list
2. Or use this direct link: [Xcode 11.7 Download](https://download.developer.apple.com/Developer_Tools/Xcode_11.7/Xcode_11.7.xip)
3. Click the download icon next to it
4. The file is ~11GB — this will take a while depending on your internet speed

**Wait for the download to complete. Don't close your browser.**

### Step 3: Install Xcode

1. Once downloaded, you'll have a file called `Xcode_11.7.xip` (probably in your Downloads folder)
2. Double-click it to extract it (this takes several minutes)
3. You'll get a file called `Xcode.app`
4. **Drag `Xcode.app` into your Applications folder**
5. This may take 10-20 minutes

### Step 4: Run Xcode for the First Time

1. Open **Finder** → **Applications**
2. Find and double-click **Xcode.app**
3. It will ask to install additional components — click **Install**
4. Enter your Mac password if prompted
5. Wait for it to finish (this can take 10+ minutes)
6. Close Xcode when done

### Step 5: Verify Xcode Installation

Go back to Terminal and type:

```bash
clang --version
```

You should see something like:
```
Apple clang version 11.0.3 (clang-1103.0.32.62)
Target: x86_64-apple-darwin20.6.0
```

**If you see version 12 or higher, something went wrong. Delete Xcode.app and start over.**

---

## Part 3: Installing CMake 3.16.0+

CMake is a build system generator that Firestorm uses.

### Step 1: Download CMake

1. Go to [https://cmake.org/download](https://cmake.org/download)
2. Scroll to "Latest Release"
3. Download the file named `cmake-X.X.X-macos-universal.tar.gz` (get version 3.16.0 or higher)
4. Wait for the download to complete

### Step 2: Install CMake

1. Double-click the downloaded `.tar.gz` file to extract it
2. You'll get a folder called something like `cmake-X.X.X-macos-universal`
3. Open that folder and look for the folder inside called `CMake.app`
4. **Drag `CMake.app` into your Applications folder**

### Step 3: Install Command-Line Tools

CMake needs to be accessible from Terminal. In Terminal, type:

```bash
sudo /Applications/CMake.app/Contents/MacOS/CMake --install
```

Enter your Mac password when prompted.

### Step 4: Verify CMake Installation

In Terminal, type:

```bash
cmake --version
```

You should see something like:
```
cmake version 3.16.0 (or higher)
```

---

## Part 4: Python and pip

Python usually comes pre-installed on macOS, but we need to make sure pip (the package manager) is available.

### Step 1: Check if Python is Installed

In Terminal, type:

```bash
python3 --version
```

You should see `Python 3.7.x` or higher. If you get "command not found", you need to [install Python from here](https://www.python.org/downloads).

### Step 2: Install pip

In Terminal, type:

```bash
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
```

Enter your Mac password when prompted. This downloads and installs pip.

### Step 3: Verify pip Installation

In Terminal, type:

```bash
pip3 --version
```

You should see something like `pip X.X.X from /Library/Python/3.7/site-packages/python3.7`.

---

## Part 5: Installing Autobuild

Autobuild is Firestorm's custom build tool that handles all the compilation steps.

### Step 1: Install Autobuild via pip

In Terminal, type:

```bash
pip3 install --user git+https://bitbucket.org/lindenlab/autobuild.git#egg=autobuild
```

This downloads and installs autobuild to your user directory.

### Step 2: Add Autobuild to Your PATH

So Terminal can find autobuild everywhere, run:

```bash
echo '~/Library/Python/3.7/bin/' | sudo tee /etc/paths.d/99-autobuild
```

Enter your Mac password when prompted.

### Step 3: Restart Terminal

Close Terminal completely and open a new Terminal window (this makes the PATH change take effect).

### Step 4: Verify Autobuild Installation

In Terminal, type:

```bash
autobuild --version
```

You should see `autobuild 3.8` or higher. If you get "command not found", the PATH wasn't set correctly — repeat Step 2 above.

---

## Part 6: Prepare Your Build Directory

Now that all tools are installed, set up a folder structure for building Firestorm.

### Step 1: Create Work Folders

In Terminal, type:

```bash
mkdir ~/firestorm
cd ~/firestorm
```

This creates a folder called `firestorm` in your home directory and moves into it.

### Step 2: Clone the Firestorm Repository

```bash
git clone https://github.com/FirestormViewer/phoenix-firestorm.git
```

This downloads the Firestorm source code (~2-3GB). **This will take several minutes.**

### Step 3: Clone the Build Variables

```bash
git clone https://github.com/FirestormViewer/fs-build-variables.git
```

This downloads configuration files needed for the build.

### Step 4: Set the Build Variables Environment Variable

Firestorm needs to know where the build variables are. Type:

```bash
echo 'AUTOBUILD_VARIABLES_FILE=~/firestorm/fs-build-variables/variables' | sudo tee ~/.zshrc
```

Or if you use bash shell:

```bash
echo 'AUTOBUILD_VARIABLES_FILE=~/firestorm/fs-build-variables/variables' | sudo tee ~/.bash_profile
```

Enter your Mac password if prompted.

### Step 5: Restart Terminal Again

Close and reopen Terminal to make this change take effect.

---

## Part 7: Configuring Firestorm for Building

Now we tell the build system how to compile Firestorm for your Mac.

### Step 1: Navigate to the Firestorm Directory

```bash
cd ~/firestorm/phoenix-firestorm
```

### Step 2: Configure the Build

Type this command (all on one line):

```bash
autobuild configure -A 64 -c ReleaseFS_open
```

**This step takes 5-15 minutes.** It downloads libraries and prepares the build system. You'll see a lot of output in Terminal — this is normal.

### What do these options mean?

- `-A 64` — Build for 64-bit architecture (the only option on modern Macs)
- `-c ReleaseFS_open` — Build configuration without licensed libraries (KDU, FMOD)
  - `ReleaseFS_open` = easiest option for community builders
  - No paid licenses required
  - Creates an optimized, usable build

### Step 3: Verify Configuration (Optional)

To check that everything configured correctly, look at the CMake cache file:

```bash
cat build-darwin-x86_64/CMakeCache.txt | grep "CMAKE_BUILD_TYPE\|ADDRESS_SIZE\|VIEWER_CHANNEL"
```

You should see output showing:
- `CMAKE_BUILD_TYPE:STRING=Release`
- `ADDRESS_SIZE:STRING=64`
- `VIEWER_CHANNEL:STRING=Firestorm-Private-...`

---

## Part 8: Building Firestorm

This is the actual compilation step. Grab a coffee — this takes **1-3 hours** depending on your Mac's speed.

### Step 1: Start the Build

In Terminal, make sure you're in the Firestorm directory:

```bash
cd ~/firestorm/phoenix-firestorm
```

Then start the build:

```bash
autobuild build -A 64 -c ReleaseFS_open --no-configure
```

**The `--no-configure` flag skips reconfiguration and just builds.**

### Step 2: What to Expect

Terminal will show lots of compilation output. This is normal. You should see:
- File names being compiled
- Progress percentages
- Some warnings (these are usually OK)

**Do NOT close Terminal during this process.**

If you see actual errors (not just warnings), note them down and check the [Firestorm Self Compilers group](https://tinyurl.com/firestorm-self-compilers).

### Step 3: Wait for Completion

The build is done when you see a message like:
```
[100%] Built target firestorm
```

Or when you get your Terminal prompt back and there are no errors.

---

## Part 9: Finding Your Compiled Viewer

Once the build completes successfully, your Firestorm application is ready!

### Step 1: Navigate to the Build Output

In Terminal:

```bash
open ~/firestorm/phoenix-firestorm/build-darwin-x86_64/newview/Release
```
---

## Updating Your Build

Once you've built Firestorm, updating to newer versions is simpler:

### Quick Update

```bash
cd ~/firestorm/phoenix-firestorm
git pull
autobuild configure -A 64 -c ReleaseFS_open
autobuild build -A 64 -c ReleaseFS_open --no-configure
```

### Clean Update (if you're having issues)

```bash
cd ~/firestorm/phoenix-firestorm
rm -rf build-darwin-x86_64
git pull
autobuild configure -A 64 -c ReleaseFS_open
autobuild build -A 64 -c ReleaseFS_open --no-configure
```

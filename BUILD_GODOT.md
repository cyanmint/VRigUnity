# Building VRig for Godot 4.5

## Prerequisites

- Godot 4.5-stable or later
- Git

## Setting up the Development Environment

### 1. Clone the repository

```bash
git clone https://github.com/cyanmint/VRigUnity.git
cd VRigUnity
```

### 2. Install Required Addons

#### Install godot-vrm

```bash
# Clone godot-vrm into the addons directory
cd addons
git clone https://github.com/V-Sekai/godot-vrm.git vrm
cd ..
```

#### Install GDMP (MediaPipe)

1. Download GDMP v0.6 from: https://github.com/j20001970/GDMP/releases/tag/v0.6
2. Extract the downloaded archive
3. Copy the `addons/GDMP` folder to this project's `addons/` directory

### 3. Download MediaPipe Assets

GDMP requires MediaPipe model files. These should be downloaded and placed in the appropriate directory:

```bash
# Create the resources directory
mkdir -p addons/GDMP/models

# Download the holistic model (example - adjust URL as needed)
# You may need to download these manually from MediaPipe's official sources
```

### 4. Open in Godot

1. Open Godot 4.5
2. Click "Import"
3. Navigate to the project directory and select `project.godot`
4. Click "Import & Edit"

### 5. Enable Plugins

1. Go to Project → Project Settings → Plugins
2. Enable "GDMP" plugin
3. Enable "VRM" plugin (if available in plugin list)

### 6. Run the Project

1. Open the main scene: `scenes/workspace.tscn`
2. Press F5 or click the Play button to run

## Building for Distribution

### Windows

```bash
# In Godot Editor:
# Project → Export → Add → Windows Desktop
# Configure export settings
# Click "Export Project"
```

### Linux

```bash
# In Godot Editor:
# Project → Export → Add → Linux/X11
# Configure export settings
# Click "Export Project"
```

### macOS

```bash
# In Godot Editor:
# Project → Export → Add → macOS
# Configure export settings
# Click "Export Project"
```

### Android

#### Prerequisites
- Android SDK (Platform API 34 or later)
- Android NDK
- Java Development Kit (JDK) 17 or later

#### Setup Android SDK
1. Install Android Studio or download Android SDK command-line tools
2. Install required SDK platforms and build tools:
   - SDK Platform 34 (Android 14.0)
   - Build Tools 34.0.0 or later
   - NDK (Side by side)
3. Configure Godot to use the Android SDK:
   - Open Godot Editor
   - Go to Editor → Editor Settings → Export → Android
   - Set "Android SDK Path" to your SDK location
   - Set "Debug Keystore" path (or use default)

#### Export for Android
```bash
# In Godot Editor:
# Project → Export → Add → Android
# Configure export settings:
#   - Min SDK: 24 (Android 7.0)
#   - Target SDK: 34 (Android 14.0)
#   - Architectures: arm64-v8a (recommended)
#   - Permissions: Camera, Record Audio, Internet
# Click "Export Project" and save as .apk
```

#### Install on Device
```bash
# Enable USB debugging on your Android device
# Connect device via USB
adb install build/android/VRig.apk
```

## Troubleshooting

### Addon not found errors

Make sure all addons are properly installed in the `addons/` directory:
- `addons/vrm/` - godot-vrm
- `addons/GDMP/` - GDMP MediaPipe plugin

### MediaPipe models missing

Download the required MediaPipe model files and place them in the correct directory within GDMP addon.

### Camera not working

Ensure your system has granted camera permissions to Godot.

## Development

The project structure:
- `scenes/` - Godot scene files (.tscn)
- `scripts/` - GDScript/C# scripts
- `addons/` - Third-party plugins (vrm, GDMP)
- `assets/` - Textures, fonts, models, translations
- `project.godot` - Main project configuration

## Notes

- This is a complete port from Unity to Godot 4.5
- All Unity-specific code has been rewritten for Godot
- MediaPipe integration now uses GDMP instead of MediaPipeUnityPlugin
- VRM support now uses godot-vrm instead of UniVRM

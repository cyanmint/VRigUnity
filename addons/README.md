# Addons Directory

This directory should contain the required Godot addons for VRig to function.

## Required Addons

### 1. godot-vrm
VRM model support for Godot 4.x

**Installation:**
1. Clone or download: https://github.com/V-Sekai/godot-vrm
2. Copy the `addons/vrm` folder to this `addons/` directory
3. Enable the plugin in Godot: Project → Project Settings → Plugins

**Usage:**
The VRM addon provides functionality to load and manipulate VRM models in Godot.

### 2. GDMP (Godot MediaPipe)
MediaPipe integration for Godot, providing face, pose, and hand tracking

**Installation:**
1. Download GDMP v0.6: https://github.com/j20001970/GDMP/releases/tag/v0.6
2. Extract the archive
3. Copy the `addons/GDMP` folder to this `addons/` directory
4. Enable the plugin in Godot: Project → Project Settings → Plugins

**Usage:**
GDMP provides MediaPipe functionality including:
- Holistic tracking (face + pose + hands)
- Face mesh detection
- Pose estimation
- Hand tracking

**Important Notes:**
- GDMP may require additional MediaPipe model files to be downloaded
- Check the GDMP documentation for platform-specific requirements
- On some platforms, you may need to download MediaPipe task files separately

## Directory Structure

After installation, your addons folder should look like:

```
addons/
├── README.md (this file)
├── vrm/
│   ├── plugin.cfg
│   └── ... (godot-vrm files)
└── GDMP/
    ├── plugin.cfg
    └── ... (GDMP files)
```

## Verification

To verify the addons are correctly installed:

1. Open the project in Godot 4.5
2. Go to Project → Project Settings → Plugins
3. You should see both "VRM" and "GDMP" in the plugins list
4. Enable both plugins if not already enabled
5. Restart the Godot editor if prompted

## Troubleshooting

### godot-vrm not loading
- Ensure you're using Godot 4.5 or later
- Check that the plugin.cfg file exists in addons/vrm/
- Verify the plugin is compatible with your Godot version

### GDMP not loading
- Ensure all native library files are present
- Check console for error messages
- Verify platform-specific requirements are met
- On Linux, you may need to install additional dependencies

### Models not loading
- Ensure MediaPipe model files are downloaded
- Check GDMP documentation for model file locations
- Verify file permissions

## Additional Resources

- godot-vrm: https://github.com/V-Sekai/godot-vrm
- GDMP: https://github.com/j20001970/GDMP
- MediaPipe: https://developers.google.com/mediapipe
- VRM Specification: https://vrm.dev/

# Quick Start Guide - VRig Godot Edition

This guide will help you get VRig running quickly in Godot 4.5.

## Prerequisites

1. **Godot 4.5-stable** - Download from https://godotengine.org/download
2. **A webcam** - For motion tracking
3. **VRM model** (optional) - Any VRM 0.x or 1.0 model

## Installation Steps

### Step 1: Clone the Repository

```bash
git clone https://github.com/cyanmint/VRigUnity.git
cd VRigUnity
```

### Step 2: Install Required Addons

#### Install godot-vrm

```bash
cd addons
git clone https://github.com/V-Sekai/godot-vrm.git vrm
cd ..
```

Alternatively, download the addon manually:
1. Go to https://github.com/V-Sekai/godot-vrm
2. Download or clone the repository
3. Copy the addon files to `addons/vrm/`

#### Install GDMP (MediaPipe)

1. Download GDMP v0.6 from: https://github.com/j20001970/GDMP/releases/tag/v0.6
2. Extract the archive
3. Copy the `addons/GDMP` folder to this project's `addons/` directory

Your `addons` folder should now contain:
```
addons/
├── README.md
├── vrm/
└── GDMP/
```

### Step 3: Open the Project in Godot

1. Launch Godot 4.5
2. Click "Import"
3. Navigate to the project folder
4. Select `project.godot`
5. Click "Import & Edit"

### Step 4: Enable Plugins

1. In Godot, go to: **Project → Project Settings → Plugins**
2. Enable the **VRM** plugin
3. Enable the **GDMP** plugin
4. If prompted, allow Godot to restart

### Step 5: Run the Application

1. Press **F5** or click the **Play** button
2. The main workspace scene should launch
3. Click **"Load VRM Model"** to load your VRM character
4. Grant camera permissions when prompted
5. Start tracking!

## Troubleshooting

### "Addons not found" error

**Solution:** Make sure you've copied the addon folders correctly:
- `addons/vrm/plugin.cfg` should exist
- `addons/GDMP/plugin.cfg` should exist

### Camera not working

**Solution:**
- Ensure your OS has granted camera permissions
- On Linux, you may need to add your user to the `video` group
- Check that your webcam is not being used by another application

### VRM model won't load

**Solution:**
- Ensure the godot-vrm plugin is enabled
- Try a different VRM model
- Check the Godot console for error messages

### Poor tracking performance

**Solution:**
- Reduce webcam resolution in settings
- Close other applications
- Ensure good lighting for better tracking
- Lower tracking quality in settings

### MediaPipe models missing

**Solution:**
- GDMP may require additional MediaPipe model files
- Check GDMP documentation for download links
- Place model files in the correct directory

## Basic Usage

### Loading a VRM Model

1. Click **"Load VRM Model"** in the top bar
2. Browse to your `.vrm` file
3. Click **"Open"**
4. The model should appear in the viewport

### Camera Controls

- **Shift + Drag**: Pan the camera
- **Ctrl + Drag**: Rotate the camera
- **Mouse Wheel**: Zoom in/out

### Settings

1. Click **"Settings"** in the top bar
2. Adjust tracking options:
   - Enable/disable face tracking
   - Enable/disable pose tracking
   - Enable/disable hand tracking
3. Configure VMC protocol (for VSeeFace, etc.)
4. Change language
5. Click **"Save"** to apply changes

### Adding a Background

1. Click **"Background"** in the top bar
2. Select an image file (.png, .jpg)
3. The background will be applied

### VMC Protocol (Virtual Motion Capture)

To send tracking data to other applications:

1. Open **Settings**
2. Check **"Enable VMC"**
3. Set the target port (default: 39539)
4. Click **"Save"**
5. Open your VMC-compatible app (VSeeFace, etc.)
6. Configure it to receive on the same port

## Keyboard Shortcuts

- **F5**: Run the project
- **F6**: Run current scene
- **Ctrl+Q**: Quit application

## Next Steps

- Read [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md) for technical details
- Check [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) for development status
- See [BUILD_GODOT.md](./BUILD_GODOT.md) for export/build instructions

## Getting Help

If you encounter issues:

1. Check the Godot console for error messages
2. Review the troubleshooting section above
3. Check the GitHub Issues page
4. Consult the Godot documentation: https://docs.godotengine.org/

## Contributing

Contributions are welcome! Areas that need work:

- Completing MediaPipe integration
- Improving tracking accuracy
- Adding more UI features
- Testing on different platforms
- Translating to more languages

See [IMPLEMENTATION_ROADMAP.md](./IMPLEMENTATION_ROADMAP.md) for details.

## License

See [LICENSE](./LICENSE) file for details.

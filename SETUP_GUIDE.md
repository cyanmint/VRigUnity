# VRig Godot Setup Guide

## First-Time Setup

This guide helps you set up VRig Godot Edition for the first time.

---

## Prerequisites

1. **Godot 4.5-stable** installed (or use pre-built executable)
2. **Webcam** connected to your computer
3. **Internet connection** (for downloading MediaPipe model)

---

## Quick Setup (For Pre-Built Executables)

### Step 1: Download Model File

VRig needs the MediaPipe holistic tracking model to work. This file is ~14 MB.

**Option A: Automatic (Recommended)**

1. Run VRig for the first time
2. If the model is missing, you'll see this warning in the log:
   ```
   [WARN] Holistic model file not found
   ```
3. The log will show where to place the file

**Option B: Manual Download**

1. Download the model file from:
   ```
   https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task
   ```

2. Place it in one of these locations:

   **Windows:**
   ```
   %APPDATA%\Godot\app_userdata\VRig\holistic_landmarker.task
   ```
   Or:
   ```
   C:\Users\YourName\AppData\Roaming\Godot\app_userdata\VRig\holistic_landmarker.task
   ```

   **Linux:**
   ```
   ~/.local/share/godot/app_userdata/VRig/holistic_landmarker.task
   ```

   **macOS:**
   ```
   ~/Library/Application Support/Godot/app_userdata/VRig/holistic_landmarker.task
   ```

### Step 2: Check Webcam

1. Make sure your webcam is connected
2. On first run, VRig will try to detect your camera
3. Check the debug log at:
   - Windows: `%APPDATA%\Godot\app_userdata\VRig\vrig_debug.log`
   - Linux: `~/.local/share/godot/app_userdata/VRig/vrig_debug.log`
   - macOS: `~/Library/Application Support/Godot/app_userdata/VRig/vrig_debug.log`

4. Look for these messages:
   ```
   [INFO] Camera initialized successfully
   ```

If you see errors:
```
[ERROR] No camera feeds available
```

**Solutions:**
- Ensure webcam is plugged in
- Check if other apps can use the webcam
- Try restarting VRig
- On Windows: Check camera permissions in Settings > Privacy > Camera

### Step 3: Load VRM Model

1. Click "Open Model" button (or press Ctrl+O)
2. Select your `.vrm` file
3. Model should appear in the 3D view
4. Tracking will start automatically if camera is working

---

## Troubleshooting

### Model File Not Found

**Error:**
```
[WARN] Holistic model file not found
[ERROR] Cannot start tracking: MediaPipe graph not initialized
```

**Solution:**
1. Download `holistic_landmarker.task` from the URL above
2. Find your user data directory:
   - Check the debug log for the path
   - Or check above for platform-specific locations
3. Create the directory if it doesn't exist
4. Copy the model file there
5. Restart VRig

### Camera Not Detected

**Error:**
```
[ERROR] No camera feeds available
[ERROR] Failed to initialize camera
```

**Solutions:**

**Windows:**
1. Go to Settings > Privacy > Camera
2. Ensure camera access is enabled for apps
3. Allow desktop apps to access camera
4. Restart VRig

**Linux:**
1. Check if camera is detected:
   ```bash
   ls /dev/video*
   ```
2. Ensure you have permission:
   ```bash
   sudo usermod -a -G video $USER
   ```
3. Log out and back in
4. Restart VRig

**macOS:**
1. Go to System Preferences > Security & Privacy > Camera
2. Ensure VRig is allowed to access camera
3. If not listed, add it manually
4. Restart VRig

### Camera Opens But No Tracking

**Possible Causes:**
1. Model file not loaded (see above)
2. Insufficient lighting
3. Face/body not visible to camera

**Solutions:**
1. Check debug log for model loading errors
2. Ensure good lighting
3. Face the camera
4. Check that VRM model is loaded

### VRM Model Won't Load

**Error:**
```
Failed to load VRM model
```

**Solutions:**
1. Ensure the file is a valid `.vrm` file
2. Try a different VRM model
3. Check the debug log for specific errors
4. Test with a simple VRM model first

### Performance Issues

**Symptoms:**
- Low FPS
- Stuttering
- High CPU usage

**Solutions:**
1. Reduce camera resolution in settings
2. Close other apps using the camera
3. Use float16 model (default, not float32)
4. Update graphics drivers

---

## Building from Source

If you're building VRig from Godot source:

### Step 1: Clone Repository

```bash
git clone https://github.com/cyanmint/VRigUnity.git
cd VRigUnity
```

### Step 2: Install Addons

The required addons should already be included:
- `addons/vrm/` - VRM model support
- `addons/GDMP/` - MediaPipe integration

### Step 3: Download Model

```bash
# Create models directory
mkdir -p addons/GDMP/models

# Download model
cd addons/GDMP/models
wget https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task

# Or on Windows with PowerShell:
# Invoke-WebRequest -Uri "https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task" -OutFile "holistic_landmarker.task"
```

### Step 4: Open in Godot

1. Open Godot 4.5-stable
2. Click "Import"
3. Navigate to VRigUnity folder
4. Select `project.godot`
5. Click "Import & Edit"

### Step 5: Enable Plugins

1. Go to Project > Project Settings > Plugins
2. Enable "VRM"
3. Enable "GDMP"
4. Restart Godot if prompted

### Step 6: Run

1. Press F5 or click Run button
2. Project should start
3. Check debug log for any errors

---

## Verification Checklist

Use this checklist to verify your setup:

- [ ] Godot 4.5-stable installed (or using pre-built executable)
- [ ] VRig project imported/executable downloaded
- [ ] Webcam connected and working
- [ ] Model file downloaded (`holistic_landmarker.task`)
- [ ] Model file in correct location (user data directory)
- [ ] Camera permissions granted (macOS/Windows)
- [ ] VRM model ready to test (.vrm file)
- [ ] Debug log accessible and readable
- [ ] No errors in debug log on startup

---

## Getting Help

If you're still having issues:

1. **Check Debug Log:**
   - Location shown in first INFO message
   - Look for ERROR or WARN messages
   - Note the exact error text

2. **Review Documentation:**
   - [DEBUGGING.md](./DEBUGGING.md) - Comprehensive debugging
   - [LOCAL_TESTING.md](./LOCAL_TESTING.md) - Testing procedures
   - [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Common issues

3. **Report Issue:**
   - Open GitHub issue
   - Include debug log excerpt
   - Describe what you tried
   - System info (OS, Godot version, camera model)

---

## Next Steps

Once setup is complete:

1. **Load a VRM Model:**
   - Get free VRM models from VRoid Hub
   - Or create your own with VRoid Studio

2. **Configure Settings:**
   - Adjust tracking sensitivity
   - Configure VMC protocol (if using with other apps)
   - Customize camera resolution

3. **Start Tracking:**
   - Face the camera
   - See your VRM model mirror your movements
   - Enjoy!

---

**Last Updated:** 2026-02-10  
**Godot Version:** 4.5-stable  
**Status:** Production Ready ✅

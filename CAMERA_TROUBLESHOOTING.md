# Camera Troubleshooting Guide

## Issue: Camera Not Loading

If you're seeing a log like this with no HolisticSolution messages:

```
[08:40:42] [INFO] [Main] VRig Godot Edition Starting...
[08:40:42] [INFO] [Main] Tracking system connected successfully
[08:40:42] [INFO] [Main] Initialization complete
```

This means the HolisticSolution camera system isn't initializing properly.

---

## Quick Fixes

### 1. Check Console Output (Most Important!)

The latest build now outputs extensive debug information to the **console window** (not just the log file).

**Windows:** Run VRig from command prompt:
```cmd
cd "C:\Path\To\VRig"
VRig.exe
```

Look for lines starting with `[HolisticSolution]` - they will show exactly where initialization stops.

### 2. Check Camera Permissions (Windows 10/11)

**Windows Settings:**
1. Open Settings → Privacy & Security → Camera
2. Ensure "Let apps access your camera" is ON
3. Ensure "Let desktop apps access your camera" is ON
4. Check that your webcam appears in Device Manager

### 3. Test Camera in Other Apps

Before running VRig:
1. Open Windows Camera app
2. Verify your webcam works
3. Close Camera app completely
4. Then run VRig

**Note:** Some apps lock the camera - make sure no other app is using it!

### 4. Check for Missing Model File

Even without the MediaPipe model file, the camera should still initialize. But you'll see warnings like:

```
[WARN] Holistic model file not found
```

This is OK! The camera should still work for preview.

---

## Detailed Debugging

### Expected Console Output (Working)

When camera initialization works, you should see:

```
[HolisticSolution] _ready() called
[HolisticSolution] setup_mediapipe() called
[HolisticSolution] Setting up MediaPipe...
[HolisticSolution] Model path result: <path or empty>
[HolisticSolution] Calling setup_camera()...
[HolisticSolution] setup_camera() called
[HolisticSolution] CameraServer instance: <CameraServer#123>
[HolisticSolution] Initial feed count: 0
[HolisticSolution] No feeds detected, trying to add...
[HolisticSolution] Attempting to add feed: Camera 0
[HolisticSolution] Add feed result: <CameraFeed#456>
[HolisticSolution] Successfully added: Camera 0
[HolisticSolution] Feed count after adding: 1
[HolisticSolution] Getting feed 0...
[HolisticSolution] Camera feed: <CameraFeed#456>
[HolisticSolution] Using camera feed: Camera 0
[HolisticSolution] Creating CameraTexture...
[HolisticSolution] Camera texture created
[HolisticSolution] Activating camera feed...
[HolisticSolution] Waiting for camera to initialize...
[HolisticSolution] Camera initialization complete
[HolisticSolution] Camera setup result: true
```

### What Each Line Means

| Line | Meaning |
|------|---------|
| `_ready() called` | HolisticSolution node started |
| `setup_mediapipe() called` | MediaPipe setup began |
| `setup_camera() called` | Camera setup began |
| `Initial feed count: 0` | No cameras auto-detected (normal on Windows) |
| `Add feed result: <CameraFeed#...>` | Successfully added camera |
| `Add feed result: null` | Failed to add camera (problem!) |
| `Camera setup result: true` | Camera working! |
| `Camera setup result: false` | Camera failed! |

---

## Common Issues & Solutions

### Issue 1: No Console Output At All

**Symptom:** Running VRig.exe shows window but no console.

**Solution:**
1. Run from command prompt (see Quick Fix #1)
2. Or check the log file at: `%APPDATA%\Godot\app_userdata\VRig\vrig_debug.log`
3. Console output should appear in both places

### Issue 2: "Add feed result: null" for all cameras

**Symptom:**
```
[HolisticSolution] Attempting to add feed: Camera 0
[HolisticSolution] Add feed result: null
[HolisticSolution] Attempting to add feed: Camera 1
[HolisticSolution] Add feed result: null
...
[HolisticSolution] ERROR: Still no camera feeds available
```

**Possible Causes:**
1. **Camera permissions denied** - Check Windows privacy settings
2. **Camera in use** - Close all apps using webcam
3. **No camera connected** - Plug in a webcam
4. **Driver issues** - Update webcam drivers
5. **Godot CameraServer bug** - Try different Godot build

**Solutions:**
- Grant camera permissions (see Quick Fix #2)
- Restart computer (releases camera locks)
- Try different camera if available
- Update to latest Godot 4.5 build

### Issue 3: Stops at "setup_mediapipe() called"

**Symptom:**
```
[HolisticSolution] _ready() called
[HolisticSolution] setup_mediapipe() called
(nothing more)
```

**Possible Causes:**
1. GDMP crashed during initialization
2. Async/await issue
3. Missing GDMP libraries

**Solutions:**
- Check if GDMP .dll files are present in VRig directory
- Look for error messages about missing DLLs
- Try running from a location without special characters in path
- Check Windows Event Viewer for crash details

### Issue 4: Stops before "setup_mediapipe() called"

**Symptom:**
```
[HolisticSolution] _ready() called
(nothing more)
```

**Possible Causes:**
1. GDMP not available (expected in some builds)
2. Autoload timing issue

**Expected Behavior:**
Should see: `[HolisticSolution] WARNING: GDMP not available`

If you don't see any message after `_ready() called`, there's a crash.

**Solutions:**
- Check for error messages in Event Viewer
- Try running as Administrator
- Check antivirus isn't blocking
- Verify GDMP .dll files are not corrupted

### Issue 5: "GDMP extension not available"

**Symptom:**
```
[HolisticSolution] WARNING: GDMP not available
```

**Cause:** GDMP native libraries (.dll files) are missing or incompatible.

**Solution:**
- Download GDMP from: https://github.com/j20001970/GDMP/releases/tag/v0.6
- Place GDMP.windows.dll in the same folder as VRig.exe
- Or use pre-built VRig release with GDMP included

---

## Platform-Specific Notes

### Windows 10/11
- Requires camera permissions in Privacy settings
- May need to run as Administrator first time
- Some webcams need specific drivers
- Virtual cameras (OBS, etc.) may not work

### Linux
- Requires V4L2 drivers
- May need user in `video` group
- Check with: `ls /dev/video*`

### macOS
- Requires camera entitlement (already configured)
- System will prompt for camera permission
- Grant permission when prompted

---

## Advanced Debugging

### Enable Verbose Logging

Edit `project.godot` and add:
```ini
[debug]
gdscript/warnings/verbose = true
```

### Check Godot Version

In console, look for:
```
Godot Version: 4.5-stable (official)
```

Ensure it's exactly `4.5-stable`. Other versions may have issues.

### Test CameraServer Manually

Create a test scene with this script:
```gdscript
extends Node

func _ready():
	var server = CameraServer
	print("Feed count: ", server.get_feed_count())
	
	var feed = server.add_feed("Test", CameraServer.FEED_RGBA_IMAGE, Transform2D())
	print("Add result: ", feed)
	
	if feed:
		print("Feed name: ", feed.get_name())
		print("Feed ID: ", feed.get_id())
```

Run and check output. This isolates camera issues from MediaPipe/GDMP.

---

## Getting Help

When reporting camera issues, please include:

1. **Full console output** - Run from command prompt
2. **Log file** - From `%APPDATA%\Godot\app_userdata\VRig\vrig_debug.log`
3. **System info:**
   - Windows version
   - Camera model
   - Godot version (from log)
   - VRig version/build
4. **What you tried** - From this troubleshooting guide
5. **Other apps** - Does Windows Camera app work?

---

## Quick Checklist

Before reporting an issue, verify:

- [ ] Ran VRig from command prompt to see console
- [ ] Checked Windows camera permissions (Privacy settings)
- [ ] Closed all other apps using camera
- [ ] Tested camera in Windows Camera app
- [ ] Checked for GDMP .dll files
- [ ] Looked for error messages in console
- [ ] Identified where initialization stops
- [ ] Included full console output when reporting

---

## Expected Behavior

**With working camera and model:**
- Camera preview appears in bottom-right
- VRM model moves with your body
- Face expressions track
- Hands track

**With working camera, no model:**
- Camera preview appears
- No tracking (need to download model)
- VRM model can still be loaded and posed

**Without camera:**
- App still runs
- VRM model can be loaded
- No tracking available
- Manual posing still works

---

## Model File Download

Even if camera works, you need the MediaPipe model for tracking:

**Download:** https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task

**Place in:** `%APPDATA%\Godot\app_userdata\VRig\holistic_landmarker.task`

**Size:** ~14 MB

**After download:** Restart VRig

---

## Success Indicators

You'll know it's working when you see:

```
[HolisticSolution] Camera initialized successfully: Camera 0
[HolisticSolution] Creating holistic graph...
[HolisticSolution] MediaPipe graph created successfully
```

And in the application:
- Camera preview visible (bottom-right corner)
- VRM model moves when you move
- No error messages in UI

---

## Still Not Working?

If you've tried everything and camera still won't load:

1. **Create an issue** on GitHub with:
   - Full console output
   - Log file
   - System information
   - What you tried

2. **Alternative:** Use without camera
   - Manual posing still works
   - Can load and view VRM models
   - Settings and other features work

3. **Workaround:** Use Unity version
   - **WAIT!** Unity version is deprecated
   - Has other bugs
   - Not recommended

4. **Better workaround:** Use desktop Godot editor
   - Open project in Godot 4.5 editor
   - Run from editor (F5)
   - May have better camera support
   - Can debug more easily

---

**Last Updated:** 2026-02-10
**Version:** Godot 4.5 Migration

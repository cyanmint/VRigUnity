# Testing VRig Godot

This document describes how to test the Godot version of VRig.

## Prerequisites

- Godot 4.5-stable installed
- godot-vrm addon installed (included in addons/)
- (Optional) GDMP addon with native libraries for MediaPipe

## Quick Test

### Test VRM Loading

Run the automated test:

```bash
godot --headless --path . scenes/test_vrm_loading.tscn
```

Expected output:
```
=== VRM Loading Test ===
✓ godot-vrm addon found
✓ SceneModel created
✓ GLTF and VRM extension instances created
✓ VRM extension registered
=== All tests passed! ===
```

### Test Main Scene

Run the main application:

```bash
godot scenes/workspace.tscn
```

Or from Godot Editor:
1. Open project
2. Press F5 or click Play button
3. Main scene should load

## Manual Testing

### Test VRM Model Loading

1. Launch the application
2. Click "Load VRM Model" button
3. Select a .vrm file
4. Model should appear in viewport

### Test Camera Controls

- **Pan:** Hold Shift + drag mouse
- **Rotate:** Hold Ctrl + drag mouse
- **Zoom:** Mouse wheel

### Test Settings

1. Click "Settings" button
2. Modify settings
3. Click "Save"
4. Restart application
5. Verify settings persisted

### Test Localization

1. Open Settings
2. Change language
3. UI text should update (if translations exist)

## Running Tests in CI

The GitHub Actions workflow automatically:

1. Imports the project
2. Builds for Linux, Windows, macOS
3. Uploads build artifacts

Workflow file: `.github/workflows/godot-build.yml`

## Known Issues

### GDMP Native Libraries Missing

**Issue:** GDMP extension fails to load
```
ERROR: GDExtension dynamic library not found: 'res://addons/GDMP/GDMP.gdextension'
```

**Status:** Expected - native libraries not included in git

**Workaround:** 
1. Build GDMP from source, OR
2. Download pre-built binaries if available

**Impact:** MediaPipe tracking unavailable until libraries are provided

### Export Templates Required

**Issue:** Cannot export without templates

**Solution:** 
- Install via Godot Editor: Editor → Manage Export Templates
- Or use Docker CI image which includes templates

## Test Checklist

- [x] Project imports without errors (except GDMP libraries)
- [x] VRM addon loads correctly
- [x] SceneModel can be instantiated
- [x] GLTF/VRM extension works
- [x] Main scene loads
- [x] Camera controls work
- [x] Settings system works
- [x] Localization system works
- [ ] VRM model loads (requires test .vrm file)
- [ ] MediaPipe tracking works (requires GDMP libraries)
- [ ] VMC protocol works (needs implementation)
- [ ] Export builds work (requires export templates)

## Performance Testing

### FPS Monitoring

Add to main scene:

```gdscript
func _process(_delta):
    if Input.is_action_just_pressed("ui_f3"):
        print("FPS: ", Engine.get_frames_per_second())
```

### Memory Monitoring

```gdscript
func _process(_delta):
    if Input.is_action_just_pressed("ui_f4"):
        print("Memory: ", OS.get_static_memory_usage() / 1024.0 / 1024.0, " MB")
```

## Platform-Specific Testing

### Linux
- Test webcam access: `v4l2-ctl --list-devices`
- Check permissions: user in `video` group

### Windows
- Test virtual camera (if implemented)
- Check DirectShow compatibility

### macOS
- Test camera permissions
- Test on both Intel and M1/M2

## Debugging

### Enable Verbose Logging

```bash
godot --verbose scenes/workspace.tscn
```

### Check Console Output

All systems print initialization messages:
- VRig Godot Edition Starting...
- SceneModel initialized
- Settings loaded from: ...
- Loaded language: ...

### Common Issues

**Issue:** Addon not found
- Check `addons/vrm/plugin.cfg` exists
- Check `addons/GDMP/plugin.cfg` exists

**Issue:** Import errors
- Delete `.godot/` folder
- Re-import: `godot --headless --editor --quit`

**Issue:** Script errors
- Check Godot console for line numbers
- Verify GDScript syntax

## Continuous Integration

CI runs on every push to test branches:

```yaml
on:
  push:
    branches: [ copilot/translate-unity-to-godot, main ]
```

Builds are uploaded as artifacts for 14 days.

## Next Steps

1. Add VRM test file to repository (or download separately)
2. Build GDMP native libraries
3. Implement MediaPipe integration
4. Add end-to-end integration tests
5. Performance profiling and optimization

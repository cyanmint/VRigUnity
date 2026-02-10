# Build and Test Guide

## Quick Build Test

This guide helps you quickly build and test VRig Godot to identify and fix bugs.

### Prerequisites

1. **Godot 4.5-stable** installed
2. **GDMP v0.6** addon with native libraries
3. **godot-vrm** addon installed
4. **MediaPipe model** downloaded (optional for basic testing)

### Step 1: Import Project

```bash
cd /path/to/VRigUnity

# Import project (generates .godot folder)
godot --headless --editor --quit 2>&1 | tee import.log

# Check for errors
grep -E "ERROR|Parse Error" import.log
```

**Expected:** GDMP library loading error in headless mode is normal. Look for script parse errors.

### Step 2: Check Scripts

```bash
# Check main scripts for syntax errors
godot --headless --path . --check-only --script scripts/main.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR" || echo "✓ main.gd OK"

godot --headless --path . --check-only --script scripts/holistic/holistic_solution.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR" || echo "✓ holistic_solution.gd OK"

godot --headless --path . --check-only --script scripts/scene_model/scene_model.gd 2>&1 | grep -E "Parse Error|SCRIPT ERROR" || echo "✓ scene_model.gd OK"
```

### Step 3: Test Run (GUI Mode)

If you have a desktop environment:

```bash
# Run the main scene
godot --path . scenes/workspace.tscn

# With verbose output
godot --path . --verbose scenes/workspace.tscn
```

**Check the console for:**
- Initialization messages
- Camera setup
- Model loading
- Any errors or warnings

### Step 4: Check Logs

After running, check the debug log:

```bash
# Linux/Mac
cat ~/.local/share/godot/app_userdata/VRig/vrig_debug.log

# Should see entries like:
# [INFO] [Main] VRig Godot Edition Starting...
# [DEBUG] [Main] Setting up camera controls
# [INFO] [Main] Scene model initialized successfully
```

### Step 5: Build Exports

#### Linux Build

```bash
mkdir -p build/linux
godot --headless --export-release "Linux/X11" build/linux/VRig.x86_64 2>&1 | tee build_linux.log

# Check build
ls -lh build/linux/
```

#### Windows Build

```bash
mkdir -p build/windows
godot --headless --export-release "Windows Desktop" build/windows/VRig.exe 2>&1 | tee build_windows.log

# Check build
ls -lh build/windows/
```

#### macOS Build

```bash
mkdir -p build/macos
godot --headless --export-release "macOS" build/macos/VRig.zip 2>&1 | tee build_macos.log

# Check build
ls -lh build/macos/
```

### Step 6: Test Built Executable

```bash
# Linux
cd build/linux
./VRig.x86_64

# Check log after running
cat ~/.local/share/godot/app_userdata/VRig/vrig_debug.log
```

## Common Build Errors and Fixes

### Error: "No valid export preset found"

**Fix:** Ensure `export_presets.cfg` exists and contains export configurations.

```bash
# Check export presets
cat export_presets.cfg | grep -A 5 "name="
```

### Error: "Export templates not found"

**Fix:** Install Godot export templates:

```bash
# Download templates
wget https://github.com/godotengine/godot/releases/download/4.5-stable/Godot_v4.5-stable_export_templates.tpz

# Extract to templates directory
mkdir -p ~/.local/share/godot/export_templates/4.5.stable
unzip Godot_v4.5-stable_export_templates.tpz -d ~/.local/share/godot/export_templates/4.5.stable
```

### Error: "Can't open dynamic library: libGDMP.linux.so"

**In Headless Mode:** This is expected - GDMP requires graphics libraries

**In Desktop Mode:** Install graphics libraries:
```bash
# Ubuntu/Debian
sudo apt-get install libgl1-mesa-dev libgles2-mesa-dev

# Fedora  
sudo dnf install mesa-libGL-devel mesa-libGLES-devel
```

### Error: "Parse Error" in scripts

**Fix:** Check the specific script for syntax errors:

```bash
# Get detailed error
godot --headless --check-only --script scripts/problematic_script.gd
```

Common issues:
- Missing colons after function definitions
- Incorrect indentation
- Invalid GDScript syntax (e.g., try/except not supported)

## Automated Test Script

Create `test_build.sh`:

```bash
#!/bin/bash
set -e

echo "=== VRig Build Test ==="

echo "1. Importing project..."
godot --headless --editor --quit 2>&1 | tee import.log
if grep -q "SCRIPT ERROR\|Parse Error" import.log; then
    echo "❌ Import failed - check import.log"
    exit 1
fi
echo "✓ Import successful"

echo ""
echo "2. Checking main scripts..."
scripts_ok=true

check_script() {
    local script=$1
    if godot --headless --path . --check-only --script "$script" 2>&1 | grep -q "Parse Error\|SCRIPT ERROR"; then
        echo "❌ $script has errors"
        scripts_ok=false
    else
        echo "✓ $script OK"
    fi
}

check_script "scripts/main.gd"
check_script "scripts/holistic/holistic_solution.gd"
check_script "scripts/scene_model/scene_model.gd"
check_script "scripts/utils/debug_logger.gd"

if [ "$scripts_ok" = false ]; then
    echo "❌ Script checks failed"
    exit 1
fi

echo ""
echo "3. Building Linux export..."
mkdir -p build/linux
if godot --headless --export-release "Linux/X11" build/linux/VRig.x86_64 2>&1 | tee build.log | grep -q "ERROR"; then
    echo "❌ Build failed - check build.log"
    exit 1
fi

if [ -f "build/linux/VRig.x86_64" ]; then
    echo "✓ Build successful: $(ls -lh build/linux/VRig.x86_64 | awk '{print $5}')"
else
    echo "❌ Build file not created"
    exit 1
fi

echo ""
echo "=== All tests passed! ==="
```

Make it executable and run:

```bash
chmod +x test_build.sh
./test_build.sh
```

## Continuous Testing

For development, use a file watcher:

```bash
# Install inotify-tools (Linux)
sudo apt-get install inotify-tools

# Watch for changes and re-run tests
while inotifywait -r -e modify scripts/; do
    echo "Changes detected, running tests..."
    ./test_build.sh
done
```

## Performance Testing

Add performance monitoring to your code:

```gdscript
# In _process or _physics_process
var fps = Engine.get_frames_per_second()
if fps < 30:
    DebugLogger.log_warning("Performance", "Low FPS: " + str(fps))

# Memory check
var mem_mb = OS.get_static_memory_usage() / 1024.0 / 1024.0
if mem_mb > 500:
    DebugLogger.log_warning("Memory", "High memory usage: " + str(mem_mb) + " MB")
```

## Debugging Build Issues

If builds fail or crash:

1. **Check export log** for specific errors
2. **Verify export presets** are configured correctly
3. **Test in editor first** before building
4. **Check dependencies** (addons, models, assets)
5. **Review debug log** from test run

## Conclusion

Regular build testing helps catch issues early. Use the automated test script in CI/CD pipelines for continuous validation.

For detailed debugging, see [DEBUGGING.md](./DEBUGGING.md).

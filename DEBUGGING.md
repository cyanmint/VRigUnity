# Debugging Guide for VRig Godot

## Debug Logging System

VRig now includes a comprehensive debug logging system that outputs detailed information to both console and log files.

### Accessing Logs

#### Log File Location

The debug log is automatically created at:
- **Linux:** `~/.local/share/godot/app_userdata/VRig/vrig_debug.log`
- **Windows:** `%APPDATA%\Godot\app_userdata\VRig\vrig_debug.log`
- **macOS:** `~/Library/Application Support/Godot/app_userdata/VRig/vrig_debug.log`

#### Viewing Logs

**During Development:**
```bash
# Linux/Mac - tail the log file to see real-time updates
tail -f ~/.local/share/godot/app_userdata/VRig/vrig_debug.log

# Windows PowerShell
Get-Content "$env:APPDATA\Godot\app_userdata\VRig\vrig_debug.log" -Wait
```

**After Running:**
```bash
# Linux/Mac
cat ~/.local/share/godot/app_userdata/VRig/vrig_debug.log

# Windows
type %APPDATA%\Godot\app_userdata\VRig\vrig_debug.log
```

### Log Levels

The logger supports 5 log levels:

1. **DEBUG** - Detailed information for diagnosing problems
2. **INFO** - General informational messages
3. **WARNING** - Warning messages for non-critical issues
4. **ERROR** - Error messages for serious problems
5. **CRITICAL** - Critical errors that may cause app failure

### Using the Logger in Code

```gdscript
# Log at different levels
DebugLogger.log_debug("MyClass", "Detailed debug information")
DebugLogger.log_info("MyClass", "Something happened")
DebugLogger.log_warning("MyClass", "Warning about something")
DebugLogger.log_error("MyClass", "An error occurred")
DebugLogger.log_critical("MyClass", "Critical failure!")

# Log error with additional details
DebugLogger.log_error("MyClass", "Failed to load file", "File not found: model.vrm")

# Get log file path programmatically
var log_path = DebugLogger.get_log_file_path()
print("Logs at: " + log_path)
```

### Log Format

Each log entry includes:
- Timestamp (HH:MM:SS)
- Log level
- Source component
- Message

Example:
```
[14:23:45] [INFO] [Main] VRig Godot Edition Starting...
[14:23:45] [DEBUG] [Main] Setting up camera controls
[14:23:46] [ERROR] [HolisticSolution] No camera feeds available
```

## Common Issues and Solutions

### 1. GDMP Library Loading Error

**Error:**
```
ERROR: Can't open dynamic library: libGDMP.linux.so
Error: libGLESv2.so.2: cannot open shared object file
```

**Solution:**
- This error occurs in headless environments without graphics libraries
- Install graphics libraries:
  ```bash
  # Ubuntu/Debian
  sudo apt-get install libgl1-mesa-dev libgles2-mesa-dev
  
  # Fedora
  sudo dnf install mesa-libGL-devel mesa-libGLES-devel
  ```
- Or run on a system with desktop graphics support

### 2. No Camera Feeds Available

**Error:**
```
[ERROR] [HolisticSolution] No camera feeds available
```

**Solution:**
- Ensure you have a webcam connected
- Check webcam permissions in system settings
- On Linux, ensure your user is in the `video` group:
  ```bash
  sudo usermod -a -G video $USER
  # Log out and back in
  ```

### 3. Model File Not Found

**Warning:**
```
[WARNING] [HolisticSolution] Holistic model file not found at: res://addons/GDMP/models/holistic_landmarker.task
```

**Solution:**
- Download the MediaPipe model (see `addons/GDMP/MODELS.md`)
- Place it in the correct location: `addons/GDMP/models/holistic_landmarker.task`

### 4. VRM Model Loading Fails

**Error:**
```
[ERROR] [SceneModel] Failed to load VRM model
```

**Solutions:**
- Verify the VRM file is valid (test in another VRM viewer)
- Check file path is correct
- Ensure godot-vrm addon is properly installed
- Check logs for specific error details

## Building and Running

### Development Mode

```bash
# Run from command line with console output
godot --path /path/to/VRigUnity scenes/workspace.tscn

# Run with verbose output
godot --path /path/to/VRigUnity --verbose scenes/workspace.tscn
```

### Build for Testing

```bash
# Linux
godot --headless --export-release "Linux/X11" build/vrig_linux

# Windows (from Linux)
godot --headless --export-release "Windows Desktop" build/vrig_windows.exe

# macOS (from Linux)
godot --headless --export-release "macOS" build/vrig_macos.zip
```

### Check for Script Errors

```bash
# Check all scripts for parse errors
cd /path/to/VRigUnity
find scripts -name "*.gd" -exec godot --headless --check-only --script {} \; 2>&1 | grep -E "(ERROR|Parse Error)"
```

## Performance Profiling

### Monitor Performance

Add to any script:
```gdscript
func _process(delta):
    if Engine.get_frames_per_second() < 30:
        DebugLogger.log_warning("Performance", "Low FPS: " + str(Engine.get_frames_per_second()))
```

### Memory Monitoring

```gdscript
func check_memory():
    var mem = OS.get_static_memory_usage()
    DebugLogger.log_info("Memory", "Memory usage: " + str(mem / 1024 / 1024) + " MB")
```

## Debugging Workflow

1. **Run the application** with logging enabled
2. **Reproduce the issue** you're investigating
3. **Check the log file** for errors and warnings
4. **Identify the source** component and error message
5. **Fix the issue** and verify with logs
6. **Commit fixes** with descriptive messages

## Advanced Debugging

### Enable Debug Builds

In `export_presets.cfg`, set:
```ini
debug/debugging_enabled=true
script/script_encryption_key=""
```

### GDScript Debugger

```bash
# Run with debugger
godot --path /path/to/VRigUnity --debug scenes/workspace.tscn

# Remote debugging
godot --path /path/to/VRigUnity --remote-debug tcp://127.0.0.1:6007
```

### Print Stack Traces

```gdscript
func debug_function():
    DebugLogger.log_debug("Debug", "Stack trace: " + str(get_stack()))
```

## Reporting Issues

When reporting bugs, please include:
1. Full log file contents
2. Steps to reproduce
3. Expected vs actual behavior
4. System information (OS, Godot version)
5. VRM model info (if applicable)

## Log Rotation

Logs automatically rotate when they exceed 10MB:
- Current log: `vrig_debug.log`
- Previous log: `vrig_debug.log.old`

To change the rotation size, edit `scripts/utils/debug_logger.gd`:
```gdscript
var max_log_size := 10 * 1024 * 1024  # Change this value
```

## Clearing Logs

```gdscript
# Programmatically clear logs
DebugLogger.clear_log()
```

Or manually delete the log file when the app is not running.

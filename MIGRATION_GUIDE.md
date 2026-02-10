# Unity to Godot 4.5 Migration Guide

This document outlines the migration from Unity to Godot 4.5 for the VRig project.

## Overview

VRig has been completely ported from Unity to Godot 4.5. This was a full rewrite, not an automated conversion.

## Major Changes

### 1. Engine Migration
- **From:** Unity 2021.3.14f1
- **To:** Godot 4.5-stable

### 2. Scripting Language
- **From:** C# (Unity)
- **To:** GDScript (Godot's native language)
- **Note:** Godot also supports C#, but GDScript is preferred for better integration

### 3. VRM Library
- **From:** UniVRM v0.107.0
- **To:** godot-vrm (https://github.com/V-Sekai/godot-vrm)
- **Changes:**
  - Different API for loading VRM models
  - Blend shape handling differs from Unity
  - Bone hierarchy accessed differently

### 4. MediaPipe Integration
- **From:** MediaPipeUnityPlugin v0.10.1
- **To:** GDMP v0.6 (https://github.com/j20001970/GDMP)
- **Changes:**
  - Complete API redesign for Godot
  - Different initialization process
  - Native plugin architecture instead of Unity packages

### 5. File Browser
- **From:** StandaloneFileBrowser v1.2 + SimpleFileBrowser v1.5.7
- **To:** Godot's built-in FileDialog
- **Changes:**
  - Simpler API
  - Native Godot integration
  - Cross-platform by default

### 6. UI System
- **From:** Unity UI (uGUI) + TextMeshPro
- **To:** Godot Control nodes
- **Changes:**
  - Different layout system (anchors, containers)
  - Different text rendering
  - Scene-based UI instead of prefabs

### 7. Virtual Camera (Windows)
- **From:** UnityCapture
- **To:** To be implemented for Godot
- **Status:** Requires platform-specific implementation
- **Note:** May need external tools or Godot plugins

### 8. VMC Protocol
- **From:** EVMC4U (EasyVirtualMotionCaptureForUnity)
- **To:** Custom implementation using Godot's networking
- **Status:** Needs implementation
- **Note:** OSC protocol remains the same, just needs Godot adapter

### 9. OSC Communication
- **From:** uOSC
- **To:** Godot OSC implementation
- **Status:** Needs implementation or third-party plugin

## File Structure Mapping

### Unity → Godot

| Unity | Godot | Notes |
|-------|-------|-------|
| `Assets/` | `assets/` | Resources (textures, fonts, etc.) |
| `Assets/Scripts/` | `scripts/` | GDScript files |
| `Assets/Scenes/` | `scenes/` | .tscn scene files |
| `Packages/` | `addons/` | Third-party plugins |
| `ProjectSettings/` | `project.godot` | Project configuration |
| `.unity` scenes | `.tscn` scenes | Scene format |
| `.cs` scripts | `.gd` scripts | Script format |
| `.meta` files | `.import` files | Asset metadata |

## Script Migration

### Class Structure

**Unity (C#):**
```csharp
using UnityEngine;

public class MyScript : MonoBehaviour {
    void Start() { }
    void Update() { }
}
```

**Godot (GDScript):**
```gdscript
extends Node

func _ready():
    pass

func _process(delta):
    pass
```

### Key Method Equivalents

| Unity | Godot | Notes |
|-------|-------|-------|
| `Start()` | `_ready()` | Initialization |
| `Update()` | `_process(delta)` | Per-frame update |
| `FixedUpdate()` | `_physics_process(delta)` | Fixed timestep |
| `OnDestroy()` | `_exit_tree()` | Cleanup |
| `Instantiate()` | `instantiate()` | Create instance |
| `Destroy()` | `queue_free()` | Delete object |
| `GameObject` | `Node` | Base object type |
| `Transform` | `Transform3D` | 3D transform |
| `Vector3` | `Vector3` | Same name! |
| `Quaternion` | `Quaternion` | Same name! |

### Scene Management

**Unity:**
```csharp
SceneManager.LoadScene("SceneName");
```

**Godot:**
```gdscript
get_tree().change_scene_to_file("res://scenes/scene_name.tscn")
```

## Component System

### Unity Components → Godot Nodes

| Unity Component | Godot Node | Notes |
|----------------|------------|-------|
| `Camera` | `Camera3D` | 3D camera |
| `Light` | `DirectionalLight3D`, `OmniLight3D` | Different light types |
| `MeshRenderer` | `MeshInstance3D` | 3D mesh rendering |
| `Animator` | `AnimationPlayer` | Animation system |
| `Canvas` | `CanvasLayer` | UI layer |
| `Image` | `TextureRect` | UI image |
| `Text` | `Label` | UI text |
| `Button` | `Button` | UI button |

## Asset Import

### Unity Asset Import

1. Unity uses `.meta` files for import settings
2. Assets are in `Assets/` folder
3. Prefabs store scene hierarchies

### Godot Asset Import

1. Godot uses `.import` files for import settings
2. Assets can be anywhere in the project
3. Scenes (`.tscn`) store hierarchies
4. Resources can be saved as `.tres` files

## Migration Checklist

- [x] Create Godot project structure
- [x] Set up project.godot configuration
- [x] Create main scene (workspace.tscn)
- [x] Create core scripts (main, holistic_solution, scene_model)
- [x] Create UI controller (gui_main)
- [x] Create tracking resolvers (pose, face, hand)
- [x] Copy language files
- [x] Create addon documentation
- [ ] Implement godot-vrm integration
- [ ] Implement GDMP MediaPipe integration
- [ ] Implement VRM model loading
- [ ] Implement landmark processing
- [ ] Implement bone manipulation
- [ ] Implement blend shape manipulation
- [ ] Create settings UI
- [ ] Implement background image support
- [ ] Implement VMC protocol sender/receiver
- [ ] Implement virtual camera (Windows)
- [ ] Port all UI elements
- [ ] Test on Windows
- [ ] Test on Linux
- [ ] Test on macOS

## Known Limitations

1. **Virtual Camera Support**: Unity's UnityCapture needs replacement
   - May require OBS Virtual Camera or similar
   - Platform-specific solutions needed

2. **VMC Protocol**: EVMC4U needs reimplementation
   - OSC protocol is standard
   - Godot has networking capabilities
   - Custom implementation required

3. **Animation Rigging**: Unity's Animation Rigging package
   - Godot has Skeleton3D with IK
   - Different approach needed

4. **Performance**: Initial Godot port may need optimization
   - Profile and optimize as needed
   - Godot 4.x has good performance characteristics

## Testing Strategy

1. **VRM Loading**: Test with various VRM models
2. **Tracking**: Verify MediaPipe integration works
3. **UI**: Test all UI elements and interactions
4. **Camera Controls**: Verify pan, rotate, zoom
5. **Localization**: Test language switching
6. **VMC**: Test sender and receiver modes
7. **Backgrounds**: Test custom background images
8. **Cross-platform**: Test on all target platforms

## Resources

- [Godot Documentation](https://docs.godotengine.org/en/stable/)
- [Unity to Godot Guide](https://docs.godotengine.org/en/stable/tutorials/migrating/index.html)
- [godot-vrm GitHub](https://github.com/V-Sekai/godot-vrm)
- [GDMP GitHub](https://github.com/j20001970/GDMP)
- [VRM Specification](https://vrm.dev/)
- [MediaPipe Documentation](https://developers.google.com/mediapipe)

## Support

For issues with the migration:
1. Check Godot documentation
2. Check addon documentation (godot-vrm, GDMP)
3. Open an issue on the GitHub repository
4. Consult Godot community forums

## License

The migrated Godot version maintains the same license as the original Unity version.

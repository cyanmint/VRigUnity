# VRig (Godot 4.5 Edition)

> ## ⚠️ IMPORTANT: Unity Version Deprecated
> 
> **The Unity version is NO LONGER SUPPORTED.**
> 
> If you're experiencing Unity issues (model can't move, settings won't open, camera not loading), 
> please **switch to the Godot version immediately**.
> 
> See [UNITY_DEPRECATED.md](./UNITY_DEPRECATED.md) for migration instructions.

> **🚀 This project has been migrated from Unity to Godot 4.5!**
> 
> For the Godot-specific documentation, see [README_GODOT.md](./README_GODOT.md)
> 
> For migration details, see [MIGRATION_GUIDE.md](./MIGRATION_GUIDE.md)

A virtual character animator. This app uses your webcam and an AI to move a `VRM` model.

This app can be used in combination with other tools like *VSeeFace* and *VRM Posing Desktop*

<a href="https://github.com/Kariaro/VRigUnity/releases/latest" target="blank"><b>Download</b></a>

![Example](.github/assets/videos/show0.gif)

## Info
This app has been tested on:
+ *Windows 10*
+ *Ubuntu 18.04*
+ *Mac 11.x & 12.x*

Features:
* Panning and rotation controls
  - Shift to Pan
  - Ctrl to Rotate
* Allows custom background images
* Allows custom VRM models
* VMC sender and receiver
* Virtual camera support *(Only Windows)*

## Translations
It is allowed to make PR's for language translations of this app.

Here is a small guide on how to add translations: [Translation Guide](./assets/lang/README.md)

## Translation Credits


## Dependencies (Godot 4.5)

**This is now a Godot project. The Unity dependencies listed below are for reference only.**

### Current Godot Dependencies
+ [godot-vrm](https://github.com/V-Sekai/godot-vrm) - VRM model support for Godot
+ [GDMP v0.6](https://github.com/j20001970/GDMP/releases/tag/v0.6) - MediaPipe for Godot
+ Godot's built-in FileDialog (replaces StandaloneFileBrowser and SimpleFileBrowser)
+ VMC Protocol implementation (custom, replaces EVMC4U)

### Legacy Unity Dependencies (Reference)
The original Unity version used:
+ [MediaPipeUnityPlugin v0.10.1](https://github.com/homuler/MediaPipeUnityPlugin)
+ [UniVRM v0.107.0](https://github.com/vrm-c/UniVRM)
+ [StandaloneFileBrowser v1.2](https://github.com/gkngkc/UnityStandaloneFileBrowser)
+ [SimpleFileBrowser v1.5.7](https://github.com/yasirkula/UnitySimpleFileBrowser)
+ [UnityCapture (fe461e8f6e1cd1e6a0dfa9891147c8e393a20a2c)](https://github.com/schellingb/UnityCapture)
+ [EasyVirtualMotionCaptureForUnity v3_9c](https://github.com/gpsnmeajp/EasyVirtualMotionCaptureForUnity)

## Building
See [BUILD_GODOT.md](./BUILD_GODOT.md) for Godot build instructions.

For historical Unity build info, see [BUILD.md](./BUILD.md)

## Troubleshooting Unity Issues

**If you're running the old Unity build and experiencing issues:**

Common Unity problems (unfixed):
- ❌ Model can't be moved
- ❌ Settings can't be opened
- ❌ Camera not loading
- ❌ Tracking unstable
- ❌ High CPU/memory usage

**Solution: Switch to Godot version**

See [UNITY_DEPRECATED.md](./UNITY_DEPRECATED.md) for:
- Why Unity is deprecated
- How to migrate to Godot
- Download links for Godot builds
- Settings migration guide

The Godot version fixes all these issues and provides better performance.

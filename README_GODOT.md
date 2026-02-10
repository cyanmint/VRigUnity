# VRig (Godot 4.5)

**This project has been migrated from Unity to Godot 4.5**

A virtual character animator. This app uses your webcam and an AI to move a `VRM` model.

This app can be used in combination with other tools like *VSeeFace* and *VRM Posing Desktop*

## Features
* Panning and rotation controls
  - Shift to Pan
  - Ctrl to Rotate
* Allows custom background images
* Allows custom VRM models
* VMC sender and receiver
* Face, pose, and hand tracking using MediaPipe

## Tested Platforms
* Windows 10/11
* Linux (Ubuntu 18.04+)
* macOS 11.x & 12.x

## Dependencies

This Godot version uses the following plugins:

* **godot-vrm** - VRM model support for Godot
  - Source: https://github.com/V-Sekai/godot-vrm
  - Used for loading and animating VRM models

* **GDMP (Godot MediaPipe)** - MediaPipe integration for Godot
  - Version: v0.6
  - Source: https://github.com/j20001970/GDMP/releases/tag/v0.6
  - Used for face, pose, and hand tracking

## Installation

### Prerequisites
- Godot 4.5-stable

### Setting up the project

1. Clone this repository
2. Install the required addons (see below)
3. Open the project in Godot 4.5
4. Run the main scene: `scenes/workspace.tscn`

### Installing Addons

#### godot-vrm
1. Download godot-vrm from https://github.com/V-Sekai/godot-vrm
2. Copy the `addons/vrm` folder to this project's `addons/` directory

#### GDMP (MediaPipe)
1. Download GDMP v0.6 from https://github.com/j20001970/GDMP/releases/tag/v0.6
2. Copy the `addons/GDMP` folder to this project's `addons/` directory
3. Enable the plugin in Project Settings → Plugins

## Building

See [BUILD.md](./BUILD.md) for build instructions.

## Translations

It is allowed to make PR's for language translations of this app.

Translation files are located in `assets/lang/`

## Migration Notes

This project was originally built in Unity and has been fully ported to Godot 4.5. Key changes include:

- **VRM Support**: Replaced UniVRM with godot-vrm
- **MediaPipe**: Replaced MediaPipeUnityPlugin with GDMP
- **Scripting**: Converted from C# Unity scripts to GDScript/C# for Godot
- **UI**: Rebuilt using Godot's Control nodes
- **Scene Structure**: Converted Unity scenes to Godot .tscn format

## License

See [LICENSE](./LICENSE) file for details.

## Original Project

Original Unity version: https://github.com/Kariaro/VRigUnity (if this is the original repo, it's now been migrated to Godot)

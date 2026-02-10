# Contributing to VRig Godot Edition

Thank you for your interest in contributing to VRig! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with:
- A clear title and description
- Steps to reproduce the bug
- Expected behavior vs actual behavior
- Your platform (Windows/Linux/macOS)
- Godot version
- Any error messages from the console

### Suggesting Features

Feature suggestions are welcome! Please open an issue with:
- A clear description of the feature
- Why it would be useful
- How it might work
- Any examples from other applications

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/my-feature`
3. **Make your changes**
4. **Test your changes thoroughly**
5. **Commit with clear messages**: `git commit -m "Add feature X"`
6. **Push to your fork**: `git push origin feature/my-feature`
7. **Open a Pull Request**

## Development Setup

See [QUICKSTART.md](./QUICKSTART.md) for setting up the development environment.

## Code Style Guidelines

### GDScript Style

Follow the [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html):

```gdscript
# Use snake_case for variables and functions
var player_speed = 10
func calculate_damage():
    pass

# Use PascalCase for class names
class_name PlayerController

# Use CONSTANT_CASE for constants
const MAX_HEALTH = 100

# Use clear, descriptive names
var health_points = 100  # Good
var hp = 100  # Less clear

# Add type hints where possible
var score: int = 0
func get_position() -> Vector3:
    return Vector3.ZERO

# Document classes and complex functions
## This class manages player inventory
class_name Inventory

func complex_algorithm(param: int) -> bool:
    ## Performs a complex calculation
    ## Returns true if successful
    pass
```

### Scene Organization

- Keep scenes organized in the `scenes/` folder
- Use descriptive names for nodes
- Group related nodes under parent nodes
- Add comments in scene scripts

### File Organization

```
scripts/
├── main.gd              # Main scene controller
├── holistic/            # MediaPipe tracking
├── scene_model/         # VRM model management
├── ui/                  # UI controllers
└── utils/               # Utilities and helpers

scenes/
├── workspace.tscn       # Main scene
└── ui/                  # UI scenes

assets/
├── fonts/
├── textures/
├── lang/                # Translations
└── models/              # VRM models (not in git)
```

## Testing

Before submitting a PR:

1. **Test your changes**
   - Run the application
   - Test affected features
   - Check for console errors

2. **Test on your platform**
   - Windows/Linux/macOS
   - Different screen resolutions

3. **Check performance**
   - Monitor FPS
   - Check memory usage

## Priority Areas for Contribution

### High Priority

1. **GDMP Integration**
   - Complete MediaPipe Holistic implementation
   - Test with different cameras and lighting
   - Optimize performance

2. **godot-vrm Integration**
   - Complete VRM loading
   - Implement blend shapes
   - Test with various VRM models

3. **Tracking Accuracy**
   - Improve pose mapping
   - Improve facial expression mapping
   - Add smoothing/interpolation

### Medium Priority

1. **UI Improvements**
   - Better visualization
   - More settings options
   - Improved user feedback

2. **Performance Optimization**
   - Profile and optimize hot paths
   - Reduce memory allocations
   - Optimize rendering

3. **Documentation**
   - Code documentation
   - User guides
   - Video tutorials

### Low Priority

1. **VMC Protocol**
   - OSC implementation
   - Testing with external tools

2. **Additional Features**
   - Recording/playback
   - Pose presets
   - Custom animations

3. **Translations**
   - Add more languages
   - Improve existing translations

## Translation Guidelines

To add a new language:

1. Create a folder in `assets/lang/` with the language code (e.g., `fr_FR`)
2. Create a `.lang` file with the same name (e.g., `fr_FR.lang`)
3. Copy the structure from `en_US.lang`
4. Translate all strings
5. Add the language to `languages.json`
6. Test language switching in the app

Example `.lang` file format:
```
# Comments start with #
welcome_message=Welcome to VRig!
load_model=Load Model
settings=Settings
```

## Commit Message Guidelines

Use clear, descriptive commit messages:

```bash
# Good
git commit -m "Add face tracking smoothing"
git commit -m "Fix VRM blend shape initialization"
git commit -m "Update French translation"

# Less good
git commit -m "fix bug"
git commit -m "update"
git commit -m "wip"
```

For larger changes, use multi-line commits:
```bash
git commit -m "Add VMC protocol support

- Implement OSC sender
- Implement OSC receiver
- Add settings UI for VMC
- Test with VSeeFace"
```

## Pull Request Guidelines

When opening a PR:

1. **Title**: Clear and descriptive
2. **Description**: Explain what and why
3. **Testing**: Describe how you tested
4. **Screenshots**: If UI changes, include screenshots
5. **Breaking Changes**: Note any breaking changes

Example PR description:
```markdown
## Description
Adds support for VMC protocol sending

## Changes
- Implemented OSC protocol from scratch
- Added VMC message formatting
- Added settings UI for VMC configuration
- Added documentation

## Testing
- Tested sending to VSeeFace
- Tested on Windows and Linux
- Verified all bone transforms are sent correctly

## Screenshots
[Screenshot of settings UI]
```

## Code Review Process

1. All PRs require review before merging
2. Address review feedback promptly
3. Keep PRs focused and reasonably sized
4. Be respectful in discussions

## Questions?

If you have questions:
- Open an issue
- Check existing documentation
- Consult the Godot documentation

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Thank You!

Your contributions help make VRig better for everyone!

# Autoload (Singleton) Configuration for VRig

This file documents the autoload singletons used in the VRig Godot project.

## Setting up Autoloads

To configure autoloads in Godot:

1. Go to Project → Project Settings
2. Select the "Autoload" tab
3. Add the following scripts as autoloads:

## Autoload Scripts

### Settings
- **Path:** `res://scripts/utils/settings.gd`
- **Node Name:** `Settings`
- **Description:** Global settings manager
- **Access:** `Settings.show_model`, `Settings.language`, etc.

### Localization
- **Path:** `res://scripts/utils/localization.gd`
- **Node Name:** `Localization`
- **Description:** Translation and localization system
- **Access:** `Localization.tr("key")`, `Localization.set_language("en_US")`

### VMCProtocol (Optional)
- **Path:** `res://scripts/utils/vmc_protocol.gd`
- **Node Name:** `VMC`
- **Description:** VMC protocol sender/receiver
- **Access:** `VMC.send_bone_transform()`, `VMC.start_sending()`

## Usage Example

```gdscript
# Access settings from any script
func _ready():
    if Settings.show_model:
        model.show()
    
    # Get translated text
    var welcome_text = Localization.tr("welcome_message")
    
    # Send VMC data
    if Settings.vmc_enabled:
        VMC.start_sending()
```

## Manual Configuration

If you prefer to configure autoloads manually, edit `project.godot` and add:

```ini
[autoload]

Settings="*res://scripts/utils/settings.gd"
Localization="*res://scripts/utils/localization.gd"
VMC="*res://scripts/utils/vmc_protocol.gd"
```

The `*` prefix means the autoload is instantiated immediately when the project starts.

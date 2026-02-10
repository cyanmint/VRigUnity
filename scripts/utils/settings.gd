extends Node
## Settings manager for VRig
## Handles loading and saving user preferences

# Note: Don't use class_name to avoid conflict with autoload singleton

# Settings file path
const SETTINGS_FILE = "user://settings.cfg"

# Default settings
var config := ConfigFile.new()

# Setting values
var show_model := true
var model_scale := 1.0
var camera_distance := 3.0
var language := "en_US"
var show_webcam := true
var webcam_size := Vector2(320, 240)
var tracking_quality := "high"
var track_face := true
var track_pose := true
var track_hands := true
var vmc_enabled := false
var vmc_port := 39539
var vmc_receive_port := 39540

# Signals
signal settings_changed
signal language_changed(new_language: String)

func _ready():
	load_settings()

func load_settings():
	var err = config.load(SETTINGS_FILE)
	if err != OK:
		print("No settings file found, using defaults")
		save_settings()  # Create default settings file
		return
	
	# Load settings from config
	show_model = config.get_value("display", "show_model", true)
	model_scale = config.get_value("display", "model_scale", 1.0)
	camera_distance = config.get_value("display", "camera_distance", 3.0)
	language = config.get_value("general", "language", "en_US")
	show_webcam = config.get_value("display", "show_webcam", true)
	webcam_size = config.get_value("display", "webcam_size", Vector2(320, 240))
	tracking_quality = config.get_value("tracking", "quality", "high")
	track_face = config.get_value("tracking", "track_face", true)
	track_pose = config.get_value("tracking", "track_pose", true)
	track_hands = config.get_value("tracking", "track_hands", true)
	vmc_enabled = config.get_value("vmc", "enabled", false)
	vmc_port = config.get_value("vmc", "port", 39539)
	vmc_receive_port = config.get_value("vmc", "receive_port", 39540)
	
	print("Settings loaded from: ", SETTINGS_FILE)

func save_settings():
	# Save settings to config
	config.set_value("display", "show_model", show_model)
	config.set_value("display", "model_scale", model_scale)
	config.set_value("display", "camera_distance", camera_distance)
	config.set_value("general", "language", language)
	config.set_value("display", "show_webcam", show_webcam)
	config.set_value("display", "webcam_size", webcam_size)
	config.set_value("tracking", "quality", tracking_quality)
	config.set_value("tracking", "track_face", track_face)
	config.set_value("tracking", "track_pose", track_pose)
	config.set_value("tracking", "track_hands", track_hands)
	config.set_value("vmc", "enabled", vmc_enabled)
	config.set_value("vmc", "port", vmc_port)
	config.set_value("vmc", "receive_port", vmc_receive_port)
	
	var err = config.save(SETTINGS_FILE)
	if err != OK:
		push_error("Failed to save settings: " + str(err))
	else:
		print("Settings saved to: ", SETTINGS_FILE)
		emit_signal("settings_changed")

func set_language(new_language: String):
	if language != new_language:
		language = new_language
		emit_signal("language_changed", new_language)
		save_settings()

func reset_to_defaults():
	show_model = true
	model_scale = 1.0
	camera_distance = 3.0
	language = "en_US"
	show_webcam = true
	webcam_size = Vector2(320, 240)
	tracking_quality = "high"
	track_face = true
	track_pose = true
	track_hands = true
	vmc_enabled = false
	vmc_port = 39539
	vmc_receive_port = 39540
	save_settings()

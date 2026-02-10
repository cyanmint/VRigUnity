extends Panel
## Settings panel UI controller

@onready var settings = Settings.new()
@onready var localization = Localization.new()

# UI references
@onready var show_model_check = $VBoxContainer/ScrollContainer/SettingsContent/DisplaySettings/ShowModelCheck
@onready var show_webcam_check = $VBoxContainer/ScrollContainer/SettingsContent/DisplaySettings/ShowWebcamCheck
@onready var track_face_check = $VBoxContainer/ScrollContainer/SettingsContent/TrackingSettings/TrackFaceCheck
@onready var track_pose_check = $VBoxContainer/ScrollContainer/SettingsContent/TrackingSettings/TrackPoseCheck
@onready var track_hands_check = $VBoxContainer/ScrollContainer/SettingsContent/TrackingSettings/TrackHandsCheck
@onready var vmc_enabled_check = $VBoxContainer/ScrollContainer/SettingsContent/VMCSettings/VMCEnabledCheck
@onready var vmc_port_spin = $VBoxContainer/ScrollContainer/SettingsContent/VMCSettings/VMCPortSpin
@onready var vmc_receive_port_spin = $VBoxContainer/ScrollContainer/SettingsContent/VMCSettings/VMCReceivePortSpin
@onready var language_option = $VBoxContainer/ScrollContainer/SettingsContent/LanguageSettings/LanguageOption
@onready var save_button = $VBoxContainer/ButtonsContainer/SaveButton
@onready var cancel_button = $VBoxContainer/ButtonsContainer/CancelButton
@onready var reset_button = $VBoxContainer/ButtonsContainer/ResetButton

func _ready():
	add_child(settings)
	add_child(localization)
	
	# Connect buttons
	save_button.pressed.connect(_on_save_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	reset_button.pressed.connect(_on_reset_pressed)
	
	# Load settings
	load_ui_from_settings()
	
	# Populate language options
	populate_languages()

func populate_languages():
	language_option.clear()
	var languages = localization.get_available_languages()
	for i in range(languages.size()):
		var lang = languages[i]
		language_option.add_item(lang, i)
		if lang == settings.language:
			language_option.selected = i

func load_ui_from_settings():
	show_model_check.button_pressed = settings.show_model
	show_webcam_check.button_pressed = settings.show_webcam
	track_face_check.button_pressed = settings.track_face
	track_pose_check.button_pressed = settings.track_pose
	track_hands_check.button_pressed = settings.track_hands
	vmc_enabled_check.button_pressed = settings.vmc_enabled
	vmc_port_spin.value = settings.vmc_port
	vmc_receive_port_spin.value = settings.vmc_receive_port

func save_ui_to_settings():
	settings.show_model = show_model_check.button_pressed
	settings.show_webcam = show_webcam_check.button_pressed
	settings.track_face = track_face_check.button_pressed
	settings.track_pose = track_pose_check.button_pressed
	settings.track_hands = track_hands_check.button_pressed
	settings.vmc_enabled = vmc_enabled_check.button_pressed
	settings.vmc_port = int(vmc_port_spin.value)
	settings.vmc_receive_port = int(vmc_receive_port_spin.value)
	
	# Update language
	if language_option.selected >= 0:
		var lang_code = language_option.get_item_text(language_option.selected)
		settings.set_language(lang_code)

func _on_save_pressed():
	save_ui_to_settings()
	settings.save_settings()
	hide()

func _on_cancel_pressed():
	load_ui_from_settings()
	hide()

func _on_reset_pressed():
	settings.reset_to_defaults()
	load_ui_from_settings()

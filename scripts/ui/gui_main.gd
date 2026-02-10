extends CanvasLayer
## Main GUI controller

@onready var main_ui = $MainUI
@onready var visualization_canvas = $VisualizationCanvas

var file_dialog: FileDialog = null

func _ready():
	print("Initializing GUI...")
	setup_ui()

func setup_ui():
	# Setup buttons
	var load_model_btn = main_ui.get_node("TopBar/HBoxContainer/LoadModelButton")
	var settings_btn = main_ui.get_node("TopBar/HBoxContainer/SettingsButton")
	var background_btn = main_ui.get_node("TopBar/HBoxContainer/BackgroundButton")
	
	load_model_btn.pressed.connect(_on_load_model_pressed)
	settings_btn.pressed.connect(_on_settings_pressed)
	background_btn.pressed.connect(_on_background_pressed)
	
	# Create file dialog
	create_file_dialog()

func create_file_dialog():
	file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	add_child(file_dialog)

func _on_load_model_pressed():
	print("Load VRM model button pressed")
	if file_dialog:
		file_dialog.clear_filters()
		file_dialog.add_filter("*.vrm", "VRM Models")
		file_dialog.file_selected.connect(_on_vrm_file_selected)
		file_dialog.popup_centered_ratio(0.7)

func _on_vrm_file_selected(path: String):
	print("VRM file selected: ", path)
	# Call the main scene to load the model
	get_parent().load_vrm_model(path)
	file_dialog.file_selected.disconnect(_on_vrm_file_selected)

func _on_settings_pressed():
	print("Settings button pressed")
	# TODO: Open settings panel

func _on_background_pressed():
	print("Background button pressed")
	if file_dialog:
		file_dialog.clear_filters()
		file_dialog.add_filter("*.png,*.jpg,*.jpeg", "Images")
		file_dialog.file_selected.connect(_on_background_file_selected)
		file_dialog.popup_centered_ratio(0.7)

func _on_background_file_selected(path: String):
	print("Background image selected: ", path)
	# TODO: Load and set background image
	file_dialog.file_selected.disconnect(_on_background_file_selected)

extends Node
## Localization system for VRig
## Loads and manages language translations

class_name Localization

# Translation data
var translations := {}
var current_language := "en_US"
var available_languages := []

# Signals
signal language_loaded(language: String)

const LANG_DIR = "res://assets/lang/"

func _ready():
	load_available_languages()
	load_language(current_language)

func load_available_languages():
	# Load languages.json to get available languages
	var lang_file_path = LANG_DIR + "languages.json"
	
	if not FileAccess.file_exists(lang_file_path):
		push_error("languages.json not found at: " + lang_file_path)
		return
	
	var file = FileAccess.open(lang_file_path, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		file.close()
		
		var json = JSON.new()
		var error = json.parse(json_text)
		
		if error == OK:
			var data = json.data
			if data is Dictionary and "languages" in data:
				available_languages = data["languages"]
				print("Available languages: ", available_languages)
		else:
			push_error("Failed to parse languages.json: " + str(error))

func load_language(lang_code: String) -> bool:
	var lang_file_path = LANG_DIR + lang_code + "/" + lang_code + ".lang"
	
	if not FileAccess.file_exists(lang_file_path):
		push_error("Language file not found: " + lang_file_path)
		return false
	
	var file = FileAccess.open(lang_file_path, FileAccess.READ)
	if not file:
		push_error("Failed to open language file: " + lang_file_path)
		return false
	
	translations.clear()
	current_language = lang_code
	
	# Parse .lang file (key=value format)
	while not file.eof_reached():
		var line = file.get_line().strip_edges()
		
		# Skip empty lines and comments
		if line.is_empty() or line.begins_with("#") or line.begins_with("//"):
			continue
		
		# Parse key=value
		var parts = line.split("=", true, 1)
		if parts.size() == 2:
			var key = parts[0].strip_edges()
			var value = parts[1].strip_edges()
			translations[key] = value
	
	file.close()
	print("Loaded language: ", lang_code, " (", translations.size(), " translations)")
	emit_signal("language_loaded", lang_code)
	return true

func get_text(key: String, default: String = "") -> String:
	if key in translations:
		return translations[key]
	
	# Return default or key if not found
	if not default.is_empty():
		return default
	return key

func tr(key: String, default: String = "") -> String:
	return get_text(key, default)

func set_language(lang_code: String) -> bool:
	if lang_code == current_language:
		return true
	
	return load_language(lang_code)

func get_current_language() -> String:
	return current_language

func get_available_languages() -> Array:
	return available_languages

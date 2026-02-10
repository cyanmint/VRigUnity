extends Node
## Debug logging utility for VRig
## Provides comprehensive error logging with file output

# Log levels
enum LogLevel {
	DEBUG,
	INFO,
	WARNING,
	ERROR,
	CRITICAL
}

# Configuration
var log_to_file := true
var log_to_console := true
var log_level := LogLevel.DEBUG
var log_file_path := "user://vrig_debug.log"
var log_file: FileAccess = null
var max_log_size := 10 * 1024 * 1024  # 10MB

func _ready():
	# Open log file
	if log_to_file:
		_open_log_file()
		log_info("Debug Logger", "Debug logging initialized")
		log_info("Debug Logger", "Log file: " + ProjectSettings.globalize_path(log_file_path))

func _open_log_file():
	# Check if log file exists and size
	if FileAccess.file_exists(log_file_path):
		var size = FileAccess.get_file_as_bytes(log_file_path).size()
		if size > max_log_size:
			# Rotate log file
			var backup_path = log_file_path + ".old"
			if FileAccess.file_exists(backup_path):
				DirAccess.remove_absolute(backup_path)
			DirAccess.rename_absolute(log_file_path, backup_path)
	
	# Open for writing (append mode)
	log_file = FileAccess.open(log_file_path, FileAccess.WRITE)
	if log_file:
		log_file.store_string("\n=== VRig Debug Log ===\n")
		log_file.store_string("Started: " + Time.get_datetime_string_from_system() + "\n")
		log_file.store_string("Godot Version: " + Engine.get_version_info().string + "\n\n")
	else:
		push_error("Failed to open log file: " + log_file_path)

func _exit_tree():
	if log_file:
		log_file.store_string("\n=== Log Closed ===\n")
		log_file.close()

func log_debug(source: String, message: String):
	_log(LogLevel.DEBUG, source, message)

func log_info(source: String, message: String):
	_log(LogLevel.INFO, source, message)

func log_warning(source: String, message: String):
	_log(LogLevel.WARNING, source, message)

func log_error(source: String, message: String, error_details: String = ""):
	var full_message = message
	if error_details != "":
		full_message += " | Details: " + error_details
	_log(LogLevel.ERROR, source, full_message)

func log_critical(source: String, message: String, error_details: String = ""):
	var full_message = message
	if error_details != "":
		full_message += " | Details: " + error_details
	_log(LogLevel.CRITICAL, source, full_message)

func log_exception(source: String, message: String, exception):
	var error_text = message + " | Exception: " + str(exception)
	_log(LogLevel.ERROR, source, error_text)

func _log(level: LogLevel, source: String, message: String):
	if level < log_level:
		return
	
	var timestamp = Time.get_ticks_msec()
	var time_str = Time.get_time_string_from_system()
	var level_str = _get_level_string(level)
	var log_line = "[%s] [%s] [%s] %s" % [time_str, level_str, source, message]
	
	# Console output
	if log_to_console:
		match level:
			LogLevel.DEBUG, LogLevel.INFO:
				print(log_line)
			LogLevel.WARNING:
				push_warning(log_line)
			LogLevel.ERROR, LogLevel.CRITICAL:
				push_error(log_line)
	
	# File output
	if log_to_file and log_file:
		log_file.store_line(log_line)
		log_file.flush()  # Ensure it's written immediately

func _get_level_string(level: LogLevel) -> String:
	match level:
		LogLevel.DEBUG: return "DEBUG"
		LogLevel.INFO: return "INFO"
		LogLevel.WARNING: return "WARN"
		LogLevel.ERROR: return "ERROR"
		LogLevel.CRITICAL: return "CRITICAL"
		_: return "UNKNOWN"

func get_log_file_path() -> String:
	return ProjectSettings.globalize_path(log_file_path)

func clear_log():
	if log_file:
		log_file.close()
	if FileAccess.file_exists(log_file_path):
		DirAccess.remove_absolute(log_file_path)
	_open_log_file()

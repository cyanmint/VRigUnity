extends Node
## Test script to verify debug logging functionality

func _ready():
	print("=== Debug Logger Test ===\n")
	
	# Test different log levels
	DebugLogger.log_debug("Test", "This is a debug message")
	DebugLogger.log_info("Test", "This is an info message")
	DebugLogger.log_warning("Test", "This is a warning message")
	DebugLogger.log_error("Test", "This is an error message")
	DebugLogger.log_critical("Test", "This is a critical message")
	
	# Test error with details
	DebugLogger.log_error("Test", "Error with details", "Additional error information")
	
	# Show log file location
	print("\nLog file location: " + DebugLogger.get_log_file_path())
	print("\n=== Test Complete ===")
	
	# Read and display log file
	await get_tree().create_timer(0.5).timeout
	display_log_file()
	
	# Quit
	get_tree().quit()

func display_log_file():
	var log_path = DebugLogger.get_log_file_path()
	if FileAccess.file_exists(log_path):
		var file = FileAccess.open(log_path, FileAccess.READ)
		if file:
			print("\n=== Log File Contents ===")
			print(file.get_as_text())
			file.close()
		else:
			print("Could not open log file for reading")
	else:
		print("Log file not found at: " + log_path)

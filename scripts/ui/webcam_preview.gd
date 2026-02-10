extends TextureRect
## WebcamPreview - Displays webcam feed in UI

var camera_manager: CameraManager = null

func _ready():
	# Create camera manager
	camera_manager = CameraManager.new()
	add_child(camera_manager)
	
	# Connect signals
	camera_manager.camera_started.connect(_on_camera_started)
	camera_manager.camera_stopped.connect(_on_camera_stopped)
	
	# Try to start camera
	start_preview()

func start_preview():
	var cameras = camera_manager.get_available_cameras()
	if cameras.size() > 0:
		print("Starting webcam preview...")
		if camera_manager.start_camera(0):
			# Set the camera texture
			texture = camera_manager.get_camera_texture()
		else:
			push_error("Failed to start camera")
	else:
		push_warning("No cameras found")

func stop_preview():
	camera_manager.stop_camera()
	texture = null

func _on_camera_started():
	print("Webcam preview started")

func _on_camera_stopped():
	print("Webcam preview stopped")

func _exit_tree():
	if camera_manager:
		camera_manager.stop_camera()

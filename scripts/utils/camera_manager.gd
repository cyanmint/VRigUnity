extends Node
## Camera Manager - Handles webcam access and image capture

class_name CameraManager

# Camera device
var camera_device_id := 0
var camera_texture: CameraTexture = null
var camera_feed: CameraFeed = null

# Camera settings
var resolution := Vector2(640, 480)
var fps := 30

# Signals
signal camera_started
signal camera_stopped
signal frame_captured(image: Image)

func _ready():
	print("CameraManager initialized")

func get_available_cameras() -> Array:
	var cameras = []
	var server = CameraServer
	
	for i in range(server.get_feed_count()):
		var feed = server.get_feed(i)
		if feed:
			cameras.append({
				"id": i,
				"name": feed.get_name()
			})
	
	print("Found ", cameras.size(), " camera(s)")
	return cameras

func start_camera(device_id: int = 0) -> bool:
	camera_device_id = device_id
	
	# Get camera server
	var server = CameraServer
	
	# Check if we have any feeds
	if server.get_feed_count() == 0:
		push_error("No camera feeds available")
		return false
	
	# Get the specified feed
	if device_id >= server.get_feed_count():
		push_error("Camera device ID out of range: " + str(device_id))
		return false
	
	camera_feed = server.get_feed(device_id)
	if not camera_feed:
		push_error("Failed to get camera feed")
		return false
	
	# Create camera texture
	camera_texture = CameraTexture.new()
	camera_texture.camera_feed_id = camera_feed.get_id()
	
	# Start the feed
	camera_feed.set_active(true)
	
	print("Camera started: ", camera_feed.get_name())
	emit_signal("camera_started")
	return true

func stop_camera():
	if camera_feed:
		camera_feed.set_active(false)
		print("Camera stopped")
		emit_signal("camera_stopped")
	
	if camera_texture:
		camera_texture = null

func get_camera_texture() -> CameraTexture:
	return camera_texture

func get_camera_image() -> Image:
	if not camera_texture:
		return null
	
	# Get the image from the camera texture
	var img = camera_texture.get_image()
	return img

func is_camera_active() -> bool:
	return camera_feed != null and camera_feed.is_active()

func _process(_delta):
	# Emit frame updates if needed
	if is_camera_active():
		var img = get_camera_image()
		if img:
			emit_signal("frame_captured", img)

func _exit_tree():
	stop_camera()

extends Node
## Holistic tracking solution using GDMP (MediaPipe for Godot)
## This replaces the Unity MediaPipeUnityPlugin

# Tracking data container class
class HolisticLandmarks:
	var pose_landmarks: Array = []
	var face_landmarks: Array = []
	var left_hand_landmarks: Array = []
	var right_hand_landmarks: Array = []
	var face_blendshapes: Array = []

# Signals for tracking updates
signal landmarks_updated(landmarks: HolisticLandmarks)
signal tracking_started
signal tracking_stopped

# Configuration
var track_pose := true
var track_face := true
var track_left_hand := true
var track_right_hand := true

# GDMP availability check
var gdmp_available := false

# GDMP/MediaPipe variables
var task_runner = null  # MediaPipeTaskRunner when GDMP is available
var camera_texture: CameraTexture = null
var camera_feed: CameraFeed = null
var is_tracking := false
var timestamp_ms := 0

# Model file path (needs to be downloaded separately)
const HOLISTIC_MODEL_PATH = "res://addons/GDMP/models/holistic_landmarker.task"
# Alternative paths for exported builds
const HOLISTIC_MODEL_PATHS = [
	"res://addons/GDMP/models/holistic_landmarker.task",
	"user://models/holistic_landmarker.task",
	"res://models/holistic_landmarker.task"
]

func get_model_path() -> String:
	"""Find the holistic model file in various locations"""
	for path in HOLISTIC_MODEL_PATHS:
		if FileAccess.file_exists(path):
			if DebugLogger:
				DebugLogger.log_debug("HolisticSolution", "Found model file at: " + path)
			return path
	
	# Check in user data directory (for manual installation)
	var user_path = "user://holistic_landmarker.task"
	if FileAccess.file_exists(user_path):
		if DebugLogger:
			DebugLogger.log_debug("HolisticSolution", "Found model file in user directory")
		return user_path
	
	return ""

func _ready():
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Initializing Holistic Solution...")
	
	# Check if GDMP classes are available
	gdmp_available = ClassDB.class_exists("MediaPipeTaskRunner")
	if gdmp_available:
		if DebugLogger:
			DebugLogger.log_info("HolisticSolution", "GDMP extension loaded successfully")
		setup_mediapipe()
	else:
		if DebugLogger:
			DebugLogger.log_warning("HolisticSolution", "GDMP extension not available - MediaPipe tracking disabled")
			DebugLogger.log_warning("HolisticSolution", "This is expected in headless mode or when GDMP native libraries are missing")
		push_warning("GDMP not available - tracking disabled")

func setup_mediapipe():
	if not gdmp_available:
		return
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Setting up MediaPipe Holistic tracking...")
	
	# Check if model file exists
	var model_path = get_model_path()
	if model_path == "":
		var warning_msg = "Holistic model file not found in any of these locations:"
		if DebugLogger:
			DebugLogger.log_warning("HolisticSolution", warning_msg)
			for path in HOLISTIC_MODEL_PATHS:
				DebugLogger.log_warning("HolisticSolution", "  - " + path)
			DebugLogger.log_warning("HolisticSolution", "Please download holistic_landmarker.task from:")
			DebugLogger.log_warning("HolisticSolution", "  https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task")
			DebugLogger.log_warning("HolisticSolution", "And place it in: " + str(OS.get_user_data_dir()))
		push_warning(warning_msg)
		# Don't return - still try to initialize camera for preview
	
	# Initialize camera first
	var camera_ok = await setup_camera()
	if not camera_ok:
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", "Failed to initialize camera")
		return
	
	# Create holistic tracking graph if model is available
	if model_path != "":
		create_holistic_graph(model_path)
	else:
		if DebugLogger:
			DebugLogger.log_warning("HolisticSolution", "Skipping MediaPipe graph creation - model file not found")

func setup_camera() -> bool:
	if DebugLogger:
		DebugLogger.log_debug("HolisticSolution", "Setting up webcam...")
	
	# Get camera server
	var server = CameraServer
	
	# On some platforms (especially Windows), cameras need to be added manually
	# Try to add cameras if none are present
	if server.get_feed_count() == 0:
		if DebugLogger:
			DebugLogger.log_debug("HolisticSolution", "No camera feeds detected, attempting to add default cameras...")
		
		# Try to add cameras by index (0-9)
		for i in range(10):
			var feed_name = "Camera " + str(i)
			var feed = server.add_feed(feed_name, CameraServer.FEED_RGBA_IMAGE, Transform2D())
			if feed:
				if DebugLogger:
					DebugLogger.log_info("HolisticSolution", "Added camera feed: " + feed_name)
				break  # Successfully added at least one feed
		
		# Check again after trying to add
		if server.get_feed_count() == 0:
			if DebugLogger:
				DebugLogger.log_error("HolisticSolution", "No camera feeds available even after attempting to add")
				DebugLogger.log_error("HolisticSolution", "Please ensure a webcam is connected and accessible")
			push_error("No camera feeds available - please connect a webcam")
			return false
	
	# Get the first available feed
	camera_feed = server.get_feed(0)
	if not camera_feed:
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", "Failed to get camera feed 0")
		push_error("Failed to get camera feed")
		return false
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Using camera feed: " + camera_feed.get_name())
	
	# Create camera texture
	camera_texture = CameraTexture.new()
	camera_texture.camera_feed_id = camera_feed.get_id()
	camera_texture.camera_is_active = true
	
	# Activate the feed
	if not camera_feed.is_active():
		camera_feed.set_active(true)
		if DebugLogger:
			DebugLogger.log_debug("HolisticSolution", "Activated camera feed")
	
	# Wait a moment for camera to initialize
	await get_tree().create_timer(0.5).timeout
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Camera initialized successfully: " + camera_feed.get_name())
	return true

func create_holistic_graph(model_path: String):
	if not gdmp_available:
		if DebugLogger:
			DebugLogger.log_warning("HolisticSolution", "Cannot create graph: GDMP not available")
		return
	
	if DebugLogger:
		DebugLogger.log_debug("HolisticSolution", "Creating Holistic graph...")
	
	# Check if model exists
	if not FileAccess.file_exists(model_path):
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", "Cannot create graph: model file not found at " + model_path)
		push_error("Cannot create graph: model file not found")
		return
	
	# Load model file
	var file = FileAccess.open(model_path, FileAccess.READ)
	if not file:
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", "Failed to open model file: " + model_path)
		push_error("Failed to open model file")
		return
	
	var file_buffer = file.get_buffer(file.get_length())
	file.close()
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Model file loaded from: " + model_path)
		DebugLogger.log_debug("HolisticSolution", "Model file size: " + str(file_buffer.size()) + " bytes")
	
	# Create MediaPipe graph using GDMP
	var package_name = "mediapipe.tasks.vision.holistic_landmarker"
	
	# Initialize options
	var MediaPipeProto = ClassDB.instantiate("MediaPipeProto")
	var options = MediaPipeProto.new()
	options.initialize(package_name + ".proto.HolisticLandmarkerGraphOptions")
	options.set_field("base_options/model_asset/file_content", file_buffer)
	
	# Build graph
	var MediaPipeGraphBuilder = ClassDB.instantiate("MediaPipeGraphBuilder")
	var builder = MediaPipeGraphBuilder.new()
	var node = builder.add_node(package_name + ".HolisticLandmarkerGraph")
	node.set_options(options)
	
	# Connect inputs
	builder.get_input_tag("IMAGE").connect_to(node.get_input_tag("IMAGE"), "image_in")
	
	# Connect outputs
	node.get_output_tag("POSE_LANDMARKS").connect_to(builder.get_output_tag("POSE_LANDMARKS"), "pose_landmarks")
	node.get_output_tag("LEFT_HAND_LANDMARKS").connect_to(builder.get_output_tag("LEFT_HAND_LANDMARKS"), "left_hand_landmarks")
	node.get_output_tag("RIGHT_HAND_LANDMARKS").connect_to(builder.get_output_tag("RIGHT_HAND_LANDMARKS"), "right_hand_landmarks")
	node.get_output_tag("FACE_LANDMARKS").connect_to(builder.get_output_tag("FACE_LANDMARKS"), "face_landmarks")
	node.get_output_tag("FACE_BLENDSHAPES").connect_to(builder.get_output_tag("FACE_BLENDSHAPES"), "face_blendshapes")
	
	# Get config and initialize task runner
	var config = builder.get_config()
	var MediaPipeTaskRunner = ClassDB.instantiate("MediaPipeTaskRunner")
	task_runner = MediaPipeTaskRunner.new()
	
	# Connect callback for async processing
	task_runner.packets_callback.connect(_on_packets_received)
	
	# Initialize as async (live stream mode)
	task_runner.initialize(config, true)
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Holistic graph created successfully")

func start_tracking():
	if not gdmp_available:
		if DebugLogger:
			DebugLogger.log_warning("HolisticSolution", "Cannot start tracking: GDMP not available")
		return
	
	if not task_runner:
		var err_msg = "Cannot start tracking: MediaPipe graph not initialized"
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", err_msg)
		push_error(err_msg)
		return
	
	if not camera_feed or not camera_feed.is_active():
		var err_msg = "Cannot start tracking: Camera not active"
		if DebugLogger:
			DebugLogger.log_error("HolisticSolution", err_msg)
		push_error(err_msg)
		return
	
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Starting holistic tracking...")
	is_tracking = true
	timestamp_ms = 0
	emit_signal("tracking_started")

func stop_tracking():
	if DebugLogger:
		DebugLogger.log_info("HolisticSolution", "Stopping holistic tracking...")
	is_tracking = false
	emit_signal("tracking_stopped")

func _process(_delta):
	if not gdmp_available or not is_tracking or not task_runner or not camera_texture:
		return
	
	# Get image from camera
	var image = camera_texture.get_image()
	if not image:
		return
	
	# Create MediaPipe image
	var MediaPipeImage = ClassDB.instantiate("MediaPipeImage")
	var mp_image = MediaPipeImage.new()
	mp_image.set_image(image)
	
	# Create packet with timestamp
	var packet = mp_image.get_packet()
	packet.timestamp = timestamp_ms * 1000  # Convert to microseconds
	
	# Send to MediaPipe for processing
	task_runner.send({"image_in": packet})
	
	# Increment timestamp
	timestamp_ms += int(_delta * 1000)

func _on_packets_received(outputs: Dictionary):
	# Create landmarks container
	var landmarks = HolisticLandmarks.new()
	
	# Extract pose landmarks
	if outputs.has("pose_landmarks") and track_pose:
		landmarks.pose_landmarks = extract_landmarks(outputs["pose_landmarks"])
	
	# Extract face landmarks
	if outputs.has("face_landmarks") and track_face:
		landmarks.face_landmarks = extract_landmarks(outputs["face_landmarks"])
	
	# Extract hand landmarks
	if outputs.has("left_hand_landmarks") and track_left_hand:
		landmarks.left_hand_landmarks = extract_landmarks(outputs["left_hand_landmarks"])
	
	if outputs.has("right_hand_landmarks") and track_right_hand:
		landmarks.right_hand_landmarks = extract_landmarks(outputs["right_hand_landmarks"])
	
	# Extract face blendshapes
	if outputs.has("face_blendshapes") and track_face:
		landmarks.face_blendshapes = extract_blendshapes(outputs["face_blendshapes"])
	
	# Emit signal with landmarks
	emit_signal("landmarks_updated", landmarks)

func extract_landmarks(packet) -> Array:  # Packet type when GDMP available
	var result = []
	
	# Get the landmark list from packet
	var landmark_list = packet.get()
	if not landmark_list:
		return result
	
	# Extract individual landmarks
	var landmarks = landmark_list.get_field("landmark")
	if not landmarks:
		return result
	
	for landmark in landmarks:
		var x = landmark.get_field("x")
		var y = landmark.get_field("y")
		var z = landmark.get_field("z")
		var visibility = landmark.get_field("visibility") if landmark.has_field("visibility") else 1.0
		
		result.append({
			"x": x,
			"y": y,
			"z": z,
			"visibility": visibility
		})
	
	return result

func extract_blendshapes(packet) -> Array:  # Packet type when GDMP available
	var result = []
	
	# Get classifications from packet
	var classifications_list = packet.get()
	if not classifications_list:
		return result
	
	var classifications = classifications_list.get_field("classification")
	if not classifications:
		return result
	
	for classification in classifications:
		var label = classification.get_field("label")
		var score = classification.get_field("score")
		
		result.append({
			"label": label,
			"score": score
		})
	
	return result

func _exit_tree():
	stop_tracking()
	
	# Clean up camera
	if camera_feed:
		camera_feed.set_active(false)
	
	# Clean up task runner
	if task_runner:
		task_runner.queue_free()

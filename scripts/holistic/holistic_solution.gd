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

# GDMP/MediaPipe variables
var task_runner: MediaPipeTaskRunner = null
var camera_texture: CameraTexture = null
var camera_feed: CameraFeed = null
var is_tracking := false
var timestamp_ms := 0

# Model file path (needs to be downloaded separately)
const HOLISTIC_MODEL_PATH = "res://addons/GDMP/models/holistic_landmarker.task"

func _ready():
	print("Initializing Holistic Solution...")
	setup_mediapipe()

func setup_mediapipe():
	print("Setting up MediaPipe Holistic tracking...")
	
	# Check if model file exists (user needs to download separately)
	if not FileAccess.file_exists(HOLISTIC_MODEL_PATH):
		push_warning("Holistic model file not found at: " + HOLISTIC_MODEL_PATH)
		push_warning("Please download the holistic_landmarker.task model from MediaPipe")
		# Continue anyway - will fail gracefully when trying to initialize
	
	# Initialize camera first
	if not setup_camera():
		push_error("Failed to initialize camera")
		return
	
	# Create holistic tracking graph
	create_holistic_graph()

func setup_camera() -> bool:
	print("Setting up webcam...")
	
	# Get camera server
	var server = CameraServer
	
	# Check if we have any feeds
	if server.get_feed_count() == 0:
		push_error("No camera feeds available")
		return false
	
	# Get the first available feed
	camera_feed = server.get_feed(0)
	if not camera_feed:
		push_error("Failed to get camera feed")
		return false
	
	# Create camera texture
	camera_texture = CameraTexture.new()
	camera_texture.camera_feed_id = camera_feed.get_id()
	
	# Start the feed
	camera_feed.set_active(true)
	
	print("Camera initialized: ", camera_feed.get_name())
	return true

func create_holistic_graph():
	print("Creating Holistic graph...")
	
	# Check if model exists
	if not FileAccess.file_exists(HOLISTIC_MODEL_PATH):
		push_error("Cannot create graph: model file not found")
		return
	
	# Load model file
	var file = FileAccess.open(HOLISTIC_MODEL_PATH, FileAccess.READ)
	if not file:
		push_error("Failed to open model file")
		return
	
	var file_buffer = file.get_buffer(file.get_length())
	file.close()
	
	# Create MediaPipe graph using GDMP
	var package_name = "mediapipe.tasks.vision.holistic_landmarker"
	
	# Initialize options
	var options = MediaPipeProto.new()
	options.initialize(package_name + ".proto.HolisticLandmarkerGraphOptions")
	options.set_field("base_options/model_asset/file_content", file_buffer)
	
	# Build graph
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
	task_runner = MediaPipeTaskRunner.new()
	
	# Connect callback for async processing
	task_runner.packets_callback.connect(_on_packets_received)
	
	# Initialize as async (live stream mode)
	task_runner.initialize(config, true)
	
	print("Holistic graph created successfully")

func start_tracking():
	if not task_runner:
		push_error("Cannot start tracking: MediaPipe graph not initialized")
		return
	
	if not camera_feed or not camera_feed.is_active():
		push_error("Cannot start tracking: Camera not active")
		return
	
	print("Starting holistic tracking...")
	is_tracking = true
	timestamp_ms = 0
	emit_signal("tracking_started")

func stop_tracking():
	print("Stopping holistic tracking...")
	is_tracking = false
	emit_signal("tracking_stopped")

func _process(_delta):
	if not is_tracking or not task_runner or not camera_texture:
		return
	
	# Get image from camera
	var image = camera_texture.get_image()
	if not image:
		return
	
	# Create MediaPipe image
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

func extract_landmarks(packet: MediaPipePacket) -> Array:
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

func extract_blendshapes(packet: MediaPipePacket) -> Array:
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

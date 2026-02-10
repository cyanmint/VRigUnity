extends Node3D
## Main controller for the VRig application

@onready var holistic_solution = $HolisticSolution
@onready var camera = $Camera3D
@onready var vrm_container = $VRMModelContainer
@ontml:parameter name="gui = $GUI

var scene_model: SceneModel = null
var is_panning := false
var is_rotating := false
var last_mouse_position := Vector2.ZERO

func _ready():
	print("VRig Godot Edition Starting...")
	setup_camera_controls()
	setup_scene_model()
	setup_tracking()

func setup_tracking():
	# Connect holistic tracking to model animation
	if holistic_solution:
		holistic_solution.landmarks_updated.connect(_on_landmarks_updated)
		print("Tracking system connected")

func _on_landmarks_updated(landmarks):
	# Apply tracking to model if loaded
	if not scene_model or not scene_model.is_model_loaded():
		return
	
	# Apply pose tracking
	if landmarks.pose_landmarks.size() > 0:
		var PoseResolver = load("res://scripts/scene_model/pose_resolver.gd")
		PoseResolver.apply_pose_to_model(landmarks.pose_landmarks, scene_model)
	
	# Apply face tracking (prefer blendshapes)
	var FaceResolver = load("res://scripts/scene_model/face_resolver.gd")
	if landmarks.face_blendshapes.size() > 0:
		FaceResolver.apply_face_to_model(landmarks.face_blendshapes, scene_model)
	elif landmarks.face_landmarks.size() > 0:
		FaceResolver.apply_face_landmarks_to_model(landmarks.face_landmarks, scene_model)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				last_mouse_position = event.position
				if Input.is_key_pressed(KEY_SHIFT):
					is_panning = true
				elif Input.is_key_pressed(KEY_CTRL):
					is_rotating = true
			else:
				is_panning = false
				is_rotating = false
	
	elif event is InputEventMouseMotion and (is_panning or is_rotating):
		var delta_mouse = event.position - last_mouse_position
		last_mouse_position = event.position
		
		if is_panning:
			var pan_speed = 0.01
			camera.position.x -= delta_mouse.x * pan_speed
			camera.position.y += delta_mouse.y * pan_speed
		elif is_rotating:
			var rotate_speed = 0.005
			camera.rotate_y(-delta_mouse.x * rotate_speed)
			camera.position.y += delta_mouse.y * rotate_speed
	
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		camera.position.z = max(camera.position.z - 0.5, 1.0)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		camera.position.z = min(camera.position.z + 0.5, 10.0)

func setup_camera_controls():
	camera.position = Vector3(0, 1, 3)
	camera.look_at(Vector3(0, 1, 0), Vector3.UP)

func setup_scene_model():
	var SceneModelClass = load("res://scripts/scene_model/scene_model.gd")
	scene_model = SceneModelClass.new()
	vrm_container.add_child(scene_model)
	scene_model.model_loaded.connect(_on_model_loaded)
	scene_model.model_unloaded.connect(_on_model_unloaded)
	print("Scene model initialized")

func _on_model_loaded(model: Node3D):
	print("Model loaded successfully: ", model.name)
	# Start tracking when model is loaded
	if holistic_solution:
		holistic_solution.start_tracking()

func _on_model_unloaded():
	print("Model unloaded")
	if holistic_solution:
		holistic_solution.stop_tracking()

func load_vrm_model(path: String):
	print("Main: Loading VRM model from: ", path)
	if scene_model:
		scene_model.load_vrm_model(path)
	else:
		push_error("Scene model not initialized")

func _process(_delta):
	pass

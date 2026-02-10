extends Node
## SceneModel - Manages VRM model loading and animation
## This replaces Unity's VRMBlendShapeProxy and VRMAnimator

class_name SceneModel

# VRM model references
var vrm_model: Node3D = null
var skeleton: Skeleton3D = null
var animation_player: AnimationPlayer = null

# Bone cache for faster access
var bone_cache: Dictionary = {}

# Blend shape cache
var blend_shape_cache: Dictionary = {}

# Model visibility
var is_visible := true:
	set(value):
		is_visible = value
		if vrm_model:
			vrm_model.visible = value

# Signals
signal model_loaded(model: Node3D)
signal model_unloaded

func _ready():
	print("SceneModel initialized")

func load_vrm_model(path: String) -> bool:
	print("Loading VRM model from: ", path)
	
	# Unload existing model first
	if vrm_model:
		unload_model()
	
	# Load VRM using GLTFDocument with VRM extension (godot-vrm addon)
	if not FileAccess.file_exists(path):
		push_error("VRM file not found: " + path)
		return false
	
	# Load the VRM extension from the addon
	var vrm_extension_script = load("res://addons/vrm/vrm_extension.gd")
	if not vrm_extension_script:
		push_error("VRM extension not found. Is the godot-vrm addon installed?")
		return false
	
	# Create GLTF document and register VRM extension
	var gltf = GLTFDocument.new()
	var vrm_extension = vrm_extension_script.new()
	gltf.register_gltf_document_extension(vrm_extension, true)
	
	# Create GLTF state
	var state = GLTFState.new()
	state.handle_binary_image = GLTFState.HANDLE_BINARY_EMBED_AS_UNCOMPRESSED
	
	# Load the VRM file
	var err = gltf.append_from_file(path, state)
	if err != OK:
		push_error("Failed to load VRM file: " + str(err))
		gltf.unregister_gltf_document_extension(vrm_extension)
		return false
	
	# Generate the scene from GLTF
	vrm_model = gltf.generate_scene(state)
	gltf.unregister_gltf_document_extension(vrm_extension)
	
	if vrm_model:
		# Add to scene tree (assume we have a parent container)
		var container = get_parent()
		if container:
			container.add_child(vrm_model)
		
		setup_model()
		emit_signal("model_loaded", vrm_model)
		print("VRM model loaded successfully")
		return true
	else:
		push_error("Failed to generate scene from VRM file")
		return false

func setup_model():
	if not vrm_model:
		return
	
	# Find skeleton
	skeleton = find_skeleton(vrm_model)
	if skeleton:
		cache_bones()
	
	# Find animation player
	animation_player = find_animation_player(vrm_model)
	
	# Cache blend shapes
	cache_blend_shapes()
	
	print("Model setup complete")

func find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var result = find_skeleton(child)
		if result:
			return result
	return null

func find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var result = find_animation_player(child)
		if result:
			return result
	return null

func cache_bones():
	if not skeleton:
		return
	
	bone_cache.clear()
	for i in range(skeleton.get_bone_count()):
		var bone_name = skeleton.get_bone_name(i)
		bone_cache[bone_name] = i

func cache_blend_shapes():
	blend_shape_cache.clear()
	
	if not vrm_model:
		return
	
	# Find all MeshInstance3D nodes with blend shapes (morph targets)
	find_blend_shapes_recursive(vrm_model)
	
	print("Cached ", blend_shape_cache.size(), " blend shapes")

func find_blend_shapes_recursive(node: Node):
	## Recursively find all mesh instances with blend shapes
	if node is MeshInstance3D:
		var mesh_instance = node as MeshInstance3D
		if mesh_instance.mesh:
			# Get blend shape count
			var blend_shape_count = mesh_instance.mesh.get_blend_shape_count()
			for i in range(blend_shape_count):
				var blend_name = mesh_instance.mesh.get_blend_shape_name(i)
				# Store the mesh instance and blend shape index
				if not blend_shape_cache.has(blend_name):
					blend_shape_cache[blend_name] = []
				blend_shape_cache[blend_name].append({
					"mesh": mesh_instance,
					"index": i
				})
	
	# Recurse through children
	for child in node.get_children():
		find_blend_shapes_recursive(child)

func get_bone_transform(bone_name: String) -> Transform3D:
	if skeleton and bone_name in bone_cache:
		var bone_idx = bone_cache[bone_name]
		return skeleton.get_bone_global_pose(bone_idx)
	return Transform3D.IDENTITY

func set_bone_transform(bone_name: String, transform: Transform3D):
	if skeleton and bone_name in bone_cache:
		var bone_idx = bone_cache[bone_name]
		skeleton.set_bone_global_pose_override(bone_idx, transform, 1.0, true)

func set_blend_shape(shape_name: String, value: float):
	## Set blend shape value (0.0 to 1.0)
	if shape_name in blend_shape_cache:
		var shape_list = blend_shape_cache[shape_name]
		for shape_data in shape_list:
			var mesh: MeshInstance3D = shape_data["mesh"]
			var index: int = shape_data["index"]
			# Blend shapes in Godot use set() method
			mesh.set("blend_shapes/" + shape_name, value)

func get_blend_shape(shape_name: String) -> float:
	## Get blend shape value
	if shape_name in blend_shape_cache:
		var shape_list = blend_shape_cache[shape_name]
		if shape_list.size() > 0:
			var shape_data = shape_list[0]
			var mesh: MeshInstance3D = shape_data["mesh"]
			# Get blend shape value
			return mesh.get("blend_shapes/" + shape_name)
	return 0.0

func unload_model():
	if vrm_model:
		vrm_model.queue_free()
		vrm_model = null
		skeleton = null
		animation_player = null
		bone_cache.clear()
		blend_shape_cache.clear()
		emit_signal("model_unloaded")

func is_model_loaded() -> bool:
	return vrm_model != null

func _exit_tree():
	unload_model()

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
	
	# Check if godot-vrm addon is available
	# The godot-vrm addon should provide VRM loading functionality
	
	# Unload existing model first
	if vrm_model:
		unload_model()
	
	# TODO: Load VRM using godot-vrm addon
	# This is a placeholder - actual implementation depends on godot-vrm API
	
	# Example (needs adjustment based on actual godot-vrm API):
	# var vrm_loader = VRMLoader.new() # From godot-vrm addon
	# vrm_model = vrm_loader.load_vrm(path)
	
	if vrm_model:
		setup_model()
		emit_signal("model_loaded", vrm_model)
		return true
	else:
		push_error("Failed to load VRM model from: " + path)
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
	# TODO: Cache blend shapes from VRM model
	# This depends on how godot-vrm exposes blend shapes

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
	# TODO: Set blend shape value
	# This depends on how godot-vrm handles blend shapes
	pass

func get_blend_shape(shape_name: String) -> float:
	# TODO: Get blend shape value
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

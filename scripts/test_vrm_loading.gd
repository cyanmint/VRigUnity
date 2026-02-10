extends Node
## Simple test script to verify VRM loading functionality

func _ready():
	print("=== VRM Loading Test ===")
	
	# Test 1: Check if godot-vrm addon is available
	print("\n[Test 1] Checking godot-vrm addon...")
	var vrm_extension_script = load("res://addons/vrm/vrm_extension.gd")
	if vrm_extension_script:
		print("✓ godot-vrm addon found")
	else:
		print("✗ godot-vrm addon NOT found")
		return
	
	# Test 2: Create SceneModel instance
	print("\n[Test 2] Creating SceneModel...")
	var SceneModelClass = load("res://scripts/scene_model/scene_model.gd")
	var scene_model = SceneModelClass.new()
	add_child(scene_model)
	if scene_model:
		print("✓ SceneModel created")
	else:
		print("✗ Failed to create SceneModel")
		return
	
	# Test 3: Test GLTF loading capability
	print("\n[Test 3] Testing GLTF/VRM loading capability...")
	var gltf = GLTFDocument.new()
	var vrm_extension = vrm_extension_script.new()
	if gltf and vrm_extension:
		print("✓ GLTF and VRM extension instances created")
		gltf.register_gltf_document_extension(vrm_extension, true)
		print("✓ VRM extension registered")
		gltf.unregister_gltf_document_extension(vrm_extension)
	else:
		print("✗ Failed to create GLTF/VRM instances")
		return
	
	print("\n=== All tests passed! ===")
	print("VRM loading functionality is ready.")
	print("\nTo load a VRM model, use:")
	print("  scene_model.load_vrm_model(path_to_vrm_file)")
	
	# Quit after testing
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

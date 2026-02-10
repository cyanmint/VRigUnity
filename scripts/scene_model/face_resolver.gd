extends Node
## FaceResolver - Converts MediaPipe face landmarks to VRM blend shapes

class_name FaceResolver

# Common VRM blend shape names
enum VRMBlendShape {
	NEUTRAL,
	A,
	I,
	U,
	E,
	O,
	BLINK,
	BLINK_L,
	BLINK_R,
	ANGRY,
	FUN,
	JOY,
	SORROW,
	SURPRISED,
	LOOKUP,
	LOOKDOWN,
	LOOKLEFT,
	LOOKRIGHT
}

static func apply_face_to_model(blendshapes: Array, scene_model: SceneModel):
	## Apply MediaPipe face blendshapes to VRM model
	## blendshapes: Array of {label: String, score: float} from MediaPipe
	
	if blendshapes.is_empty() or not scene_model.is_model_loaded():
		return
	
	# MediaPipe provides 52 ARKit-compatible blendshapes
	# Map them to VRM blend shapes
	for blendshape in blendshapes:
		var label = blendshape.get("label", "")
		var score = blendshape.get("score", 0.0)
		
		# Only apply if score is significant
		if score < 0.01:
			continue
		
		# Map MediaPipe blendshapes to VRM
		match label:
			# Eye blinks
			"eyeBlinkLeft":
				scene_model.set_blend_shape("Blink_L", score)
			"eyeBlinkRight":
				scene_model.set_blend_shape("Blink_R", score)
			
			# Eye look directions
			"eyeLookUpLeft", "eyeLookUpRight":
				scene_model.set_blend_shape("LookUp", score)
			"eyeLookDownLeft", "eyeLookDownRight":
				scene_model.set_blend_shape("LookDown", score)
			"eyeLookInLeft", "eyeLookOutRight":
				scene_model.set_blend_shape("LookLeft", score)
			"eyeLookOutLeft", "eyeLookInRight":
				scene_model.set_blend_shape("LookRight", score)
			
			# Jaw/mouth - map to vowel shapes
			"jawOpen":
				scene_model.set_blend_shape("A", score)  # Open mouth
			"mouthClose":
				scene_model.set_blend_shape("I", score)  # Closed/narrow
			"mouthFunnel":
				scene_model.set_blend_shape("O", score)  # Round mouth
			"mouthSmileLeft", "mouthSmileRight":
				scene_model.set_blend_shape("Joy", score)  # Smile
			"mouthFrownLeft", "mouthFrownRight":
				scene_model.set_blend_shape("Sorrow", score)  # Frown
			
			# Eyebrows
			"browInnerUp":
				scene_model.set_blend_shape("Surprised", score)
			"browDownLeft", "browDownRight":
				scene_model.set_blend_shape("Angry", score)
			
			# Additional mappings can be added based on VRM model capabilities
			_:
				# Try direct mapping if VRM has matching blend shape
				var vrm_name = label.capitalize().replace(" ", "")
				scene_model.set_blend_shape(vrm_name, score)

static func apply_face_landmarks_to_model(landmarks: Array, scene_model: SceneModel):
	## Fallback: Apply face using landmarks if blendshapes not available
	## This uses geometric calculations instead of direct blendshapes
	
	if landmarks.is_empty() or not scene_model.is_model_loaded():
		return
	
	# Apply eye blink using geometric calculation
	apply_eye_blink_from_landmarks(landmarks, scene_model)
	
	# Apply mouth shape using geometric calculation
	apply_mouth_shape_from_landmarks(landmarks, scene_model)

static func apply_eye_blink_from_landmarks(landmarks: Array, scene_model: SceneModel):
	# Calculate eye openness from face landmark positions
	# MediaPipe face mesh indices for eyes:
	# Left eye: 33, 160, 158, 133, 153, 144
	# Right eye: 362, 385, 387, 263, 373, 380
	
	var left_eye_open = calculate_eye_aspect_ratio(landmarks, [33, 160, 158, 133, 153, 144])
	var right_eye_open = calculate_eye_aspect_ratio(landmarks, [362, 385, 387, 263, 373, 380])
	
	# Normalize to 0-1 range (typical EAR is 0.2-0.3 when open)
	var left_blink = clamp(1.0 - (left_eye_open / 0.25), 0.0, 1.0)
	var right_blink = clamp(1.0 - (right_eye_open / 0.25), 0.0, 1.0)
	
	scene_model.set_blend_shape("Blink_L", left_blink)
	scene_model.set_blend_shape("Blink_R", right_blink)

static func calculate_eye_aspect_ratio(landmarks: Array, indices: Array) -> float:
	## Calculate Eye Aspect Ratio (EAR) for blink detection
	if landmarks.size() < indices.max():
		return 1.0
	
	# Get vertical distances
	var vertical1 = get_landmark_distance(landmarks, indices[1], indices[5])
	var vertical2 = get_landmark_distance(landmarks, indices[2], indices[4])
	
	# Get horizontal distance
	var horizontal = get_landmark_distance(landmarks, indices[0], indices[3])
	
	if horizontal < 0.001:
		return 1.0
	
	# EAR formula: (v1 + v2) / (2 * h)
	return (vertical1 + vertical2) / (2.0 * horizontal)

static func get_landmark_distance(landmarks: Array, idx1: int, idx2: int) -> float:
	if idx1 >= landmarks.size() or idx2 >= landmarks.size():
		return 0.0
	
	var lm1 = landmarks[idx1]
	var lm2 = landmarks[idx2]
	
	if not (lm1 is Dictionary and lm2 is Dictionary):
		return 0.0
	
	var x1 = lm1.get("x", 0.0)
	var y1 = lm1.get("y", 0.0)
	var x2 = lm2.get("x", 0.0)
	var y2 = lm2.get("y", 0.0)
	
	return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1))

static func apply_mouth_shape_from_landmarks(landmarks: Array, scene_model: SceneModel):
	# MediaPipe mouth landmarks: 61, 291, 0, 17
	# Top: 13, Bottom: 14, Left: 61, Right: 291
	
	var mouth_open = calculate_mouth_aspect_ratio(landmarks)
	
	# Map to vowel shapes based on mouth openness
	if mouth_open > 0.15:
		scene_model.set_blend_shape("A", clamp(mouth_open * 3.0, 0.0, 1.0))
	else:
		scene_model.set_blend_shape("A", 0.0)
	
	# Could add more sophisticated mouth shape detection here

static func calculate_mouth_aspect_ratio(landmarks: Array) -> float:
	## Calculate mouth openness
	if landmarks.size() < 300:
		return 0.0
	
	# Vertical distance (top to bottom)
	var vertical = get_landmark_distance(landmarks, 13, 14)
	
	# Horizontal distance (left to right)
	var horizontal = get_landmark_distance(landmarks, 61, 291)
	
	if horizontal < 0.001:
		return 0.0
	
	return vertical / horizontal

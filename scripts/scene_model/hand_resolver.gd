extends Node
## HandResolver - Converts MediaPipe hand landmarks to VRM hand bone transforms

class_name HandResolver

# MediaPipe hand landmark indices
enum HandLandmark {
	WRIST = 0,
	THUMB_CMC = 1,
	THUMB_MCP = 2,
	THUMB_IP = 3,
	THUMB_TIP = 4,
	INDEX_FINGER_MCP = 5,
	INDEX_FINGER_PIP = 6,
	INDEX_FINGER_DIP = 7,
	INDEX_FINGER_TIP = 8,
	MIDDLE_FINGER_MCP = 9,
	MIDDLE_FINGER_PIP = 10,
	MIDDLE_FINGER_DIP = 11,
	MIDDLE_FINGER_TIP = 12,
	RING_FINGER_MCP = 13,
	RING_FINGER_PIP = 14,
	RING_FINGER_DIP = 15,
	RING_FINGER_TIP = 16,
	PINKY_MCP = 17,
	PINKY_PIP = 18,
	PINKY_DIP = 19,
	PINKY_TIP = 20
}

static func apply_hand_to_model(landmarks: Array, scene_model: SceneModel, is_left: bool):
	if landmarks.is_empty() or not scene_model.is_model_loaded():
		return
	
	# Apply finger rotations
	apply_thumb(landmarks, scene_model, is_left)
	apply_index_finger(landmarks, scene_model, is_left)
	apply_middle_finger(landmarks, scene_model, is_left)
	apply_ring_finger(landmarks, scene_model, is_left)
	apply_pinky(landmarks, scene_model, is_left)

static func apply_thumb(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var bone_prefix = "Left" if is_left else "Right"
	apply_finger_chain(landmarks, scene_model, [
		HandLandmark.THUMB_CMC,
		HandLandmark.THUMB_MCP,
		HandLandmark.THUMB_IP,
		HandLandmark.THUMB_TIP
	], bone_prefix + "ThumbProximal")

static func apply_index_finger(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var bone_prefix = "Left" if is_left else "Right"
	apply_finger_chain(landmarks, scene_model, [
		HandLandmark.INDEX_FINGER_MCP,
		HandLandmark.INDEX_FINGER_PIP,
		HandLandmark.INDEX_FINGER_DIP,
		HandLandmark.INDEX_FINGER_TIP
	], bone_prefix + "IndexProximal")

static func apply_middle_finger(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var bone_prefix = "Left" if is_left else "Right"
	apply_finger_chain(landmarks, scene_model, [
		HandLandmark.MIDDLE_FINGER_MCP,
		HandLandmark.MIDDLE_FINGER_PIP,
		HandLandmark.MIDDLE_FINGER_DIP,
		HandLandmark.MIDDLE_FINGER_TIP
	], bone_prefix + "MiddleProximal")

static func apply_ring_finger(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var bone_prefix = "Left" if is_left else "Right"
	apply_finger_chain(landmarks, scene_model, [
		HandLandmark.RING_FINGER_MCP,
		HandLandmark.RING_FINGER_PIP,
		HandLandmark.RING_FINGER_DIP,
		HandLandmark.RING_FINGER_TIP
	], bone_prefix + "RingProximal")

static func apply_pinky(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var bone_prefix = "Left" if is_left else "Right"
	apply_finger_chain(landmarks, scene_model, [
		HandLandmark.PINKY_MCP,
		HandLandmark.PINKY_PIP,
		HandLandmark.PINKY_DIP,
		HandLandmark.PINKY_TIP
	], bone_prefix + "LittleProximal")

static func apply_finger_chain(landmarks: Array, scene_model: SceneModel, 
							   landmark_indices: Array, bone_name: String):
	# Calculate finger curl and rotation from landmarks
	for i in range(landmark_indices.size() - 1):
		var current = get_landmark(landmarks, landmark_indices[i])
		var next = get_landmark(landmarks, landmark_indices[i + 1])
		
		if current != Vector3.ZERO and next != Vector3.ZERO:
			# Calculate rotation needed to point from current to next
			var direction = (next - current).normalized()
			# TODO: Convert to bone rotation and apply to model

static func get_landmark(landmarks: Array, index: int) -> Vector3:
	if index < landmarks.size():
		var lm = landmarks[index]
		if lm is Dictionary:
			return Vector3(lm.get("x", 0), lm.get("y", 0), lm.get("z", 0))
		elif lm is Array and lm.size() >= 3:
			return Vector3(lm[0], lm[1], lm[2])
	return Vector3.ZERO

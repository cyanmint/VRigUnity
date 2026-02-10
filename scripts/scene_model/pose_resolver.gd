extends Node
## PoseResolver - Converts MediaPipe pose landmarks to VRM bone transforms

class_name PoseResolver

# MediaPipe pose landmark indices
enum PoseLandmark {
	NOSE = 0,
	LEFT_EYE_INNER = 1,
	LEFT_EYE = 2,
	LEFT_EYE_OUTER = 3,
	RIGHT_EYE_INNER = 4,
	RIGHT_EYE = 5,
	RIGHT_EYE_OUTER = 6,
	LEFT_EAR = 7,
	RIGHT_EAR = 8,
	MOUTH_LEFT = 9,
	MOUTH_RIGHT = 10,
	LEFT_SHOULDER = 11,
	RIGHT_SHOULDER = 12,
	LEFT_ELBOW = 13,
	RIGHT_ELBOW = 14,
	LEFT_WRIST = 15,
	RIGHT_WRIST = 16,
	LEFT_PINKY = 17,
	RIGHT_PINKY = 18,
	LEFT_INDEX = 19,
	RIGHT_INDEX = 20,
	LEFT_THUMB = 21,
	RIGHT_THUMB = 22,
	LEFT_HIP = 23,
	RIGHT_HIP = 24,
	LEFT_KNEE = 25,
	RIGHT_KNEE = 26,
	LEFT_ANKLE = 27,
	RIGHT_ANKLE = 28,
	LEFT_HEEL = 29,
	RIGHT_HEEL = 30,
	LEFT_FOOT_INDEX = 31,
	RIGHT_FOOT_INDEX = 32
}

static func apply_pose_to_model(landmarks: Array, scene_model: SceneModel):
	if landmarks.is_empty() or not scene_model.is_model_loaded():
		return
	
	# Convert MediaPipe landmarks to VRM bone rotations
	apply_upper_body(landmarks, scene_model)
	apply_lower_body(landmarks, scene_model)

static func apply_upper_body(landmarks: Array, scene_model: SceneModel):
	# Calculate and apply rotations for:
	# - Spine
	# - Chest
	# - Shoulders
	# - Arms
	# - Neck
	# - Head
	
	# Get key landmarks
	var left_shoulder = get_landmark(landmarks, PoseLandmark.LEFT_SHOULDER)
	var right_shoulder = get_landmark(landmarks, PoseLandmark.RIGHT_SHOULDER)
	var left_hip = get_landmark(landmarks, PoseLandmark.LEFT_HIP)
	var right_hip = get_landmark(landmarks, PoseLandmark.RIGHT_HIP)
	
	# Calculate shoulder rotation
	if left_shoulder and right_shoulder:
		var shoulder_direction = (right_shoulder - left_shoulder).normalized()
		# TODO: Apply to model bones
	
	# Apply arm rotations
	apply_arm_rotation(landmarks, scene_model, true)  # Left arm
	apply_arm_rotation(landmarks, scene_model, false) # Right arm

static func apply_arm_rotation(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var shoulder_idx = PoseLandmark.LEFT_SHOULDER if is_left else PoseLandmark.RIGHT_SHOULDER
	var elbow_idx = PoseLandmark.LEFT_ELBOW if is_left else PoseLandmark.RIGHT_ELBOW
	var wrist_idx = PoseLandmark.LEFT_WRIST if is_left else PoseLandmark.RIGHT_WRIST
	
	var shoulder = get_landmark(landmarks, shoulder_idx)
	var elbow = get_landmark(landmarks, elbow_idx)
	var wrist = get_landmark(landmarks, wrist_idx)
	
	if shoulder and elbow and wrist:
		# Calculate arm rotation
		var upper_arm_dir = (elbow - shoulder).normalized()
		var lower_arm_dir = (wrist - elbow).normalized()
		# TODO: Convert to bone rotations and apply to model

static func apply_lower_body(landmarks: Array, scene_model: SceneModel):
	# Calculate and apply rotations for:
	# - Hips
	# - Legs
	# - Feet
	pass

static func get_landmark(landmarks: Array, index: int) -> Vector3:
	if index < landmarks.size():
		var lm = landmarks[index]
		# MediaPipe landmarks are typically [x, y, z] normalized coordinates
		if lm is Dictionary:
			return Vector3(lm.get("x", 0), lm.get("y", 0), lm.get("z", 0))
		elif lm is Array and lm.size() >= 3:
			return Vector3(lm[0], lm[1], lm[2])
	return Vector3.ZERO

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
	
	# VRM bone names we'll be controlling
	var skeleton = scene_model.skeleton
	if not skeleton:
		return
	
	# Apply rotations to different body parts
	apply_spine_rotation(landmarks, scene_model)
	apply_head_rotation(landmarks, scene_model)
	apply_arm_rotations(landmarks, scene_model)
	apply_leg_rotations(landmarks, scene_model)

static func apply_spine_rotation(landmarks: Array, scene_model: SceneModel):
	# Calculate spine rotation from shoulder and hip positions
	var left_shoulder = get_landmark_vector(landmarks, PoseLandmark.LEFT_SHOULDER)
	var right_shoulder = get_landmark_vector(landmarks, PoseLandmark.RIGHT_SHOULDER)
	var left_hip = get_landmark_vector(landmarks, PoseLandmark.LEFT_HIP)
	var right_hip = get_landmark_vector(landmarks, PoseLandmark.RIGHT_HIP)
	
	if left_shoulder == Vector3.ZERO or right_shoulder == Vector3.ZERO:
		return
	
	# Calculate torso forward direction
	var shoulder_center = (left_shoulder + right_shoulder) / 2.0
	var hip_center = (left_hip + right_hip) / 2.0
	var spine_up = (shoulder_center - hip_center).normalized()
	
	# Calculate rotation and apply to spine bones
	var rotation = Quaternion.IDENTITY
	# TODO: Calculate proper rotation from spine_up vector
	
	# Apply to VRM bones
	set_bone_rotation(scene_model, "spine", rotation)
	set_bone_rotation(scene_model, "chest", rotation)

static func apply_head_rotation(landmarks: Array, scene_model: SceneModel):
	# Calculate head rotation from face landmarks
	var nose = get_landmark_vector(landmarks, PoseLandmark.NOSE)
	var left_ear = get_landmark_vector(landmarks, PoseLandmark.LEFT_EAR)
	var right_ear = get_landmark_vector(landmarks, PoseLandmark.RIGHT_EAR)
	
	if nose == Vector3.ZERO or left_ear == Vector3.ZERO or right_ear == Vector3.ZERO:
		return
	
	# Calculate head orientation
	var ear_center = (left_ear + right_ear) / 2.0
	var forward = (nose - ear_center).normalized()
	var right = (right_ear - left_ear).normalized()
	var up = right.cross(forward).normalized()
	
	# Create rotation from basis vectors
	var basis = Basis(right, up, -forward)  # Negative forward for correct orientation
	var rotation = Quaternion(basis)
	
	# Apply to head bones
	set_bone_rotation(scene_model, "neck", rotation)
	set_bone_rotation(scene_model, "head", rotation)

static func apply_arm_rotations(landmarks: Array, scene_model: SceneModel):
	# Apply left arm
	apply_single_arm(landmarks, scene_model, true)
	# Apply right arm
	apply_single_arm(landmarks, scene_model, false)

static func apply_single_arm(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var prefix = "left" if is_left else "right"
	var shoulder_idx = PoseLandmark.LEFT_SHOULDER if is_left else PoseLandmark.RIGHT_SHOULDER
	var elbow_idx = PoseLandmark.LEFT_ELBOW if is_left else PoseLandmark.RIGHT_ELBOW
	var wrist_idx = PoseLandmark.LEFT_WRIST if is_left else PoseLandmark.RIGHT_WRIST
	
	var shoulder = get_landmark_vector(landmarks, shoulder_idx)
	var elbow = get_landmark_vector(landmarks, elbow_idx)
	var wrist = get_landmark_vector(landmarks, wrist_idx)
	
	if shoulder == Vector3.ZERO or elbow == Vector3.ZERO or wrist == Vector3.ZERO:
		return
	
	# Calculate upper arm rotation
	var upper_arm_dir = (elbow - shoulder).normalized()
	var upper_arm_rotation = calculate_rotation_to_direction(upper_arm_dir, Vector3.DOWN)
	set_bone_rotation(scene_model, prefix + "UpperArm", upper_arm_rotation)
	
	# Calculate lower arm rotation
	var lower_arm_dir = (wrist - elbow).normalized()
	var lower_arm_rotation = calculate_rotation_to_direction(lower_arm_dir, Vector3.DOWN)
	set_bone_rotation(scene_model, prefix + "LowerArm", lower_arm_rotation)

static func apply_leg_rotations(landmarks: Array, scene_model: SceneModel):
	# Apply left leg
	apply_single_leg(landmarks, scene_model, true)
	# Apply right leg
	apply_single_leg(landmarks, scene_model, false)

static func apply_single_leg(landmarks: Array, scene_model: SceneModel, is_left: bool):
	var prefix = "left" if is_left else "right"
	var hip_idx = PoseLandmark.LEFT_HIP if is_left else PoseLandmark.RIGHT_HIP
	var knee_idx = PoseLandmark.LEFT_KNEE if is_left else PoseLandmark.RIGHT_KNEE
	var ankle_idx = PoseLandmark.LEFT_ANKLE if is_left else PoseLandmark.RIGHT_ANKLE
	
	var hip = get_landmark_vector(landmarks, hip_idx)
	var knee = get_landmark_vector(landmarks, knee_idx)
	var ankle = get_landmark_vector(landmarks, ankle_idx)
	
	if hip == Vector3.ZERO or knee == Vector3.ZERO or ankle == Vector3.ZERO:
		return
	
	# Calculate upper leg rotation
	var upper_leg_dir = (knee - hip).normalized()
	var upper_leg_rotation = calculate_rotation_to_direction(upper_leg_dir, Vector3.DOWN)
	set_bone_rotation(scene_model, prefix + "UpperLeg", upper_leg_rotation)
	
	# Calculate lower leg rotation
	var lower_leg_dir = (ankle - knee).normalized()
	var lower_leg_rotation = calculate_rotation_to_direction(lower_leg_dir, Vector3.DOWN)
	set_bone_rotation(scene_model, prefix + "LowerLeg", lower_leg_rotation)

static func calculate_rotation_to_direction(from_dir: Vector3, to_dir: Vector3) -> Quaternion:
	# Calculate rotation needed to rotate from_dir to align with to_dir
	var axis = from_dir.cross(to_dir)
	if axis.length_squared() < 0.001:
		return Quaternion.IDENTITY
	axis = axis.normalized()
	var angle = acos(clamp(from_dir.dot(to_dir), -1.0, 1.0))
	return Quaternion(axis, angle)

static func set_bone_rotation(scene_model: SceneModel, bone_name: String, rotation: Quaternion):
	# Convert bone name to match VRM naming (capitalize first letter)
	var vrm_bone_name = bone_name[0].to_upper() + bone_name.substr(1) if bone_name.length() > 0 else bone_name
	
	# Try both naming conventions
	if bone_name in scene_model.bone_cache:
		var bone_idx = scene_model.bone_cache[bone_name]
		scene_model.skeleton.set_bone_pose_rotation(bone_idx, rotation)
	elif vrm_bone_name in scene_model.bone_cache:
		var bone_idx = scene_model.bone_cache[vrm_bone_name]
		scene_model.skeleton.set_bone_pose_rotation(bone_idx, rotation)

static func get_landmark_vector(landmarks: Array, index: int) -> Vector3:
	if index < landmarks.size():
		var lm = landmarks[index]
		# MediaPipe landmarks are typically dictionaries with x, y, z
		if lm is Dictionary:
			# Convert from MediaPipe normalized coordinates to world space
			# MediaPipe: x=0-1 (left to right), y=0-1 (top to bottom), z=depth
			var x = lm.get("x", 0.5) - 0.5  # Center at origin
			var y = -(lm.get("y", 0.5) - 0.5)  # Invert Y (MediaPipe has Y down)
			var z = lm.get("z", 0.0)
			return Vector3(x, y, z)
		elif lm is Array and lm.size() >= 3:
			return Vector3(lm[0] - 0.5, -(lm[1] - 0.5), lm[2])
	return Vector3.ZERO

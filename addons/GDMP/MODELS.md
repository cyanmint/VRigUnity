# MediaPipe Models for GDMP

## Required Models

To use MediaPipe holistic tracking, you need to download the following model file:

### Holistic Landmarker

**File:** `holistic_landmarker.task`  
**Location:** Place in `addons/GDMP/models/`  
**Download:** https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task

**Size:** ~25 MB

## Installation Steps

1. Create the models directory:
```bash
mkdir -p addons/GDMP/models
```

2. Download the model:
```bash
cd addons/GDMP/models
wget https://storage.googleapis.com/mediapipe-models/holistic_landmarker/holistic_landmarker/float16/latest/holistic_landmarker.task
```

Or manually:
- Visit the URL above
- Save the file to `addons/GDMP/models/holistic_landmarker.task`

3. Verify the file exists:
```bash
ls -lh addons/GDMP/models/holistic_landmarker.task
```

## Alternative Models

You can also use other MediaPipe models for specific tasks:

### Face Landmarker
- URL: https://storage.googleapis.com/mediapipe-models/face_landmarker/face_landmarker/float16/latest/face_landmarker.task
- Use for: Face-only tracking

### Pose Landmarker
- URL: https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker/float16/latest/pose_landmarker.task
- Use for: Body pose-only tracking

### Hand Landmarker
- URL: https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/latest/hand_landmarker.task
- Use for: Hand-only tracking

## Model Variants

MediaPipe models come in different variants:
- **float16**: Smaller, faster, slightly less accurate (recommended)
- **float32**: Larger, slower, more accurate

For VRig, we recommend using float16 models for real-time performance.

## Troubleshooting

### Model not found error
```
ERROR: Holistic model file not found at: res://addons/GDMP/models/holistic_landmarker.task
```

**Solution:** Download the model file and place it in the correct location.

### Model download fails
If wget fails, try downloading manually in a browser and copying the file to the project.

### Performance issues
- Use float16 models instead of float32
- Reduce camera resolution
- Lower tracking framerate

## License

MediaPipe models are licensed under Apache 2.0 License.
See: https://github.com/google/mediapipe/blob/master/LICENSE

## More Information

- MediaPipe Solutions: https://developers.google.com/mediapipe/solutions/guide
- GDMP Documentation: https://github.com/j20001970/GDMP
- Model Cards: https://developers.google.com/mediapipe/solutions/vision/holistic_landmarker

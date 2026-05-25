import 'package:camera/camera.dart';
import 'package:poseweave/core/camera_diagnostics.dart';
import 'package:poseweave/data/models/pose_model.dart';

/// Owns the live camera + on-device ML Kit pose detection pipeline.
///
/// This is the only place camera and ML Kit types live. The preview widget
/// needs the [CameraController] to render frames, so it is exposed via
/// [controller] — that is the single, deliberate camera-type leak toward the
/// UI (display only; all control flows through this datasource and the BLoC).
abstract class MLKitCameraDataSource {
  /// The active controller, for `CameraPreview`. Null before [initialize].
  CameraController? get controller;

  /// Whether the front or back lens is currently selected.
  CameraLensDirection get lensDirection;

  /// Acquire the camera and prepare the detector. Throws [CameraException]
  /// (data-layer) on hardware/permission failure.
  Future<void> initialize({CameraLensDirection direction});

  /// Broadcast stream of detected poses (primary person), throttled to ~15 FPS.
  Stream<PoseModel> get poseStream;

  /// All people detected in the most recent frame (primary first). For drawing
  /// every skeleton and showing a person count.
  List<PoseModel> get latestPoses;

  /// Broadcast stream of pipeline diagnostics (frames/poses/format) for the
  /// on-device debug HUD.
  Stream<CameraDiagnostics> get diagnostics;

  /// Begin feeding frames to the detector (or synthetic frames in mock mode).
  Future<void> startDetection();

  /// Stop detection but keep the preview alive.
  Future<void> stopDetection();

  /// Flip between front and back cameras, preserving detection state.
  Future<void> switchCamera();

  /// Whether a video recording is in progress.
  bool get isRecordingVideo;

  /// Start recording video. Stops live detection first (the camera plugin
  /// can't stream images and record video simultaneously).
  Future<void> startVideoRecording();

  /// Stop recording; returns the saved video file path.
  Future<String> stopVideoRecording();

  /// Emit synthetic landmarks instead of real detection (emulator/UI dev).
  void setMockMode({required bool enabled});

  /// Release the controller, detector, and stream. Safe to call repeatedly.
  Future<void> dispose();
}

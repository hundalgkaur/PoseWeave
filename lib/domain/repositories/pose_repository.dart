import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/video_analysis_progress.dart';

/// The single boundary the presentation layer talks to for pose data and
/// camera lifecycle. Implementations map data-layer models/exceptions into
/// domain entities and [Failure]s.
///
/// Note: [cameraController] exposes a `camera` type for `CameraPreview`
/// rendering — the one deliberate camera-type leak above the data layer
/// (display only; all control goes through the methods here).
abstract class PoseRepository {
  /// Active controller for the preview widget, or null before initialization.
  CameraController? get cameraController;

  /// Currently selected lens (front/back).
  CameraLensDirection get lensDirection;

  /// Acquire the camera and prepare detection.
  Future<Either<Failure, Unit>> initializeCamera({
    CameraLensDirection direction,
  });

  /// Stream of detected poses while detection is running.
  Either<Failure, Stream<PoseEntity>> getPoseStream();

  /// Start / stop live detection (preview stays alive when stopped).
  Future<Either<Failure, Unit>> startDetection();
  Future<Either<Failure, Unit>> stopDetection();

  /// Flip between front and back cameras.
  Future<Either<Failure, Unit>> switchCamera();

  /// Whether a video recording is in progress.
  bool get isRecordingVideo;

  /// Start recording a video clip (stops live detection first).
  Future<Either<Failure, Unit>> startVideoRecording();

  /// Stop recording; returns the saved video file path.
  Future<Either<Failure, String>> stopVideoRecording();

  /// Toggle synthetic-pose mode for emulator/UI development.
  void setMockMode({required bool enabled});

  /// Release camera resources.
  Future<void> disposeCamera();

  /// Most recent poses (newest last), capped, for review/replay.
  List<PoseEntity> get recentPoses;

  /// Open the gallery picker; returns the chosen path or null.
  Future<Either<Failure, String?>> pickVideo();

  /// Analyze a video file frame-by-frame, emitting progress + poses.
  Stream<VideoAnalysisProgress> analyzeVideo(String filePath);

  /// Serialize poses to a JSON file; returns the written file path.
  Future<Either<Failure, String>> exportPosesToJson(List<PoseEntity> poses);
}

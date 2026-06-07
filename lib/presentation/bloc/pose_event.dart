import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

part 'pose_event.freezed.dart';

@freezed
class PoseEvent with _$PoseEvent {
  /// Request permission, acquire the camera, and prepare detection.
  const factory PoseEvent.initializeCamera() = InitializeCamera;

  /// Subscribe to the pose stream and begin detection.
  const factory PoseEvent.startDetection() = StartDetection;

  /// Stop detection but keep the preview alive.
  const factory PoseEvent.stopDetection() = StopDetection;

  /// Flip between front and back cameras.
  const factory PoseEvent.switchCamera() = SwitchCamera;

  /// Toggle synthetic-pose mode (emulator/UI development).
  const factory PoseEvent.toggleMockMode() = ToggleMockMode;

  /// Begin recording a video clip (live detection pauses).
  const factory PoseEvent.startVideoRecording() = StartVideoRecording;

  /// Stop recording, then analyze the clip frame-by-frame for poses.
  const factory PoseEvent.stopVideoRecording() = StopVideoRecording;

  /// Internal: a pose arrived on the stream. Not dispatched by the UI.
  const factory PoseEvent.poseReceived(PoseEntity pose) = PoseReceived;

  /// Internal: detection is running but no pose has arrived for a short window
  /// (no person in frame). Not dispatched by the UI.
  const factory PoseEvent.poseLost() = PoseLost;

  /// Open the gallery picker, then analyze the chosen video.
  const factory PoseEvent.pickAndAnalyzeVideo() = PickAndAnalyzeVideo;

  /// Open the gallery picker for a video to **trim** before analyzing (the UI
  /// then pushes a trim screen and dispatches [AnalyzeVideoFile] on the result).
  const factory PoseEvent.pickVideoForTrim() = PickVideoForTrim;

  /// Analyze a specific video file path.
  const factory PoseEvent.analyzeVideoFile(String filePath) = AnalyzeVideoFile;

  /// Open the image picker, then detect a pose in the chosen image.
  const factory PoseEvent.pickAndAnalyzeImage() = PickAndAnalyzeImage;

  /// Generate a PDF session report from the assembled [data].
  const factory PoseEvent.generateReport(ReportData data) = GenerateReport;
}

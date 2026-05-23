import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

part 'pose_state.freezed.dart';

@freezed
class PoseState with _$PoseState {
  /// Nothing started yet.
  const factory PoseState.initial() = PoseInitial;

  /// Working (initializing camera, opening picker, etc.).
  const factory PoseState.loading() = PoseLoading;

  /// Camera permission was denied.
  const factory PoseState.noPermission() = PoseNoPermission;

  /// Camera is live but no pose has been detected yet.
  const factory PoseState.streaming() = PoseStreaming;

  /// A pose is being tracked. Carries the full pose (landmarks + image size for
  /// the painter), the mean confidence for the badge, and a live FPS estimate.
  const factory PoseState.active({
    required PoseEntity pose,
    required double averageConfidence,
    required double fps,
  }) = PoseActive;

  /// A video clip is being recorded from the live camera.
  const factory PoseState.recordingVideo() = PoseRecordingVideo;

  /// A video is being analyzed frame-by-frame.
  const factory PoseState.videoProcessing({
    required double progress,
    required int framesProcessed,
    PoseEntity? currentPose,
  }) = PoseVideoProcessing;

  /// Video analysis finished; carries every detected pose and (for a recorded
  /// clip) the source video path so the export can bundle both artifacts.
  const factory PoseState.videoComplete({
    required List<PoseEntity> poses,
    required int frameCount,
    String? videoPath,
    @Default(<String>[]) List<String> framePaths,
  }) = PoseVideoComplete;

  /// An image is being analyzed.
  const factory PoseState.imageProcessing() = PoseImageProcessing;

  /// Image analysis finished; [pose] is null when no person was detected.
  const factory PoseState.imageComplete({
    required String imagePath,
    PoseEntity? pose,
  }) = PoseImageComplete;

  /// Something failed. [isRecoverable] gates whether the UI offers a retry.
  const factory PoseState.error({
    required String message,
    required bool isRecoverable,
  }) = PoseError;
}

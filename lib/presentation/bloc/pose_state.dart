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

  /// Detection is running but no person is currently in frame (ML Kit returned
  /// no pose for a short window). The UI shows a "no person detected" hint.
  const factory PoseState.searching() = PoseSearching;

  /// A pose is being tracked. Carries the full pose (landmarks + image size for
  /// the painter), the mean confidence for the badge, and a live FPS estimate.
  const factory PoseState.active({
    required PoseEntity pose,
    required double averageConfidence,
    required double fps,
    // Everyone detected this frame (primary first) for drawing all skeletons +
    // a person count. [pose] remains the primary for single-person features.
    @Default(<PoseEntity>[]) List<PoseEntity> allPoses,
  }) = PoseActive;

  /// A video clip is being recorded from the live camera.
  const factory PoseState.recordingVideo() = PoseRecordingVideo;

  /// A video was picked and is ready to be trimmed (the UI pushes the trim
  /// screen with [path], then analyzes the trimmed file).
  const factory PoseState.videoPicked(String path) = PoseVideoPicked;

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

  /// PDF report is being generated / ready / failed.
  const factory PoseState.reportGenerating() = PoseReportGenerating;
  const factory PoseState.reportReady({required String filePath}) =
      PoseReportReady;
  const factory PoseState.reportFailed({required String message}) =
      PoseReportFailed;

  /// Something failed. [isRecoverable] gates whether the UI offers a retry.
  const factory PoseState.error({
    required String message,
    required bool isRecoverable,
  }) = PoseError;
}

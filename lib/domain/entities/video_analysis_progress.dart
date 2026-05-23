import 'package:equatable/equatable.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Domain-level progress of a video pose-analysis run.
///
/// The data layer has its own `VideoProcessingProgress`; the repository maps to
/// this so nothing above it depends on the video-extraction implementation.
class VideoAnalysisProgress extends Equatable {
  const VideoAnalysisProgress({
    required this.currentFrame,
    required this.totalFrames,
    this.pose,
    this.framePath,
  });

  final int currentFrame;
  final int totalFrames;

  /// Pose detected at this frame, or null if none was found.
  final PoseEntity? pose;

  /// Path to the extracted frame image (for overlaying on the real frame).
  final String? framePath;

  double get progress => totalFrames == 0 ? 0 : currentFrame / totalFrames;
  bool get isComplete => currentFrame >= totalFrames;

  @override
  List<Object?> get props => <Object?>[
    currentFrame,
    totalFrames,
    pose,
    framePath,
  ];
}

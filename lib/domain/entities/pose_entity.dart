import 'dart:ui' show Size;

import 'package:equatable/equatable.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Where a pose came from. Lets the UI label results and lets mock data be
/// distinguished from real detections during emulator development.
enum PoseSource { camera, videoFile, mock }

/// A complete detected human pose: the aggregate root of the domain model.
///
/// Invariant: a pose always carries exactly 33 landmarks (ML Kit's full set),
/// asserted in the constructor so a malformed mapping fails loudly at the
/// boundary rather than producing a half-drawn skeleton downstream.
class PoseEntity extends Equatable {
  const PoseEntity({
    required this.landmarks,
    required this.timestamp,
    required this.source,
    this.imageSize,
  }) : assert(
          landmarks.length == 33,
          'A PoseEntity must contain exactly 33 landmarks, got ${landmarks.length}.',
        );

  /// All 33 landmarks, indexed positionally by [PoseLandmarkType] ordinal.
  final List<LandmarkEntity> landmarks;

  /// When this pose was captured/detected.
  final DateTime timestamp;

  /// Origin of the pose.
  final PoseSource source;

  /// Original frame dimensions, used by the painter to scale normalized
  /// coordinates while preserving aspect ratio. Null if unknown.
  final Size? imageSize;

  /// Mean confidence across all landmarks (0.0 .. 1.0). Drives the on-screen
  /// confidence badge.
  double get averageConfidence {
    if (landmarks.isEmpty) return 0.0;
    final double total = landmarks.fold<double>(
      0.0,
      (double sum, LandmarkEntity l) => sum + l.confidence,
    );
    return total / landmarks.length;
  }

  /// Safe lookup by landmark type; returns null if absent.
  LandmarkEntity? getLandmark(PoseLandmarkType type) {
    for (final LandmarkEntity landmark in landmarks) {
      if (landmark.type == type) return landmark;
    }
    return null;
  }

  @override
  List<Object?> get props =>
      <Object?>[landmarks, timestamp, source, imageSize];
}

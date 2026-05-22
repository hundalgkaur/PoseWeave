import 'dart:ui' show Size;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:poseweave/data/models/landmark_model.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

part 'pose_model.freezed.dart';
part 'pose_model.g.dart';

/// Serializable data-layer counterpart of [PoseEntity].
///
/// The frame size is stored as width/height (not `Size`, which isn't JSON
/// serializable) and rebuilt in [toEntity].
@freezed
class PoseModel with _$PoseModel {
  const PoseModel._();

  const factory PoseModel({
    required List<LandmarkModel> landmarks,
    required DateTime timestamp,
    required PoseSource source,
    double? imageWidth,
    double? imageHeight,
  }) = _PoseModel;

  factory PoseModel.fromJson(Map<String, dynamic> json) =>
      _$PoseModelFromJson(json);

  /// Maps a domain entity back to a model (for JSON export).
  factory PoseModel.fromEntity(PoseEntity entity) => PoseModel(
        landmarks: entity.landmarks.map(LandmarkModel.fromEntity).toList(),
        timestamp: entity.timestamp,
        source: entity.source,
        imageWidth: entity.imageSize?.width,
        imageHeight: entity.imageSize?.height,
      );

  /// Maps an ML Kit [mlkit.Pose] into a normalized model.
  ///
  /// ML Kit reports landmark coordinates in image *pixels*; we divide by
  /// [imageSize] to normalize to 0..1. We iterate our own 33-value enum (not
  /// ML Kit's map) so the result always has exactly 33 landmarks in canonical
  /// order — any landmark ML Kit omitted becomes a zero-confidence placeholder,
  /// preserving the [PoseEntity] invariant.
  factory PoseModel.fromMLKitPose(
    mlkit.Pose pose, {
    required Size imageSize,
    required PoseSource source,
    DateTime? timestamp,
  }) {
    final double w = imageSize.width == 0 ? 1 : imageSize.width;
    final double h = imageSize.height == 0 ? 1 : imageSize.height;

    final List<LandmarkModel> landmarks =
        PoseLandmarkType.values.map((PoseLandmarkType type) {
      final mlkit.PoseLandmark? ml =
          pose.landmarks[mlkit.PoseLandmarkType.values[type.index]];
      if (ml == null) {
        return LandmarkModel(type: type, x: 0, y: 0, confidence: 0);
      }
      return LandmarkModel(
        type: type,
        x: (ml.x / w).clamp(0.0, 1.0),
        y: (ml.y / h).clamp(0.0, 1.0),
        z: ml.z,
        confidence: ml.likelihood,
      );
    }).toList();

    return PoseModel(
      landmarks: landmarks,
      timestamp: timestamp ?? DateTime.now(),
      source: source,
      imageWidth: imageSize.width,
      imageHeight: imageSize.height,
    );
  }

  PoseEntity toEntity() => PoseEntity(
        landmarks:
            landmarks.map((LandmarkModel l) => l.toEntity()).toList(),
        timestamp: timestamp,
        source: source,
        imageSize: (imageWidth != null && imageHeight != null)
            ? Size(imageWidth!, imageHeight!)
            : null,
      );
}

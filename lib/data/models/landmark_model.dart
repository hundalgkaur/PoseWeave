import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

part 'landmark_model.freezed.dart';
part 'landmark_model.g.dart';

/// Serializable data-layer counterpart of [LandmarkEntity].
///
/// Coordinates are already normalized (0..1) here — the ML Kit -> model
/// conversion in [PoseModel.fromMLKitPose] divides raw pixel coordinates by the
/// frame size, so everything above the data layer is resolution-independent.
@freezed
class LandmarkModel with _$LandmarkModel {
  const LandmarkModel._();

  const factory LandmarkModel({
    required PoseLandmarkType type,
    required double x,
    required double y,
    required double confidence,
    double? z,
  }) = _LandmarkModel;

  factory LandmarkModel.fromJson(Map<String, dynamic> json) =>
      _$LandmarkModelFromJson(json);

  factory LandmarkModel.fromEntity(LandmarkEntity entity) => LandmarkModel(
        type: entity.type,
        x: entity.x,
        y: entity.y,
        confidence: entity.confidence,
        z: entity.z,
      );

  LandmarkEntity toEntity() => LandmarkEntity(
        type: type,
        x: x,
        y: y,
        confidence: confidence,
        z: z,
      );
}

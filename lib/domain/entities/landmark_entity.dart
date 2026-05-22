import 'package:equatable/equatable.dart';

/// The 33 body landmarks produced by Google ML Kit pose detection.
///
/// The order of these values is significant: it mirrors ML Kit's own
/// `PoseLandmarkType` ordinals 1:1 (see PRD §19). The data layer maps an ML Kit
/// landmark to this enum by index, so reordering these would silently corrupt
/// every detected pose. Do not sort or insert values.
enum PoseLandmarkType {
  nose,
  leftEyeInner,
  leftEye,
  leftEyeOuter,
  rightEyeInner,
  rightEye,
  rightEyeOuter,
  leftEar,
  rightEar,
  leftMouth,
  rightMouth,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPinky,
  rightPinky,
  leftIndex,
  rightIndex,
  leftThumb,
  rightThumb,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftHeel,
  rightHeel,
  leftFootIndex,
  rightFootIndex,
}

/// A single detected body point.
///
/// Exists as a layer-agnostic value object so the presentation and domain
/// layers never touch ML Kit's `PoseLandmark` type. Coordinates are normalized
/// (0..1) relative to the source image, which lets the overlay painter scale
/// them to any canvas size without knowing the original frame resolution.
class LandmarkEntity extends Equatable {
  const LandmarkEntity({
    required this.type,
    required this.x,
    required this.y,
    required this.confidence,
    this.z,
  });

  /// Which body point this is.
  final PoseLandmarkType type;

  /// Normalized horizontal position, 0.0 (left) .. 1.0 (right) of the frame.
  final double x;

  /// Normalized vertical position, 0.0 (top) .. 1.0 (bottom) of the frame.
  final double y;

  /// Approximate depth from ML Kit. Null when unavailable; only used for 3D.
  final double? z;

  /// Detection likelihood, 0.0 .. 1.0.
  final double confidence;

  /// Whether this landmark is confident enough to render. Below this the
  /// overlay hides the dot and any bone attached to it (PRD §8.2).
  bool get isVisible => confidence >= 0.5;

  @override
  List<Object?> get props => <Object?>[type, x, y, z, confidence];
}

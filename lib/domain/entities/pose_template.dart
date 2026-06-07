import 'package:poseweave/domain/entities/landmark_entity.dart';

/// One rule in a [PoseTemplate]: the angle at vertex [b] formed by [a]-[b]-[c]
/// should sit near [targetDeg] within [tolerance] degrees. Angles are
/// inherently scale-invariant, so templates work regardless of how far the
/// subject is from the camera.
class JointConstraint {
  const JointConstraint({
    required this.a,
    required this.b,
    required this.c,
    required this.targetDeg,
    required this.tolerance,
    required this.label,
  });

  final PoseLandmarkType a;
  final PoseLandmarkType b;
  final PoseLandmarkType c;
  final double targetDeg;
  final double tolerance;

  /// Human-readable joint name for correction hints, e.g. "Left elbow".
  final String label;
}

/// A named target pose, defined purely by joint-angle constraints so new poses
/// can be added by editing the template table (`core/constants/pose_templates`).
class PoseTemplate {
  const PoseTemplate({
    required this.name,
    required this.constraints,
    this.imageAsset,
  });

  final String name;
  final List<JointConstraint> constraints;

  /// Optional bundled reference photo (e.g. `assets/images/poses/mountain.png`)
  /// shown in the guided "Match a target" mode. Null → the UI falls back to an
  /// icon, so no asset is required.
  final String? imageAsset;
}

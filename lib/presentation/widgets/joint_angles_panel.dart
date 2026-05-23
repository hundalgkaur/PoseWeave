import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Joint angles (left/right knee, elbow, hip) computed from a single pose via
/// [PoseMath.calculateAngle3Points], plus a left/right symmetry estimate.
/// Shared by the 3D viewer and image-analysis screens.
class JointAnglesPanel extends StatelessWidget {
  const JointAnglesPanel({required this.pose, super.key});

  final PoseEntity pose;

  double? _angle(PoseLandmarkType a, PoseLandmarkType b, PoseLandmarkType c) {
    final LandmarkEntity? la = pose.getLandmark(a);
    final LandmarkEntity? lb = pose.getLandmark(b);
    final LandmarkEntity? lc = pose.getLandmark(c);
    if (la == null || lb == null || lc == null) return null;
    return PoseMath.calculateAngle3Points(la, lb, lc);
  }

  /// 0..100 symmetry between two same-named joints (100 = identical).
  double? _symmetry(double? left, double? right) {
    if (left == null || right == null) return null;
    final double max = left > right ? left : right;
    if (max == 0) return 100;
    return (100 * (1 - (left - right).abs() / max)).clamp(0, 100);
  }

  @override
  Widget build(BuildContext context) {
    final double? lKnee = _angle(
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
      PoseLandmarkType.leftAnkle,
    );
    final double? rKnee = _angle(
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
      PoseLandmarkType.rightAnkle,
    );
    final double? lElbow = _angle(
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftElbow,
      PoseLandmarkType.leftWrist,
    );
    final double? rElbow = _angle(
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightElbow,
      PoseLandmarkType.rightWrist,
    );
    final double? lHip = _angle(
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.leftKnee,
    );
    final double? rHip = _angle(
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.rightHip,
      PoseLandmarkType.rightKnee,
    );
    final double? symmetry = _symmetry(lKnee, rKnee);

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('JOINT ANGLES', style: AppTheme.labelCaps()),
          const SizedBox(height: 12),
          _AngleRow(label: 'Knee', left: lKnee, right: rKnee),
          _AngleRow(label: 'Elbow', left: lElbow, right: rElbow),
          _AngleRow(label: 'Hip', left: lHip, right: rHip),
          const Divider(color: AppColors.outlineVariant, height: 20),
          Row(
            children: <Widget>[
              SizedBox(
                width: 70,
                child: Text(
                  'Symmetry',
                  style: AppTheme.mono(
                    fontSize: 13,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Text(
                symmetry == null ? '--' : '${symmetry.round()}%',
                style: AppTheme.mono(
                  fontSize: 13,
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AngleRow extends StatelessWidget {
  const _AngleRow({
    required this.label,
    required this.left,
    required this.right,
  });
  final String label;
  final double? left;
  final double? right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: AppTheme.mono(fontSize: 13, color: AppColors.onSurface),
            ),
          ),
          Expanded(
            child: Text(
              'L ${left == null ? '--' : '${left!.round()}°'}',
              style: AppTheme.mono(fontSize: 13, color: AppColors.primary),
            ),
          ),
          Expanded(
            child: Text(
              'R ${right == null ? '--' : '${right!.round()}°'}',
              style: AppTheme.mono(fontSize: 13, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

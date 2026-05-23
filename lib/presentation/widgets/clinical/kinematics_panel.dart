import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Live kinematic readout (sagittal knee / hip flexion / elbow) from a pose,
/// in the clinical neon style. Reuses [PoseMath.calculateAngle3Points].
class KinematicsPanel extends StatelessWidget {
  const KinematicsPanel({required this.pose, super.key});

  final PoseEntity pose;

  double? _angle(
    PoseLandmarkType a,
    PoseLandmarkType b,
    PoseLandmarkType c,
  ) {
    final LandmarkEntity? la = pose.getLandmark(a);
    final LandmarkEntity? lb = pose.getLandmark(b);
    final LandmarkEntity? lc = pose.getLandmark(c);
    if (la == null || lb == null || lc == null) return null;
    return PoseMath.calculateAngle3Points(la, lb, lc);
  }

  @override
  Widget build(BuildContext context) {
    final double? knee = _angle(PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle);
    final double? hip = _angle(PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee);
    final double? elbow = _angle(PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist);

    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('LIVE KINEMATICS', style: AppTheme.labelCaps()),
          const SizedBox(height: 10),
          _row('Sagittal Knee', knee),
          _row('Hip Flexion', hip),
          _row('Elbow', elbow),
        ],
      ),
    );
  }

  Widget _row(String label, double? deg) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 110,
              child: Text(label,
                  style: AppTheme.mono(
                      fontSize: 12, color: AppColors.onSurfaceVariant)),
            ),
            Text(
              deg == null ? '--' : '${deg.toStringAsFixed(1)}°',
              style: AppTheme.mono(
                fontSize: 13,
                color: AppColors.primary,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
}

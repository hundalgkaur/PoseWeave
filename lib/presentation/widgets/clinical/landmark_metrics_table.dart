import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Clinical-style landmark depth table: relative depth (mm, **uncalibrated** —
/// derived from ML Kit Z), a neutral reference, and the deviation. Low-
/// confidence rows are flagged in error color (the mockup's "ERROR" rows).
class LandmarkMetricsTable extends StatelessWidget {
  const LandmarkMetricsTable({required this.landmarks, super.key});

  final List<LandmarkEntity> landmarks;

  static const List<PoseLandmarkType> _shown = <PoseLandmarkType>[
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.leftAnkle,
    PoseLandmarkType.rightAnkle,
  ];

  LandmarkEntity? _get(PoseLandmarkType t) {
    for (final LandmarkEntity l in landmarks) {
      if (l.type == t) return l;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _row('Landmark', 'Depth(mm)', 'Ref', '±', header: true),
        const Divider(color: AppColors.outlineVariant, height: 12),
        for (final PoseLandmarkType t in _shown)
          if (_get(t) case final LandmarkEntity l)
            Builder(
              builder: (BuildContext context) {
                final double depth = (l.z ?? 0) * 1000;
                final bool low = l.confidence < 0.5;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: _row(
                    t.name,
                    depth.toStringAsFixed(1),
                    '0.0',
                    depth.abs().toStringAsFixed(1),
                    risk: low,
                  ),
                );
              },
            ),
        const SizedBox(height: 8),
        Text(
          'Depth is relative & uncalibrated (from 2D + ML Kit Z) — illustrative, '
          'not a clinical measurement.',
          style: AppTheme.labelCaps(fontSize: 8),
        ),
      ],
    );
  }

  Widget _row(
    String a,
    String b,
    String c,
    String d, {
    bool header = false,
    bool risk = false,
  }) {
    final Color color = header
        ? AppColors.onSurfaceVariant
        : (risk ? AppColors.error : AppColors.onSurface);
    final TextStyle style = AppTheme.mono(fontSize: 12, color: color);
    return Row(
      children: <Widget>[
        Expanded(flex: 5, child: Text(a, style: style)),
        Expanded(flex: 3, child: Text(b, style: style, textAlign: TextAlign.right)),
        Expanded(flex: 2, child: Text(c, style: style, textAlign: TextAlign.right)),
        Expanded(flex: 2, child: Text(d, style: style, textAlign: TextAlign.right)),
      ],
    );
  }
}

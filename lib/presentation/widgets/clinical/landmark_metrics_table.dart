import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/presentation/widgets/metric_row.dart';

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
    return MetricRow(
      header: header,
      risk: risk,
      cells: <MetricCell>[
        MetricCell(a, flex: 5),
        MetricCell(b, flex: 3, align: TextAlign.right),
        MetricCell(c, flex: 2, align: TextAlign.right),
        MetricCell(d, flex: 2, align: TextAlign.right),
      ],
    );
  }
}

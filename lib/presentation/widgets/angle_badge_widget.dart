import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/utils/pose_math.dart';

/// A colored pill showing an [AngleClassification]: cyan for neutral/flexed,
/// amber for over-flexion, coral for risk states (valgus/varus/hyperextended).
class AngleBadge extends StatelessWidget {
  const AngleBadge({required this.analysis, super.key});

  final AngleAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final Color color = _color(analysis.classification);
    final String label = _label(analysis.classification);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          if (analysis.isRisk) ...<Widget>[
            const SizedBox(width: 4),
            Icon(Icons.warning_amber_rounded, color: color, size: 12),
          ],
        ],
      ),
    );
  }

  static Color _color(AngleClassification c) {
    switch (c) {
      case AngleClassification.valgus:
      case AngleClassification.varus:
      case AngleClassification.hyperextended:
        return AppColors.error;
      case AngleClassification.hyperflexed:
        return AppColors.warning;
      case AngleClassification.neutral:
      case AngleClassification.flexed:
      case AngleClassification.extended:
        return AppColors.primary;
    }
  }

  static String _label(AngleClassification c) {
    switch (c) {
      case AngleClassification.neutral:
        return 'Neutral';
      case AngleClassification.valgus:
        return 'Valgus';
      case AngleClassification.varus:
        return 'Varus';
      case AngleClassification.hyperflexed:
        return 'Hyperflexed';
      case AngleClassification.flexed:
        return 'Flexed';
      case AngleClassification.extended:
        return 'Extended';
      case AngleClassification.hyperextended:
        return 'Hyperextended';
    }
  }
}

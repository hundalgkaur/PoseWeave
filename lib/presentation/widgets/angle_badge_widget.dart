import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/presentation/widgets/status_badge.dart';

/// A colored pill showing an [AngleClassification]: cyan for neutral/flexed,
/// amber for over-flexion, coral for risk states (valgus/varus/hyperextended).
class AngleBadge extends StatelessWidget {
  const AngleBadge({required this.analysis, super.key});

  final AngleAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: _label(analysis.classification),
      color: _color(analysis.classification),
      icon: analysis.isRisk ? Icons.warning_amber_rounded : null,
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

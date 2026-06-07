import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/clinical_assessment.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/status_badge.dart';

/// A clinical metric pod: big value + unit, a NORMAL/WARNING/CRITICAL chip, and
/// the reference range. Left accent bar colored by status.
class StatusMetricPod extends StatelessWidget {
  const StatusMetricPod({required this.metric, super.key});

  final ClinicalMetric metric;

  static Color colorFor(ClinicalStatus s) {
    switch (s) {
      case ClinicalStatus.normal:
        return AppColors.primary;
      case ClinicalStatus.warning:
        return AppColors.warning;
      case ClinicalStatus.critical:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color c = colorFor(metric.status);
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      borderColor: c.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(metric.label.toUpperCase(), style: AppTheme.labelCaps(fontSize: 9)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: <Widget>[
              Text(
                metric.value,
                style: AppTheme.mono(
                  fontSize: 26,
                  color: c,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(metric.unit,
                  style: AppTheme.mono(
                      fontSize: 11, color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 6),
          StatusBadge(
            label: metric.status.name.toUpperCase(),
            color: c,
            fontSize: 9,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          ),
          const SizedBox(height: 4),
          Text('Ref ${metric.reference}',
              style: AppTheme.mono(
                  fontSize: 9, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}

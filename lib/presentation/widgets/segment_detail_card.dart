import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/presentation/widgets/angle_badge_widget.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// One body-segment card: title, primary joint angle, classification badge, and
/// the three contributing landmarks with confidence dots.
class SegmentDetailCard extends StatelessWidget {
  const SegmentDetailCard({
    required this.title,
    required this.analysis,
    required this.joints,
    super.key,
  });

  final String title;
  final AngleAnalysis analysis;

  /// (label, confidence) for the three landmarks of this segment.
  final List<(String, double)> joints;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title, style: AppTheme.labelCaps()),
          const SizedBox(height: 12),
          Text(
            '${analysis.degrees.round()}°',
            style: AppTheme.mono(
              fontSize: 32,
              color: AppColors.primary,
              weight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          AngleBadge(analysis: analysis),
          const Divider(color: AppColors.outlineVariant, height: 24),
          for (final (String, double) j in joints)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      j.$1,
                      style: AppTheme.mono(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  _ConfidenceDot(confidence: j.$2),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ConfidenceDot extends StatelessWidget {
  const _ConfidenceDot({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final Color color =
        confidence >= 0.8
            ? AppColors.success
            : (confidence >= 0.5 ? AppColors.warning : AppColors.error);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

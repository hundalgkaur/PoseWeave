import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Floating badge showing the mean detection confidence as a ring + percentage.
/// The percentage uses JetBrains Mono so its width is stable as it updates.
class ConfidenceIndicator extends StatelessWidget {
  const ConfidenceIndicator({required this.confidence, super.key});

  /// Mean confidence, 0.0 .. 1.0.
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final int percent = (confidence.clamp(0.0, 1.0) * 100).round();
    return GlassPanel(
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 24,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CircularProgressIndicator(
                  value: confidence.clamp(0.0, 1.0),
                  strokeWidth: 3,
                  backgroundColor: AppColors.outlineVariant,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryContainer,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('CONFIDENCE', style: AppTheme.labelCaps(fontSize: 9)),
              Text(
                '$percent%',
                style: AppTheme.mono(
                  fontSize: 15,
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

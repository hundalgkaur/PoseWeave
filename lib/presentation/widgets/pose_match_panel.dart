import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Shows the detected pose name, match %, and per-joint correction hints.
class PoseMatchPanel extends StatelessWidget {
  const PoseMatchPanel({required this.result, super.key});

  final PoseMatchResult result;

  @override
  Widget build(BuildContext context) {
    final bool good = result.matchPercent >= 75;
    final Color accent = result.isMatch
        ? (good ? AppColors.success : AppColors.warning)
        : AppColors.onSurfaceVariant;

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  result.poseName.toUpperCase(),
                  style: AppTheme.mono(
                    color: AppColors.onSurface,
                    fontSize: 20,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${result.matchPercent.round()}%',
                style: AppTheme.mono(
                  color: accent,
                  fontSize: 22,
                  weight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (result.isMatch && result.deviations.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Text('ADJUST', style: AppTheme.labelCaps(fontSize: 9)),
            const SizedBox(height: 4),
            for (final JointDeviation d in result.deviations)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.tune,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        d.hint,
                        style: AppTheme.mono(
                          color: AppColors.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ] else if (result.isMatch) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              'Hold it — great form',
              style: AppTheme.mono(color: AppColors.success, fontSize: 12),
            ),
          ] else ...<Widget>[
            const SizedBox(height: 6),
            Text(
              'Hold a known pose to match',
              style: AppTheme.mono(
                color: AppColors.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

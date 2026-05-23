import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// List of AI recommendation cards, color-coded by severity.
class RecommendationsPanel extends StatelessWidget {
  const RecommendationsPanel({required this.items, super.key});

  final List<RecommendationEntity> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Text(
        'No recommendations returned.',
        style: AppTheme.mono(color: AppColors.onSurfaceVariant, fontSize: 12),
      );
    }
    return Column(
      children: items.map((RecommendationEntity r) => _Card(rec: r)).toList(),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.rec});
  final RecommendationEntity rec;

  Color get _color {
    switch (rec.severity) {
      case Severity.high:
        return AppColors.error;
      case Severity.medium:
        return AppColors.warning;
      case Severity.low:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassPanel(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    rec.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  rec.bodyPart,
                  style: AppTheme.labelCaps(color: _color, fontSize: 9),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              rec.detail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Per-segment range-of-motion table (avg / max / classification) from a pose
/// sequence's [SegmentSummary] map.
class RomTable extends StatelessWidget {
  const RomTable({required this.segments, super.key});

  final Map<String, SegmentSummary> segments;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('JOINT ROM', style: AppTheme.labelCaps()),
          const SizedBox(height: 8),
          _row('Segment', 'Avg', 'Max', 'Class', header: true),
          const Divider(color: AppColors.outlineVariant, height: 14),
          for (final SegmentSummary s in segments.values)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _row(
                s.label,
                '${s.avgDeg.round()}°',
                '${s.maxDeg.round()}°',
                s.isRisk ? '${s.classification.name} (!)' : s.classification.name,
                risk: s.isRisk,
              ),
            ),
        ],
      ),
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
        Expanded(flex: 4, child: Text(a, style: style)),
        Expanded(flex: 2, child: Text(b, style: style)),
        Expanded(flex: 2, child: Text(c, style: style)),
        Expanded(flex: 3, child: Text(d, style: style, textAlign: TextAlign.right)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// One cell in a [MetricRow]: text + its flex weight + alignment, with an
/// optional per-cell color override (for rows where one column is highlighted).
class MetricCell {
  const MetricCell(
    this.text, {
    this.flex = 1,
    this.align = TextAlign.left,
    this.color,
  });

  final String text;
  final int flex;
  final TextAlign align;
  final Color? color;
}

/// A monospace data row used by the landmark/ROM/metrics tables. Cells are
/// flex-weighted and **ellipsize** (maxLines 1) so the row never overflows on a
/// narrow phone. Consolidates the previously-duplicated `_row` helpers.
class MetricRow extends StatelessWidget {
  const MetricRow({
    required this.cells,
    super.key,
    this.leading,
    this.color,
    this.fontSize = 12,
    this.header = false,
    this.risk = false,
  });

  final List<MetricCell> cells;

  /// Optional leading widget (e.g. a confidence dot) before the first cell.
  final Widget? leading;

  /// Overrides the row's base text color. Otherwise derived from
  /// [header]/[risk]: dim for headers, error for risk, else onSurface.
  final Color? color;
  final double fontSize;
  final bool header;
  final bool risk;

  @override
  Widget build(BuildContext context) {
    final Color base = color ??
        (header
            ? AppColors.onSurfaceVariant
            : (risk ? AppColors.error : AppColors.onSurface));
    return Row(
      children: <Widget>[
        if (leading != null) ...<Widget>[
          leading!,
          const SizedBox(width: AppSpacing.sm),
        ],
        for (final MetricCell c in cells)
          Expanded(
            flex: c.flex,
            child: Text(
              c.text,
              textAlign: c.align,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.mono(fontSize: fontSize, color: c.color ?? base),
            ),
          ),
      ],
    );
  }
}

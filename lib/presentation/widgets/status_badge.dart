import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_radius.dart';

/// A colored status pill: tinted fill + border + label (+ optional trailing
/// icon), all driven by one [color]. The single source for the badge pattern
/// previously duplicated across the angle badge and clinical status pod.
///
/// The fill alpha (0.22) is tuned so the pill reads clearly on the dark surface
/// (WCAG-friendly) without washing out the colored label.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    required this.color,
    super.key,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  });

  final String label;
  final Color color;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          if (icon != null) ...<Widget>[
            const SizedBox(width: 4),
            Icon(icon, color: color, size: fontSize + 1),
          ],
        ],
      ),
    );
  }
}

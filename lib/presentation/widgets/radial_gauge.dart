import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// Small circular gauge: a cyan arc filling proportional to [valueDeg]/[maxDeg],
/// with the value in the centre and a caption below. Used for arm-swing.
class RadialGauge extends StatelessWidget {
  const RadialGauge({
    required this.valueDeg,
    required this.label,
    super.key,
    this.maxDeg = 90,
  });

  final double valueDeg;
  final double maxDeg;
  final String label;

  @override
  Widget build(BuildContext context) {
    final double fraction = (valueDeg / maxDeg).clamp(0.0, 1.0);
    return Semantics(
      label: '$label ${valueDeg.round()} degrees',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                CustomPaint(
                  size: const Size(64, 64),
                  painter: _GaugePainter(fraction),
                ),
                Text(
                  '${valueDeg.round()}°',
                  style: AppTheme.mono(
                    fontSize: 14,
                    color: AppColors.primary,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTheme.labelCaps(fontSize: 10)),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter(this.fraction);
  final double fraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.width / 2 - 3;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);
    final Paint track =
        Paint()
          ..color = AppColors.surfaceContainerHighest
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
    final Paint arc =
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * fraction, false, arc);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.fraction != fraction;
}

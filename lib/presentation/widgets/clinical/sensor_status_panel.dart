import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Mock acquisition-status panel for the clinical live screen: a small grid of
/// "sensor" readouts (all simulated — there is only the device camera). Purely
/// chrome to match the diagnostic mockups; not real telemetry.
class SensorStatusPanel extends StatelessWidget {
  const SensorStatusPanel({this.tracking = false, super.key});

  /// Whether a diagnostic session is live; flips the optical row to green.
  final bool tracking;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('SENSOR STATUS', style: AppTheme.labelCaps()),
          const SizedBox(height: 10),
          _row('Optical', tracking ? 'ACTIVE' : 'STANDBY',
              tracking ? AppColors.primary : AppColors.onSurfaceVariant),
          _row('Depth Est.', 'ML KIT Z', AppColors.warning),
          _row('IMU', 'SIMULATED', AppColors.onSurfaceVariant),
          _row('Sync', '60 Hz', AppColors.primary),
          const SizedBox(height: 8),
          Text('Simulated telemetry — single-camera device.',
              style: AppTheme.labelCaps(fontSize: 8)),
        ],
      ),
    );
  }

  Widget _row(String label, String value, Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Expanded(
              child: Text(label,
                  style: AppTheme.mono(
                      fontSize: 12, color: AppColors.onSurfaceVariant)),
            ),
            Text(value,
                style:
                    AppTheme.mono(fontSize: 12, color: color, weight: FontWeight.w700)),
          ],
        ),
      );
}

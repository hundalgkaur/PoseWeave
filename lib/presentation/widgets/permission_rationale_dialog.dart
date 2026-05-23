import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Explains why the camera is needed after a denial, and routes the user to
/// either retry or open system settings (for a permanent denial).
///
/// Returns `true` if the user chose to retry, `false`/null otherwise.
class PermissionRationaleDialog extends StatelessWidget {
  const PermissionRationaleDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => const PermissionRationaleDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.videocam_off, color: AppColors.primary, size: 32),
            const SizedBox(height: 16),
            Text(
              'Camera access needed',
              style: text.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'PoseWeave detects body poses entirely on-device from the camera '
              'feed. Nothing is uploaded. Grant camera access to start live '
              'detection.',
              style: text.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    Navigator.of(context).pop(false);
                  },
                  child: const Text(
                    'Open settings',
                    style: TextStyle(color: AppColors.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

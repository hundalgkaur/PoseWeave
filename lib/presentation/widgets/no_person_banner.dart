import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// Overlay shown over the live preview when detection is running but ML Kit
/// finds no person in the frame.
class NoPersonBanner extends StatelessWidget {
  const NoPersonBanner({
    super.key,
    this.message = 'Step into the frame, full body visible',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHighest.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.person_search,
                  color: AppColors.warning, size: 32),
              const SizedBox(height: 8),
              Text('NO HUMAN DETECTED',
                  style: AppTheme.labelCaps(color: AppColors.warning)),
              const SizedBox(height: 4),
              Text(message,
                  textAlign: TextAlign.center,
                  style: AppTheme.mono(
                      fontSize: 11, color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

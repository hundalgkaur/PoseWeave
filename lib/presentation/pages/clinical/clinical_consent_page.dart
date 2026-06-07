import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// HIPAA-style privacy/consent gate (UI-only mock). Both "Grant Access" and
/// "Restricted Demo Mode" proceed to the clinical home.
class ClinicalConsentPage extends StatelessWidget {
  const ClinicalConsentPage({super.key});

  static const List<String> _points = <String>[
    'All pose detection runs on-device; no video or images leave this device.',
    'No protected health information (PHI) is collected, stored, or transmitted '
        'by this demo.',
    'Measurements shown in millimetres are uncalibrated estimates derived from '
        '2D video and are not clinical measurements.',
    'This software is a technology demo and is not a medical device.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Center(
                      child: Icon(Icons.health_and_safety_outlined,
                          color: AppColors.primary, size: 44),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text('Privacy & Compliance',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text('Review before proceeding',
                          style: AppTheme.mono(
                              color: AppColors.onSurfaceVariant, fontSize: 12)),
                    ),
                    const SizedBox(height: 20),
                    for (final String p in _points)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Icon(Icons.check_circle_outline,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(p,
                                  style: AppTheme.mono(
                                      fontSize: 12,
                                      color: AppColors.onSurfaceVariant)),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.clinicalHome),
                      child: Text('GRANT ACCESS',
                          style: AppTheme.labelCaps(color: AppColors.onPrimary)),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.clinicalHome),
                      child: const Text('Restricted Demo Mode'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

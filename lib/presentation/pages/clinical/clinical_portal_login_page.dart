import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Clinical portal sign-in (UI-only mock — no clinical backend). "Authorize
/// Session" and the SSO/SmartCard buttons all proceed to the consent gate.
class ClinicalPortalLoginPage extends StatelessWidget {
  const ClinicalPortalLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Icon(Icons.local_hospital_outlined,
                        color: AppColors.primary, size: 44),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'PoseWeave Clinical',
                        style: text.headlineSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text('Diagnostic Portal · Authorized Use Only',
                          textAlign: TextAlign.center,
                          style: AppTheme.labelCaps(fontSize: 9)),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      style: const TextStyle(color: AppColors.onSurface),
                      decoration:
                          _decoration('Clinician ID', Icons.badge_outlined),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      obscureText: true,
                      style: const TextStyle(color: AppColors.onSurface),
                      decoration:
                          _decoration('Secure Token', Icons.vpn_key_outlined),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.clinicalConsent),
                      child: Text('AUTHORIZE SESSION',
                          style: AppTheme.labelCaps(color: AppColors.onPrimary)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(
                                    AppRoutes.clinicalConsent),
                            icon: const Icon(Icons.shield_outlined, size: 18),
                            label: const Text('SSO'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.of(context)
                                .pushReplacementNamed(
                                    AppRoutes.clinicalConsent),
                            icon: const Icon(Icons.credit_card, size: 18),
                            label: const Text('SmartCard'),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: AppColors.outlineVariant, height: 24),
                    Text(
                      'DEMO · Authentication is mocked. No clinical backend, '
                      'credentials, or PHI are processed.',
                      textAlign: TextAlign.center,
                      style: AppTheme.labelCaps(fontSize: 9),
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

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      prefixIcon: Icon(icon, color: AppColors.onSurfaceVariant),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}

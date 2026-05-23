import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/constants/auth_constants.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Gated login (no backend). Accepts only the hardcoded demo account, which is
/// shown on screen. On success, replaces the route with Home.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _signIn() {
    final bool ok =
        _email.text.trim() == AuthConstants.demoEmail &&
        _password.text == AuthConstants.demoPassword;
    if (ok) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      setState(
        () => _error = 'Invalid credentials. Use the demo account below.',
      );
    }
  }

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
                    const Icon(
                      Icons.accessibility_new,
                      color: AppColors.primary,
                      size: 44,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'PoseWeave',
                        style: text.headlineMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Sign in to continue',
                        style: AppTheme.mono(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      style: const TextStyle(color: AppColors.onSurface),
                      decoration: _decoration('Email', Icons.email_outlined),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _password,
                      obscureText: true,
                      style: const TextStyle(color: AppColors.onSurface),
                      onSubmitted: (_) => _signIn(),
                      decoration: _decoration('Password', Icons.lock_outline),
                    ),
                    if (_error != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: AppTheme.mono(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _signIn,
                      child: Text(
                        'SIGN IN',
                        style: AppTheme.labelCaps(color: AppColors.onPrimary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed:
                          () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.forgotPassword),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: AppColors.onSurfaceVariant),
                      ),
                    ),
                    const Divider(color: AppColors.outlineVariant, height: 24),
                    Text(
                      'DEMO ACCOUNT\n${AuthConstants.demoEmail} / ${AuthConstants.demoPassword}',
                      textAlign: TextAlign.center,
                      style: AppTheme.labelCaps(fontSize: 10),
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

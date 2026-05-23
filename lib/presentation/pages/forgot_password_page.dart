import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// UI-only password reset (no backend): submitting shows a generic confirmation.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: GlassPanel(
                padding: const EdgeInsets.all(24),
                child: _sent ? _confirmation(context) : _form(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          'Enter your email and we’ll send a reset link.',
          style: AppTheme.mono(color: AppColors.onSurfaceVariant, fontSize: 13),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          style: const TextStyle(color: AppColors.onSurface),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.onSurfaceVariant,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => setState(() => _sent = true),
          child: Text(
            'SEND RESET LINK',
            style: AppTheme.labelCaps(color: AppColors.onPrimary),
          ),
        ),
      ],
    );
  }

  Widget _confirmation(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.mark_email_read_outlined,
          color: AppColors.success,
          size: 40,
        ),
        const SizedBox(height: 16),
        Text(
          'If an account exists, a reset link has been sent.',
          textAlign: TextAlign.center,
          style: AppTheme.mono(color: AppColors.onSurface, fontSize: 13),
        ),
        const SizedBox(height: 20),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          child: const Text('Back to sign in'),
        ),
      ],
    );
  }
}

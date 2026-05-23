import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';

/// Masked API-key text field with a show/hide toggle.
class ApiKeyField extends StatefulWidget {
  const ApiKeyField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  State<ApiKeyField> createState() => _ApiKeyFieldState();
}

class _ApiKeyFieldState extends State<ApiKeyField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscure,
      autocorrect: false,
      enableSuggestions: false,
      style: const TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: 'Anthropic API key',
        hintText: 'sk-ant-…',
        labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
        prefixIcon: const Icon(Icons.key, color: AppColors.onSurfaceVariant),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure ? Icons.visibility : Icons.visibility_off,
            color: AppColors.onSurfaceVariant,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
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
    );
  }
}

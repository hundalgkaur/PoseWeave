import 'package:flutter/material.dart';

/// The "Cyber-Kinetic Precision" palette (design/cyber_kinetic_precision).
///
/// Deep obsidian surfaces with electric-cyan accents and glass tints. Semantic
/// green/amber/coral are reserved for bio-feedback only, never chrome.
class AppColors {
  const AppColors._();

  // Surfaces (tonal stacking creates depth instead of shadows).
  static const Color background = Color(0xFF0D1516);
  static const Color surface = Color(0xFF0D1516);
  static const Color surfaceContainerLowest = Color(0xFF080F11);
  static const Color surfaceContainerLow = Color(0xFF151D1E);
  static const Color surfaceContainer = Color(0xFF192122);
  static const Color surfaceContainerHigh = Color(0xFF242B2D);
  static const Color surfaceContainerHighest = Color(0xFF2E3638);
  static const Color surfaceVariant = Color(0xFF2E3638);

  // Accent (electric cyan).
  static const Color primary = Color(0xFFC3F5FF);
  static const Color primaryContainer = Color(0xFF00E5FF);
  static const Color onPrimary = Color(0xFF00363D);
  static const Color onPrimaryContainer = Color(0xFF00626E);
  static const Color surfaceTint = Color(0xFF00DAF3);

  // Text / lines.
  static const Color onSurface = Color(0xFFDCE4E5);
  static const Color onSurfaceVariant = Color(0xFFBAC9CC);
  static const Color outline = Color(0xFF849396);
  static const Color outlineVariant = Color(0xFF3B494C);

  // Semantic / bio-feedback.
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFEC931);

  /// Translucent fill for glass panels (used with a backdrop blur).
  static Color glassFill = surfaceContainer.withValues(alpha: 0.4);

  /// Hairline border for glass panels.
  static Color glassBorder = outlineVariant.withValues(alpha: 0.3);
}

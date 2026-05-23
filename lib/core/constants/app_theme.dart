import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poseweave/core/constants/app_colors.dart';

/// Builds the app-wide dark theme.
///
/// Inter carries all UI chrome; JetBrains Mono is reserved for live numeric
/// data (confidence, coordinates, FPS) so digits keep a fixed width and don't
/// jitter horizontally as values update. Use [mono] for that data.
class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    const ColorScheme scheme = ColorScheme.dark(
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.primaryContainer,
      onSecondary: AppColors.onPrimary,
      error: AppColors.error,
      onError: AppColors.onError,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    );

    final TextTheme baseText = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: baseText,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.onSurface,
      ),
    );
  }

  /// JetBrains Mono style for live metrics. Pass [color]/[fontSize]/[weight]
  /// to vary; defaults suit inline data labels.
  static TextStyle mono({
    double fontSize = 14,
    Color color = AppColors.onSurface,
    FontWeight weight = FontWeight.w500,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      color: color,
      fontWeight: weight,
      letterSpacing: letterSpacing,
    );
  }

  /// All-caps monospace label used for technical metadata (PRD `label-caps`).
  static TextStyle labelCaps({
    Color color = AppColors.onSurfaceVariant,
    double fontSize = 12,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    );
  }
}

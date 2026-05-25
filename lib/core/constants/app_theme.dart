import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:poseweave/core/constants/app_colors.dart';

/// Builds the app-wide dark theme ("Kinetic Precision").
///
/// Inter carries all UI chrome; JetBrains Mono is reserved for live numeric
/// data (confidence, coordinates, FPS, reps) so digits keep a fixed width and
/// don't jitter as values update. Use [mono] / [data] for that data.
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
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
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
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderStrong),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: AppColors.primaryContainer, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.18),
        elevation: 0,
        height: 72,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderSubtle),
        ),
      ),
      dividerColor: AppColors.borderSubtle,
    );
  }

  // --- Named Inter text styles (Kinetic Precision scale) -------------------
  static TextStyle displayXl({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 40, fontWeight: FontWeight.w700, height: 1.2, color: color);
  static TextStyle displayLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, height: 1.25, color: color);
  static TextStyle headingLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w600, height: 1.33, color: color);
  static TextStyle headingMd({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 20, fontWeight: FontWeight.w600, height: 1.4, color: color);
  static TextStyle headingSm({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, height: 1.5, color: color);
  static TextStyle bodyLg({Color color = AppColors.onSurface}) =>
      GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: color);
  static TextStyle bodyMd({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, height: 1.43, color: color);
  static TextStyle caption({Color color = AppColors.onSurfaceVariant}) =>
      GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w500, height: 1.33, color: color);

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

  /// Large mono telemetry readout (reps, primary metrics) — "data-xl".
  static TextStyle data({
    double fontSize = 32,
    Color color = AppColors.onSurface,
  }) =>
      GoogleFonts.jetBrainsMono(
          fontSize: fontSize, color: color, fontWeight: FontWeight.w500);

  /// All-caps monospace label used for technical metadata (`label-caps`).
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

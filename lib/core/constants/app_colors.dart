import 'package:flutter/material.dart';

/// The "Kinetic Precision" palette (Stitch design system).
///
/// Dark obsidian surfaces with electric-cyan accents and glass tints. Semantic
/// green/amber/coral are reserved for bio-feedback only, never chrome. Skeleton
/// region colors live in `PoseBones.regionColors` (already aligned).
class AppColors {
  const AppColors._();

  // Surfaces (tonal stacking creates depth instead of shadows).
  static const Color background = Color(0xFF131313);
  static const Color surface = Color(0xFF141414);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceVariant = Color(0xFF353534);

  /// Elevated interactive surface (hover/press, raised cards).
  static const Color surfaceElevated = Color(0xFF1C1C1C);

  // Accent (electric cyan).
  static const Color primary = Color(0xFFC3F5FF);
  static const Color primaryContainer = Color(0xFF00E5FF);
  static const Color onPrimary = Color(0xFF00363D);
  static const Color onPrimaryContainer = Color(0xFF00626E);
  static const Color surfaceTint = Color(0xFF00DAF3);

  // Secondary (mint) + info (blue) — used by data viz / status chips.
  static const Color secondary = Color(0xFF7DFFA2);
  static const Color onSecondary = Color(0xFF003918);
  static const Color info = Color(0xFF448AFF);

  // Text / lines.
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFBAC9CC);

  /// Dim text / borders. Lightened from the old #849396 (~4.2:1 on surface,
  /// failed WCAG AA for small text) to clear 4.5:1 when used for text.
  static const Color outline = Color(0xFF9FAEB1);
  static const Color outlineVariant = Color(0xFF3B494C);

  /// 1px panel/card borders (subtle) and stronger input/divider borders.
  static const Color borderSubtle = Color(0xFF1E1E1E);
  static const Color borderStrong = Color(0xFF2D2D2D);

  // Semantic / bio-feedback.
  static const Color error = Color(0xFFFF5252);
  static const Color onError = Color(0xFF690005);
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFEA00);

  /// Translucent fill for glass panels (used with a backdrop blur).
  static Color glassFill = surface.withValues(alpha: 0.55);

  /// Hairline border for glass panels.
  static const Color glassBorder = borderSubtle;

  /// Cyan glow used on active skeleton points and focused controls.
  static const List<BoxShadow> glow = <BoxShadow>[
    BoxShadow(color: Color(0x4D00E5FF), blurRadius: 16),
  ];
}

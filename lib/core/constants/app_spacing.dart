import 'package:flutter/widgets.dart';

/// The 4px-based spacing scale ("Kinetic Precision"). Use these instead of
/// hardcoding paddings/gaps so spacing stays consistent across screens.
class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double section = 32;

  /// Standard page padding (ListView/body) used by most screens.
  static const EdgeInsets page = EdgeInsets.all(xl);

  /// Page padding with a tighter top (dashboards under an app bar).
  static const EdgeInsets pageDashboard = EdgeInsets.fromLTRB(xl, sm, xl, xxl);
}

/// Corner-radius scale ("Kinetic Precision"). `sharp` (0) is reserved for the
/// live camera viewport to distinguish "real" video from UI chrome.
class AppRadius {
  const AppRadius._();

  static const double sharp = 0;
  static const double sm = 6;
  static const double md = 8;
  static const double lg = 12;
  static const double pill = 999;
}

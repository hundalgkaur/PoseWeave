/// Lightweight app-wide dev settings.
///
/// [mockMode] lets the home screen (triple-tap the logo) flip synthetic-pose
/// mode on, so detection can be exercised on an emulator where ML Kit can't
/// run. A freshly created [PoseBloc] reads this at construction, so the choice
/// applies to the next screen opened.
class AppSettings {
  const AppSettings._();

  static bool mockMode = false;
}

/// Backend base URL. Empty by default — the cloud features (sync, profile,
/// leaderboard) stay disabled and the app remains fully offline-first until a
/// URL is provided at build time:
///   flutter run --dart-define=POSEWEAVE_API=https://poseweave-api.onrender.com
class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'POSEWEAVE_API',
    defaultValue: '',
  );

  static bool get isConfigured => baseUrl.isNotEmpty;
}

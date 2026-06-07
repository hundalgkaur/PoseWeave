/// Named routes for the app. Kept in one place so navigation calls and the
/// route table can't drift apart.
class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String camera = '/camera';
  static const String gallery = '/gallery';
  static const String skeleton3d = '/skeleton3d';
  static const String gait = '/gait';
  static const String segments = '/segments';
  static const String image = '/image';
  static const String repCounter = '/reps';
  static const String poseCoach = '/pose-coach';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String analytics = '/analytics';
  static const String leaderboard = '/leaderboard';
  static const String sessionDetail = '/session';

  // Clinical / Diagnostic Mode.
  static const String clinicalLogin = '/clinical/login';
  static const String clinicalConsent = '/clinical/consent';
  static const String clinicalHome = '/clinical/home';
  static const String clinicalLive = '/clinical/live';
  static const String clinicalBiomechanical = '/clinical/biomechanical';
  static const String clinical3d = '/clinical/3d';
  static const String clinicalGait = '/clinical/gait';
}

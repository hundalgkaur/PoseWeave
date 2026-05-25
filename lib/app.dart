import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/pages/analytics_page.dart';
import 'package:poseweave/presentation/pages/camera_pose_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_3d_reconstruction_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_biomechanical_analysis_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_consent_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_gait_report_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_home_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_live_diagnostic_page.dart';
import 'package:poseweave/presentation/pages/clinical/clinical_portal_login_page.dart';
import 'package:poseweave/presentation/pages/forgot_password_page.dart';
import 'package:poseweave/presentation/pages/gait_analysis_page.dart';
import 'package:poseweave/presentation/pages/gallery_pose_page.dart';
import 'package:poseweave/presentation/pages/home_shell.dart';
import 'package:poseweave/presentation/pages/image_analysis_page.dart';
import 'package:poseweave/presentation/pages/leaderboard_page.dart';
import 'package:poseweave/presentation/pages/login_page.dart';
import 'package:poseweave/presentation/pages/onboarding_page.dart';
import 'package:poseweave/presentation/pages/pose_classifier_page.dart';
import 'package:poseweave/presentation/pages/profile_page.dart';
import 'package:poseweave/presentation/pages/register_page.dart';
import 'package:poseweave/presentation/pages/rep_counter_picker_page.dart';
import 'package:poseweave/presentation/pages/segment_dashboard_page.dart';
import 'package:poseweave/presentation/pages/session_detail_page.dart';
import 'package:poseweave/presentation/pages/settings_page.dart';
import 'package:poseweave/presentation/pages/skeleton_3d_page.dart';
import 'package:poseweave/presentation/pages/splash_page.dart';

/// Root widget: dark theme + named-route table. Each route builds its page;
/// the page itself provides its `PoseBloc` so the bloc disposes on pop.
class PoseWeaveApp extends StatelessWidget {
  const PoseWeaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PoseWeave',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      routes: <String, WidgetBuilder>{
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.onboarding: (_) => const OnboardingPage(),
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.register: (_) => const RegisterPage(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.analytics: (_) => const AnalyticsPage(),
        AppRoutes.leaderboard: (_) => const LeaderboardPage(),
        AppRoutes.sessionDetail: (_) => const SessionDetailPage(),
        AppRoutes.home: (_) => const HomeShell(),
        AppRoutes.camera: (_) => const CameraPosePage(),
        AppRoutes.gallery: (_) => const GalleryPosePage(),
        AppRoutes.gait: (_) => const GaitAnalysisPage(),
        AppRoutes.segments: (_) => const SegmentDashboardPage(),
        AppRoutes.image: (_) => const ImageAnalysisPage(),
        AppRoutes.repCounter: (_) => const RepCounterPickerPage(),
        AppRoutes.poseCoach: (_) => const PoseClassifierPage(),
        AppRoutes.settings: (_) => const SettingsPage(),
        AppRoutes.profile: (_) => const ProfilePage(),
        AppRoutes.clinicalLogin: (_) => const ClinicalPortalLoginPage(),
        AppRoutes.clinicalConsent: (_) => const ClinicalConsentPage(),
        AppRoutes.clinicalHome: (_) => const ClinicalHomePage(),
        AppRoutes.clinicalLive: (_) => const ClinicalLiveDiagnosticPage(),
        AppRoutes.clinicalBiomechanical: (_) =>
            const ClinicalBiomechanicalAnalysisPage(),
        AppRoutes.clinicalGait: (_) => const ClinicalGaitReportPage(),
        AppRoutes.clinical3d: (_) {
          final List<PoseEntity> recent = getIt<PoseRepository>().recentPoses;
          return Clinical3DReconstructionPage(
            pose: recent.isEmpty ? null : recent.last,
          );
        },
        AppRoutes.skeleton3d: (_) {
          // Show the most recent detected pose if there is one; otherwise the
          // 3D page falls back to its built-in sample pose.
          final List<PoseEntity> recent = getIt<PoseRepository>().recentPoses;
          return Skeleton3DPage(pose: recent.isEmpty ? null : recent.last);
        },
      },
    );
  }
}

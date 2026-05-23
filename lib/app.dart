import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/pages/camera_pose_page.dart';
import 'package:poseweave/presentation/pages/forgot_password_page.dart';
import 'package:poseweave/presentation/pages/gait_analysis_page.dart';
import 'package:poseweave/presentation/pages/gallery_pose_page.dart';
import 'package:poseweave/presentation/pages/home_page.dart';
import 'package:poseweave/presentation/pages/image_analysis_page.dart';
import 'package:poseweave/presentation/pages/login_page.dart';
import 'package:poseweave/presentation/pages/onboarding_page.dart';
import 'package:poseweave/presentation/pages/segment_dashboard_page.dart';
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
        AppRoutes.forgotPassword: (_) => const ForgotPasswordPage(),
        AppRoutes.home: (_) => const HomePage(),
        AppRoutes.camera: (_) => const CameraPosePage(),
        AppRoutes.gallery: (_) => const GalleryPosePage(),
        AppRoutes.gait: (_) => const GaitAnalysisPage(),
        AppRoutes.segments: (_) => const SegmentDashboardPage(),
        AppRoutes.image: (_) => const ImageAnalysisPage(),
        AppRoutes.settings: (_) => const SettingsPage(),
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

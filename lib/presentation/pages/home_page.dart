import 'package:flutter/material.dart';
import 'package:poseweave/core/app_settings.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/mode_selector_card.dart';

/// Entry screen: pick a detection mode. Triple-tapping the logo toggles mock
/// mode for emulator testing (see [AppSettings]).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _logoTaps = 0;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  void _onLogoTap() {
    final DateTime now = DateTime.now();
    _logoTaps =
        now.difference(_lastTap) < const Duration(seconds: 1)
            ? _logoTaps + 1
            : 1;
    _lastTap = now;
    if (_logoTaps >= 3) {
      _logoTaps = 0;
      setState(() => AppSettings.mockMode = !AppSettings.mockMode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mock mode ${AppSettings.mockMode ? 'ON' : 'OFF'}',
            style: AppTheme.mono(color: AppColors.onPrimary),
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                tooltip: 'Sign out',
                icon: const Icon(
                  Icons.logout,
                  color: AppColors.onSurfaceVariant,
                ),
                onPressed:
                    () => Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _Logo(onTap: _onLogoTap),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Select Mode',
                          style: text.displaySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Initialize biometric tracking sequence',
                          style: AppTheme.mono(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      ModeSelectorCard(
                        icon: Icons.videocam,
                        title: 'Live Camera',
                        subtitle: 'Real-time 2D skeleton detection',
                        active: true,
                        onTap:
                            () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.camera),
                      ),
                      const SizedBox(height: 16),
                      ModeSelectorCard(
                        icon: Icons.movie_outlined,
                        title: 'Video Analysis',
                        subtitle: 'Upload video for frame-by-frame extraction',
                        onTap:
                            () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.gallery),
                      ),
                      const SizedBox(height: 16),
                      ModeSelectorCard(
                        icon: Icons.view_in_ar,
                        title: '3D Skeleton',
                        subtitle: 'View pose in 3D space with rotation',
                        badge: 'BETA',
                        onTap:
                            () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.skeleton3d),
                      ),
                      const SizedBox(height: 16),
                      ModeSelectorCard(
                        icon: Icons.directions_walk,
                        title: 'Gait Analysis',
                        subtitle: 'Walking metrics from a video',
                        onTap:
                            () =>
                                Navigator.of(context).pushNamed(AppRoutes.gait),
                      ),
                      const SizedBox(height: 16),
                      ModeSelectorCard(
                        icon: Icons.image_search,
                        title: 'Image Analysis',
                        subtitle: 'Detect pose from a single image',
                        onTap:
                            () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.image),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Version 1.0 • On-device ML Kit',
                          style: AppTheme.labelCaps(fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Icon(
            Icons.accessibility_new,
            color: AppColors.primary,
            size: 44,
          ),
        ),
      ),
    );
  }
}

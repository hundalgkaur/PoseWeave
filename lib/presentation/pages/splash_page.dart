import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// Brief branded launch screen: a glowing cyan figure on obsidian that fades
/// in, then hands off to the home screen.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    _navTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CurvedAnimation curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(curve),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.35,
                        ),
                        blurRadius: 32,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.accessibility_new,
                    color: AppColors.primary,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'PoseWeave',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'REAL-TIME POSE INTELLIGENCE',
                  style: AppTheme.labelCaps(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poseweave/core/app_settings.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Home dashboard (Kinetic Precision). A greeting, an active-streak card, a
/// feature grid that launches every mode, and a weekly stats card — with a
/// 5-item bottom nav (Home / Camera / Analytics / Rank / Profile) matching the
/// Stitch mockup. The grid keeps every feature reachable (nothing dropped).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Hidden mock-mode toggle (Home title triple-tap), kept from before.
  int _titleTaps = 0;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  void _onTitleTap() {
    final DateTime now = DateTime.now();
    _titleTaps =
        now.difference(_lastTap) < const Duration(seconds: 1) ? _titleTaps + 1 : 1;
    _lastTap = now;
    if (_titleTaps >= 3) {
      _titleTaps = 0;
      setState(() => AppSettings.mockMode = !AppSettings.mockMode);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mock mode ${AppSettings.mockMode ? 'ON' : 'OFF'}',
              style: AppTheme.mono(color: AppColors.onPrimary)),
          backgroundColor: AppColors.primaryContainer,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'PoseWeave', onTitleTap: _onTitleTap),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Text('Welcome back', style: AppTheme.headingLg()),
            Text('Train with real-time pose intelligence',
                style: AppTheme.bodyMd()),
            const SizedBox(height: 16),
            const _StreakCard(),
            const SizedBox(height: 20),
            Text('QUICK ACTIONS', style: AppTheme.labelCaps()),
            const SizedBox(height: 12),
            const _FeatureGrid(),
            const SizedBox(height: 20),
            const _WeekCard(),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.local_fire_department,
                  color: AppColors.warning, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('ACTIVE STREAK · DEMO',
                  style: AppTheme.labelCaps(fontSize: 9)),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Text('12',
                      style: AppTheme.data(
                          fontSize: 32, color: AppColors.primary)),
                  const SizedBox(width: 4),
                  Text('days', style: AppTheme.bodyMd()),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text('GOAL\n14d',
              textAlign: TextAlign.right,
              style: AppTheme.labelCaps(fontSize: 9)),
        ],
      ),
    );
  }
}

/// Every mode, as a 2-column grid of tiles (keeps all features reachable).
class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const List<({IconData icon, String title, String route})> _items =
      <({IconData icon, String title, String route})>[
    (icon: Icons.videocam, title: 'Live Camera', route: AppRoutes.camera),
    (icon: Icons.straighten, title: 'Segments', route: AppRoutes.segments),
    (icon: Icons.fitness_center, title: 'Rep Counter', route: AppRoutes.repCounter),
    (icon: Icons.self_improvement, title: 'Pose Coach', route: AppRoutes.poseCoach),
    (icon: Icons.movie_outlined, title: 'Video Analysis', route: AppRoutes.gallery),
    (icon: Icons.directions_walk, title: 'Gait', route: AppRoutes.gait),
    (icon: Icons.image_search, title: 'Image', route: AppRoutes.image),
    (icon: Icons.view_in_ar, title: '3D Skeleton', route: AppRoutes.skeleton3d),
    (icon: Icons.local_hospital_outlined, title: 'Diagnostic', route: AppRoutes.clinicalLogin),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: <Widget>[
        for (final ({IconData icon, String title, String route}) i in _items)
          _DashTile(icon: i.icon, title: i.title, route: i.route),
      ],
    );
  }
}

class _DashTile extends StatelessWidget {
  const _DashTile({required this.icon, required this.title, required this.route});
  final IconData icon;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(route),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon, color: AppColors.primaryContainer, size: 26),
            Text(title, style: AppTheme.headingSm()),
          ],
        ),
      ),
    );
  }
}

class _WeekCard extends StatelessWidget {
  const _WeekCard();

  static const List<int> _week = <int>[60, 0, 80, 95, 40, 88, 70];
  static const List<String> _days = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('THIS WEEK · DEMO', style: AppTheme.labelCaps()),
              const Spacer(),
              Text('Avg 85%',
                  style: AppTheme.mono(color: AppColors.primary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                for (int i = 0; i < _week.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                heightFactor: _week[i] / 100,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(_days[i], style: AppTheme.labelCaps(fontSize: 9)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 5-item bottom nav per the mockup. Home stays selected; the others push their
/// routes (so the camera/analytics/etc. dispose cleanly on pop).
class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (int i) {
        switch (i) {
          case 1:
            Navigator.of(context).pushNamed(AppRoutes.camera);
          case 2:
            Navigator.of(context).pushNamed(AppRoutes.analytics);
          case 3:
            Navigator.of(context).pushNamed(AppRoutes.leaderboard);
          case 4:
            Navigator.of(context).pushNamed(AppRoutes.profile);
        }
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: AppColors.primary), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.videocam_outlined), label: 'Camera'),
        NavigationDestination(icon: Icon(Icons.query_stats), label: 'Analytics'),
        NavigationDestination(icon: Icon(Icons.leaderboard_outlined), label: 'Rank'),
        NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

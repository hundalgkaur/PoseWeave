import 'package:flutter/material.dart';
import 'package:poseweave/core/app_settings.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/mode_selector_card.dart';

/// Root screen after login: a bottom-tab shell that groups the modes into
/// **Live / Analyze / 3D / Clinical** hubs. Each hub is a list of cards that
/// push the existing mode routes on top (the bottom bar hides there, matching
/// the design). Triple-tapping the title toggles mock mode for emulator work.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  // Hidden mock-mode toggle (was the Home logo triple-tap).
  int _titleTaps = 0;
  DateTime _lastTap = DateTime.fromMillisecondsSinceEpoch(0);

  static const List<String> _titles = <String>[
    'Live',
    'Analyze',
    '3D',
    'Clinical',
  ];

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
    return Scaffold(
      appBar: AppTopBar(title: 'PoseWeave · ${_titles[_index]}', onTitleTap: _onTitleTap),
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const <Widget>[
            _LiveTab(),
            _AnalyzeTab(),
            _ThreeDTab(),
            _ClinicalTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.surfaceContainerLowest,
          indicatorColor: AppColors.primaryContainer.withValues(alpha: 0.18),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => AppTheme.labelCaps(
              fontSize: 10,
              color: states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.onSurfaceVariant,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (int i) => setState(() => _index = i),
          // Always show all four labels so the Clinical tab is identifiable
          // (icons alone read as ambiguous, and the label was getting lost).
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 72,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.videocam_outlined),
              selectedIcon: Icon(Icons.videocam, color: AppColors.primary),
              label: 'Live',
            ),
            NavigationDestination(
              icon: Icon(Icons.movie_outlined),
              selectedIcon: Icon(Icons.movie, color: AppColors.primary),
              label: 'Analyze',
            ),
            NavigationDestination(
              icon: Icon(Icons.view_in_ar_outlined),
              selectedIcon: Icon(Icons.view_in_ar, color: AppColors.primary),
              label: '3D',
            ),
            NavigationDestination(
              icon: Icon(Icons.medical_services_outlined),
              selectedIcon:
                  Icon(Icons.medical_services, color: AppColors.primary),
              label: 'Clinical',
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared hub layout: a short header + a list of mode cards.
class _Hub extends StatelessWidget {
  const _Hub({required this.subtitle, required this.cards});
  final String subtitle;
  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: <Widget>[
        Text(subtitle, style: AppTheme.mono(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 20),
        for (int i = 0; i < cards.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 16),
          cards[i],
        ],
      ],
    );
  }
}

class _LiveTab extends StatelessWidget {
  const _LiveTab();

  @override
  Widget build(BuildContext context) {
    return _Hub(
      subtitle: 'Real-time detection from the camera',
      cards: <Widget>[
        ModeSelectorCard(
          icon: Icons.videocam,
          title: 'Live Camera',
          subtitle: 'Real-time 2D skeleton detection',
          active: true,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
        ),
        ModeSelectorCard(
          icon: Icons.straighten,
          title: 'Segment Analysis',
          subtitle: 'Live per-limb angle classification',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.segments),
        ),
      ],
    );
  }
}

class _AnalyzeTab extends StatelessWidget {
  const _AnalyzeTab();

  @override
  Widget build(BuildContext context) {
    return _Hub(
      subtitle: 'Analyze a video or image from your gallery',
      cards: <Widget>[
        ModeSelectorCard(
          icon: Icons.movie_outlined,
          title: 'Video Analysis',
          subtitle: 'Frame-by-frame pose extraction',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.gallery),
        ),
        ModeSelectorCard(
          icon: Icons.directions_walk,
          title: 'Gait Analysis',
          subtitle: 'Walking metrics from a video',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.gait),
        ),
        ModeSelectorCard(
          icon: Icons.image_search,
          title: 'Image Analysis',
          subtitle: 'Detect pose from a single image',
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.image),
        ),
      ],
    );
  }
}

class _ThreeDTab extends StatelessWidget {
  const _ThreeDTab();

  @override
  Widget build(BuildContext context) {
    return _Hub(
      subtitle: 'View a pose in 3D space',
      cards: <Widget>[
        ModeSelectorCard(
          icon: Icons.view_in_ar,
          title: '3D Skeleton',
          subtitle: 'Rotate & zoom the most recent pose',
          badge: 'BETA',
          active: true,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.skeleton3d),
        ),
      ],
    );
  }
}

class _ClinicalTab extends StatelessWidget {
  const _ClinicalTab();

  @override
  Widget build(BuildContext context) {
    return _Hub(
      subtitle: 'Clinical suite (demo) — gated by a mock portal',
      cards: <Widget>[
        ModeSelectorCard(
          icon: Icons.local_hospital_outlined,
          title: 'Diagnostic Suite',
          subtitle: 'Live, biomechanics, 3D & gait under clinical chrome',
          badge: 'CLINICAL',
          active: true,
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.clinicalLogin),
        ),
      ],
    );
  }
}

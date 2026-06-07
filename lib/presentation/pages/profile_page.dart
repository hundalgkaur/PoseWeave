import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Profile & Settings — matches the Stitch mockup: avatar header + tier badge,
/// a 4-metric stat row, grouped settings entries, About, and Sign Out. Stats
/// are demo values (cloud sync wired later); the Settings entry opens the real
/// BYOK key screen.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Profile'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const _Header(),
            const SizedBox(height: 16),
            const _StatsRow(),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text('DEMO DATA', style: AppTheme.labelCaps(fontSize: 9)),
            ),
            const SizedBox(height: 14),
            Text('TRAINING', style: AppTheme.labelCaps()),
            const SizedBox(height: 8),
            _Tile(
              icon: Icons.query_stats,
              title: 'Analytics',
              subtitle: 'Sessions, reps, weekly trends',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.analytics),
            ),
            _Tile(
              icon: Icons.leaderboard,
              title: 'Leaderboard',
              subtitle: 'Weekly rankings',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.leaderboard),
            ),
            const SizedBox(height: 16),
            Text('SETTINGS', style: AppTheme.labelCaps()),
            const SizedBox(height: 8),
            _Tile(
              icon: Icons.key,
              title: 'AI & API Key',
              subtitle: 'BYOK key for recommendations',
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.settings),
            ),
            _Tile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Alerts, daily reminders',
              onTap: () => _soon(context),
            ),
            _Tile(
              icon: Icons.shield_outlined,
              title: 'Privacy',
              subtitle: 'Telemetry sharing, permissions',
              onTap: () => _soon(context),
            ),
            _Tile(
              icon: Icons.palette_outlined,
              title: 'Appearance',
              subtitle: 'Theme, skeleton overlays',
              onTap: () => _soon(context),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('Version 2.4.1 (Build 890)',
                  style: AppTheme.labelCaps(fontSize: 9)),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.login, (Route<dynamic> r) => false),
              icon: const Icon(Icons.logout, color: AppColors.error),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              label: const Text('SIGN OUT'),
            ),
          ],
        ),
      ),
    );
  }

  static void _soon(BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coming soon')),
      );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Row(
        children: <Widget>[
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Icon(Icons.person, color: AppColors.primary, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Alex Vance', style: AppTheme.headingMd()),
                Text('alex.vance@poseweave.io', style: AppTheme.bodyMd()),
                const SizedBox(height: 6),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Text('PRO · BETA',
                        style: AppTheme.labelCaps(
                            color: AppColors.primary, fontSize: 9)),
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

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        Expanded(child: _Stat(label: 'SESSIONS', value: '342')),
        SizedBox(width: 8),
        Expanded(child: _Stat(label: 'HOURS', value: '1,024')),
        SizedBox(width: 8),
        Expanded(child: _Stat(label: 'ACCURACY', value: '94%')),
        SizedBox(width: 8),
        Expanded(child: _Stat(label: 'STREAK', value: '12d')),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        children: <Widget>[
          Text(value, style: AppTheme.data(fontSize: 18, color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.labelCaps(fontSize: 8)),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassPanel(
        padding: const EdgeInsets.all(14),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: AppTheme.headingSm()),
                    Text(subtitle, style: AppTheme.bodyMd()),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

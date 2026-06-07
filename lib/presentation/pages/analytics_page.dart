import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Analytics overview — training totals, weekly activity, recent sessions.
/// UI shell with demo data; real analytics (cloud `analyticsSummary`) wired later.
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  // Demo weekly rep counts (Mon..Sun).
  static const List<int> _week = <int>[24, 0, 38, 52, 12, 64, 30];
  static const List<String> _days = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Analytics'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text('DEMO DATA', style: AppTheme.labelCaps(fontSize: 9)),
            const SizedBox(height: 12),
            const Row(
              children: <Widget>[
                Expanded(child: _StatCard(label: 'SESSIONS', value: '42')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'TOTAL REPS', value: '1.2k')),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: <Widget>[
                Expanded(child: _StatCard(label: 'STREAK', value: '7d')),
                SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'AVG FORM', value: '88%')),
              ],
            ),
            const SizedBox(height: 16),
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('THIS WEEK', style: AppTheme.labelCaps()),
                  const SizedBox(height: 16),
                  const SizedBox(height: 120, child: _WeekBars(week: _week, days: _days)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('RECENT SESSIONS', style: AppTheme.labelCaps()),
            const SizedBox(height: 8),
            for (int i = 0; i < 4; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SessionRow(
                  title: <String>['Squats', 'Push-ups', 'Gait walk', 'Bicep curls'][i],
                  subtitle: '${<int>[32, 20, 0, 24][i]} reps · ${<String>['2m', '3m', '1m', '2m'][i]}',
                  onTap: () =>
                      Navigator.of(context).pushNamed(AppRoutes.sessionDetail),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: AppTheme.labelCaps(fontSize: 9)),
          const SizedBox(height: 6),
          Text(value, style: AppTheme.data(fontSize: 28, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.week, required this.days});
  final List<int> week;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    final int peak = week.reduce((int a, int b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < week.length; i++)
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
                        heightFactor: peak == 0 ? 0 : week[i] / peak,
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
                  Text(days[i], style: AppTheme.labelCaps(fontSize: 9)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            const Icon(Icons.fitness_center, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
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
    );
  }
}

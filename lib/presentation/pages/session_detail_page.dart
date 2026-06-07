import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Session deep-dive — per-session summary metrics + per-set breakdown.
/// UI shell with demo data; real session data wired later.
class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({super.key, this.title = 'Squats Session'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Session'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(title, style: AppTheme.headingLg()),
            const SizedBox(height: 2),
            Text('Today · 2m 14s · DEMO DATA', style: AppTheme.bodyMd()),
            const SizedBox(height: 16),
            const Row(
              children: <Widget>[
                Expanded(child: _Metric(label: 'REPS', value: '32')),
                SizedBox(width: 12),
                Expanded(child: _Metric(label: 'GOOD FORM', value: '88%')),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: <Widget>[
                Expanded(child: _Metric(label: 'TEMPO', value: '2.1s')),
                SizedBox(width: 12),
                Expanded(child: _Metric(label: 'PEAK ANGLE', value: '92°')),
              ],
            ),
            const SizedBox(height: 16),
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('SETS', style: AppTheme.labelCaps()),
                  const SizedBox(height: 12),
                  for (int i = 1; i <= 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: <Widget>[
                          Text('Set $i',
                              style: AppTheme.bodyLg(color: AppColors.onSurface)),
                          const Spacer(),
                          Text('${<int>[12, 10, 10][i - 1]} reps',
                              style: AppTheme.mono(color: AppColors.primary)),
                          const SizedBox(width: 12),
                          _FormDot(
                              quality: <String>['good', 'good', 'partial'][i - 1]),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('PDF'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('SHARE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});
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
          Text(value, style: AppTheme.data(fontSize: 26, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _FormDot extends StatelessWidget {
  const _FormDot({required this.quality});
  final String quality;

  @override
  Widget build(BuildContext context) {
    final Color c = quality == 'good'
        ? AppColors.success
        : (quality == 'partial' ? AppColors.warning : AppColors.error);
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
  }
}

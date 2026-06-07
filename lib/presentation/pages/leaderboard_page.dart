import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Weekly leaderboard — UI shell with demo rankings; the cloud
/// `weeklyLeaderboard` feed is wired later.
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String _exercise = 'Squats';

  static const Map<String, List<(String, int)>> _data =
      <String, List<(String, int)>>{
    'Squats': <(String, int)>[
      ('Aria K.', 412),
      ('Marcus T.', 388),
      ('You', 356),
      ('Lena P.', 340),
      ('Devon R.', 295),
    ],
    'Push-ups': <(String, int)>[
      ('Marcus T.', 520),
      ('You', 460),
      ('Aria K.', 401),
      ('Sam W.', 350),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<(String, int)> rows = _data[_exercise] ?? const <(String, int)>[];
    return Scaffold(
      appBar: const AppTopBar(title: 'Leaderboard'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text('WEEKLY · DEMO DATA', style: AppTheme.labelCaps(fontSize: 9)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'Squats', label: Text('Squats')),
                ButtonSegment<String>(value: 'Push-ups', label: Text('Push-ups')),
              ],
              selected: <String>{_exercise},
              onSelectionChanged: (Set<String> s) =>
                  setState(() => _exercise = s.first),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < rows.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _RankRow(
                  rank: i + 1,
                  name: rows[i].$1,
                  score: rows[i].$2,
                  isYou: rows[i].$1 == 'You',
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.name,
    required this.score,
    required this.isYou,
  });
  final int rank;
  final String name;
  final int score;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final Color accent = rank == 1
        ? AppColors.warning
        : (isYou ? AppColors.primaryContainer : AppColors.onSurfaceVariant);
    return GlassPanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderColor: isYou ? AppColors.primaryContainer : null,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 28,
            child: Text('$rank',
                style: AppTheme.data(fontSize: 18, color: accent)),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.surfaceContainerHigh,
            child: Text(name.substring(0, 1),
                style: AppTheme.labelCaps(color: AppColors.onSurface)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: AppTheme.headingSm(
                    color: isYou ? AppColors.primary : AppColors.onSurface)),
          ),
          Text('$score', style: AppTheme.data(fontSize: 16)),
          const SizedBox(width: 4),
          Text('reps', style: AppTheme.labelCaps(fontSize: 9)),
        ],
      ),
    );
  }
}

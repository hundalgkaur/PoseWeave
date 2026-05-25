import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/presentation/pages/rep_counter_live_page.dart';
import 'package:poseweave/presentation/pages/rep_counter_video_page.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Entry for the rep counter: pick a source (live camera or an uploaded clip),
/// then an exercise. Picking an exercise pushes the matching screen.
class RepCounterPickerPage extends StatefulWidget {
  const RepCounterPickerPage({super.key});

  @override
  State<RepCounterPickerPage> createState() => _RepCounterPickerPageState();
}

class _RepCounterPickerPageState extends State<RepCounterPickerPage> {
  bool _live = true;

  IconData _iconFor(Exercise e) {
    switch (e) {
      case Exercise.squat:
        return Icons.airline_seat_legroom_reduced;
      case Exercise.pushup:
        return Icons.fitness_center;
      case Exercise.situp:
        return Icons.airline_seat_flat;
      case Exercise.bicepCurl:
        return Icons.sports_gymnastics;
      case Exercise.jumpingJack:
        return Icons.accessibility_new;
    }
  }

  void _open(Exercise exercise) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _live
            ? RepCounterLivePage(exercise: exercise)
            : RepCounterVideoPage(exercise: exercise),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Rep Counter'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: <Widget>[
            Text('Choose an exercise', style: AppTheme.headingLg()),
            Text('Counted live from the camera or from an uploaded clip',
                style: AppTheme.bodyMd()),
            const SizedBox(height: 16),
            Text('SOURCE', style: AppTheme.labelCaps()),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: true,
                  label: Text('Live'),
                  icon: Icon(Icons.videocam_outlined),
                ),
                ButtonSegment<bool>(
                  value: false,
                  label: Text('Video'),
                  icon: Icon(Icons.movie_outlined),
                ),
              ],
              selected: <bool>{_live},
              onSelectionChanged: (Set<bool> s) =>
                  setState(() => _live = s.first),
            ),
            const SizedBox(height: 20),
            Text('EXERCISE', style: AppTheme.labelCaps()),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: <Widget>[
                for (final Exercise e in Exercise.values)
                  _ExerciseTile(
                    icon: _iconFor(e),
                    label: e.label,
                    onTap: () => _open(e),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: AppColors.primaryContainer, size: 24),
              ),
            ),
            Text(label, style: AppTheme.headingSm()),
          ],
        ),
      ),
    );
  }
}

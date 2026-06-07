import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/pages/pose_classifier_page.dart';
import 'package:poseweave/presentation/pages/pose_classifier_video_page.dart';
import 'package:poseweave/presentation/pages/pose_match_picker_page.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Pose Coach entry: pick a source — match a pose **live** from the camera, or
/// **record/pick a clip** and see which pose it matched. Mirrors the rep-counter
/// picker.
class PoseClassifierPickerPage extends StatelessWidget {
  const PoseClassifierPickerPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Pose Coach'),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.pageDashboard,
          children: <Widget>[
            Text('Match a yoga pose', style: AppTheme.headingLg()),
            Text('Hold a pose for the live camera, or analyze a recorded clip',
                style: AppTheme.bodyMd()),
            const SizedBox(height: AppSpacing.xl),
            _SourceCard(
              icon: Icons.videocam_outlined,
              title: 'Live',
              subtitle: 'Match in real time as you hold each pose',
              onTap: () => _open(context, const PoseClassifierPage()),
            ),
            const SizedBox(height: AppSpacing.md),
            _SourceCard(
              icon: Icons.movie_outlined,
              title: 'Video',
              subtitle: 'Pick or record a clip, then see the matched pose',
              onTap: () => _open(context, const PoseClassifierVideoPage()),
            ),
            const SizedBox(height: AppSpacing.md),
            _SourceCard(
              icon: Icons.center_focus_strong_outlined,
              title: 'Match a target',
              subtitle: 'Load a pose (or your own photo) and match it live',
              onTap: () => _open(context, const PoseMatchPickerPage()),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  const _SourceCard({
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
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Icon(icon, color: AppColors.primaryContainer, size: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: AppTheme.headingSm()),
                    const SizedBox(height: 2),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/constants/pose_templates.dart';
import 'package:poseweave/core/utils/pose_guide_builder.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_template.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/pages/pose_match_page.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

/// A representative icon per pose name (the "preloaded image", like the rep
/// counter's exercise tiles). Bundled photos can replace these later by setting
/// `PoseTemplate.imageAsset`.
IconData poseIconFor(String name) {
  switch (name) {
    case 'Warrior I':
    case 'Warrior II':
      return Icons.sports_martial_arts;
    case 'Tree':
      return Icons.park;
    case 'Chair':
      return Icons.chair_alt;
    case 'Forward Fold':
      return Icons.airline_seat_legroom_reduced;
    case 'Cactus Arms':
      return Icons.fitness_center;
    case 'Deep Squat':
      return Icons.airline_seat_legroom_extra;
    case 'Triangle':
      return Icons.change_history;
    case 'Prayer':
    case 'Mountain':
      return Icons.self_improvement;
    case 'Standing Side Bend':
      return Icons.accessibility;
    default:
      return Icons.accessibility_new;
  }
}

/// Pick a target pose to match: a grid of preset poses (icon + name) plus an
/// "Upload reference image" tile that detects the pose in a chosen photo and
/// matches the user against it. Mirrors `rep_counter_picker_page.dart`.
class PoseMatchPickerPage extends StatelessWidget {
  const PoseMatchPickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create: (_) => getIt<PoseBloc>(),
      child: const _PickerView(),
    );
  }
}

class _PickerView extends StatelessWidget {
  const _PickerView();

  void _openPreset(BuildContext context, PoseTemplate t) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PoseMatchPage(
          label: t.name,
          icon: poseIconFor(t.name),
          template: t,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<PoseTemplate> targets = uniquePoseTargets();
    return Scaffold(
      appBar: const AppTopBar(title: 'Match a Target'),
      body: SafeArea(
        child: BlocListener<PoseBloc, PoseState>(
          listener: (BuildContext context, PoseState state) {
            if (state is PoseImageComplete) {
              final PoseEntity? pose = state.pose;
              if (pose == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No person found in that image. '
                        'Pick a clear, full-body pose photo.'),
                  ),
                );
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PoseMatchPage(
                    label: 'Reference',
                    icon: Icons.image_outlined,
                    referencePose: pose,
                    referenceImagePath: state.imagePath,
                  ),
                ),
              );
            } else if (state is PoseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: ListView(
            padding: AppSpacing.pageDashboard,
            children: <Widget>[
              Text('Choose a pose to match', style: AppTheme.headingLg()),
              Text('Hold the target — your live match % is scored against it',
                  style: AppTheme.bodyMd()),
              const SizedBox(height: AppSpacing.lg),
              _UploadTile(
                onTap: () => context
                    .read<PoseBloc>()
                    .add(const PoseEvent.pickAndAnalyzeImage()),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('PRESET POSES', style: AppTheme.labelCaps()),
              const SizedBox(height: AppSpacing.md),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.82,
                children: <Widget>[
                  for (final PoseTemplate t in targets)
                    _PoseTile(
                      name: t.name,
                      template: t,
                      onTap: () => _openPreset(context, t),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      borderColor: AppColors.primaryContainer.withValues(alpha: 0.5),
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
                child: const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: AppColors.primaryContainer, size: 24),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Upload reference image', style: AppTheme.headingSm()),
                    const SizedBox(height: 2),
                    Text('Match against any pose photo from your gallery',
                        style: AppTheme.bodyMd()),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _PoseTile extends StatelessWidget {
  const _PoseTile({
    required this.name,
    required this.template,
    required this.onTap,
  });
  final String name;
  final PoseTemplate template;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // The actual pose shape (guide skeleton), not a generic icon.
            Expanded(
              child: CustomPaint(
                painter: PoseOverlayPainter(
                  landmarks: PoseGuideBuilder.build(template).landmarks,
                  imageSize: const Size(1, 1),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(name, style: AppTheme.headingSm(), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

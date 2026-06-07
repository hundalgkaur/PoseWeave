import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_classifier_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/pose_match_panel.dart';

/// Record-and-match: reuses `PoseBloc`'s `pickAndAnalyzeVideo` pipeline, then
/// folds the resulting poses through the `PoseClassifier` (via
/// `PoseClassifierBloc.analyzeVideoPoses`) to report the dominant matched pose.
/// Mirrors `rep_counter_video_page.dart`.
class PoseClassifierVideoPage extends StatelessWidget {
  const PoseClassifierVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeVideo()),
        ),
        BlocProvider<PoseClassifierBloc>(
          create: (_) => getIt<PoseClassifierBloc>(),
        ),
      ],
      child: const _CoachVideoView(),
    );
  }
}

class _CoachVideoView extends StatelessWidget {
  const _CoachVideoView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Pose Coach · Video'),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.page,
          child: BlocConsumer<PoseBloc, PoseState>(
            listener: (BuildContext context, PoseState state) {
              if (state is PoseVideoComplete) {
                if (state.poses.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No human detected in that clip. Try a clearer, '
                        'full-body video.',
                      ),
                    ),
                  );
                  return;
                }
                context
                    .read<PoseClassifierBloc>()
                    .add(PoseClassifierEvent.analyzeVideoPoses(state.poses));
              } else if (state is PoseError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            builder: (BuildContext context, PoseState state) {
              if (state is PoseVideoProcessing) {
                return _Processing(
                  progress: state.progress,
                  frame: state.framesProcessed,
                );
              }
              return BlocBuilder<PoseClassifierBloc, PoseClassifierState>(
                builder: (BuildContext context, PoseClassifierState cs) {
                  if (cs is PoseClassifierSummary) {
                    return _Summary(
                      result: cs.result,
                      onPickAnother: () => context
                          .read<PoseBloc>()
                          .add(const PoseEvent.pickAndAnalyzeVideo()),
                    );
                  }
                  return _Prompt(
                    onPick: () => context
                        .read<PoseBloc>()
                        .add(const PoseEvent.pickAndAnalyzeVideo()),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.result, required this.onPickAnother});
  final PoseMatchResult result;
  final VoidCallback onPickAnother;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Text('BEST MATCH', style: AppTheme.labelCaps()),
        const SizedBox(height: AppSpacing.sm),
        PoseMatchPanel(result: result),
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: onPickAnother,
          icon: const Icon(Icons.video_library_outlined),
          label: const Text('ANALYZE ANOTHER CLIP'),
        ),
      ],
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.onPick});
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPick,
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.self_improvement,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Select a pose video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Full body in frame, hold the pose for a moment',
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('TAP TO PICK A VIDEO', style: AppTheme.labelCaps(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Processing extends StatelessWidget {
  const _Processing({required this.progress, required this.frame});
  final double progress;
  final int frame;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Analyzing · frame $frame',
            style: AppTheme.mono(color: AppColors.onSurface),
          ),
          const SizedBox(height: AppSpacing.lg),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

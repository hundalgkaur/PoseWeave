import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/bloc/rep_counter_bloc.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/rep_counter_display.dart';

/// Counts reps from an uploaded clip: reuses `PoseBloc`'s `pickAndAnalyzeVideo`
/// pipeline, then folds the resulting poses through the `RepCounter` engine via
/// `RepCounterBloc`. Mirrors `gait_analysis_page.dart`.
class RepCounterVideoPage extends StatelessWidget {
  const RepCounterVideoPage({required this.exercise, super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeVideo()),
        ),
        BlocProvider<RepCounterBloc>(
          create: (_) => getIt<RepCounterBloc>()
            ..add(RepCounterEvent.selectExercise(exercise)),
        ),
      ],
      child: _RepVideoView(exercise: exercise),
    );
  }
}

class _RepVideoView extends StatelessWidget {
  const _RepVideoView({required this.exercise});
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: exercise.label),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                    .read<RepCounterBloc>()
                    .add(RepCounterEvent.analyzeVideoPoses(state.poses));
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
              return BlocBuilder<RepCounterBloc, RepCounterState>(
                builder: (BuildContext context, RepCounterState rep) {
                  if (rep is RepCounterComplete) {
                    return _Summary(
                      exercise: rep.exercise,
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
  const _Summary({required this.exercise, required this.onPickAnother});
  final Exercise exercise;
  final VoidCallback onPickAnother;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        BlocBuilder<RepCounterBloc, RepCounterState>(
          builder: (BuildContext context, RepCounterState rep) {
            if (rep is RepCounterComplete) {
              return RepCounterDisplay(
                exercise: rep.exercise,
                result: rep.result,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 20),
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
                Icons.video_library_outlined,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Select an exercise video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Full body in frame, a few clean reps',
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
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
          const SizedBox(height: 16),
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

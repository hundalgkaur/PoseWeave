import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/gait_analyzer.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/pages/gait_report_page.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Home entry for gait analysis: pick a walking clip, analyze it frame-by-frame
/// (existing pipeline), then show the computed report.
class GaitAnalysisPage extends StatelessWidget {
  const GaitAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create:
          (_) => getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeVideo()),
      child: const _GaitAnalysisView(),
    );
  }
}

class _GaitAnalysisView extends StatelessWidget {
  const _GaitAnalysisView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gait Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<PoseBloc, PoseState>(
            listener: (BuildContext context, PoseState state) {
              if (state is PoseVideoComplete) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder:
                        (_) => GaitReportPage(
                          params: GaitAnalyzer.analyze(state.poses),
                          poses: state.poses,
                          framePaths: state.framePaths,
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
            builder: (BuildContext context, PoseState state) {
              if (state is PoseVideoProcessing) {
                return _Processing(
                  progress: state.progress,
                  frame: state.framesProcessed,
                );
              }
              return _Prompt(
                onPick:
                    () => context.read<PoseBloc>().add(
                      const PoseEvent.pickAndAnalyzeVideo(),
                    ),
              );
            },
          ),
        ),
      ),
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
                Icons.directions_walk,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Select a walking video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Best results: side-on, full body, a few steps',
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
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
            'Analyzing gait · frame $frame',
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

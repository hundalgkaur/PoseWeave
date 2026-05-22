import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/pose_results_view.dart';

/// Upload a video, watch it process frame-by-frame, then scrub the detected
/// poses and inspect / export per-landmark coordinates.
class GalleryPosePage extends StatelessWidget {
  const GalleryPosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create: (_) => getIt<PoseBloc>(),
      child: const _GalleryView(),
    );
  }
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<PoseBloc, PoseState>(
            builder: (BuildContext context, PoseState state) {
              if (state is PoseVideoProcessing) {
                return _Processing(state: state);
              }
              if (state is PoseVideoComplete) {
                return PoseResultsView(
                  poses: state.poses,
                  frameCount: state.frameCount,
                  videoPath: state.videoPath,
                  restartLabel: 'Pick another video',
                  onRestart: () => context
                      .read<PoseBloc>()
                      .add(const PoseEvent.pickAndAnalyzeVideo()),
                );
              }
              if (state is PoseError) {
                return _ErrorView(message: state.message);
              }
              return const _UploadZone();
            },
          ),
        ),
      ),
    );
  }
}

class _UploadZone extends StatelessWidget {
  const _UploadZone();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () =>
            context.read<PoseBloc>().add(const PoseEvent.pickAndAnalyzeVideo()),
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.movie_outlined,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Tap to select a video',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Frames are sampled and analyzed on-device',
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
  const _Processing({required this.state});
  final PoseVideoProcessing state;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Processing frame ${state.framesProcessed}',
            style: AppTheme.mono(color: AppColors.onSurface),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: state.progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(state.progress * 100).round()}%',
            style: AppTheme.mono(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.mono(color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
            ),
            onPressed: () => context
                .read<PoseBloc>()
                .add(const PoseEvent.pickAndAnalyzeVideo()),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

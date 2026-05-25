import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/clinical/clinical_bottom_nav.dart';
import 'package:poseweave/presentation/widgets/clinical/landmark_metrics_table.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

/// Biomechanical analysis: reuses the video analyze pipeline (`PoseBloc`
/// pickAndAnalyzeVideo → `PoseVideoComplete`), then shows the frame + skeleton
/// scrub plus a clinical [LandmarkMetricsTable] (uncalibrated depth metrics).
class ClinicalBiomechanicalAnalysisPage extends StatelessWidget {
  const ClinicalBiomechanicalAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create:
          (_) => getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeVideo()),
      child: const _BiomechView(),
    );
  }
}

class _BiomechView extends StatelessWidget {
  const _BiomechView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Biomechanical Analysis'),
      bottomNavigationBar: const ClinicalBottomNav(current: 1),
      body: SafeArea(
        child: BlocConsumer<PoseBloc, PoseState>(
          listener: (BuildContext context, PoseState state) {
            if (state is PoseError) {
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
            if (state is PoseVideoComplete) {
              if (state.poses.isEmpty) {
                return _Prompt(
                  note: 'No human detected in that clip. Try a clearer, '
                      'side-on video with the full body in frame.',
                  onPick: () => context
                      .read<PoseBloc>()
                      .add(const PoseEvent.pickAndAnalyzeVideo()),
                );
              }
              return _Results(state: state);
            }
            return _Prompt(
              onPick: () => context
                  .read<PoseBloc>()
                  .add(const PoseEvent.pickAndAnalyzeVideo()),
            );
          },
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.state});
  final PoseVideoComplete state;

  @override
  Widget build(BuildContext context) {
    // Representative (mid) frame + its index-aligned image, if available.
    final List<PoseEntity> poses = state.poses;
    final int mid = poses.length ~/ 2;
    final PoseEntity rep = poses[mid];
    final String? repFrame =
        mid < state.framePaths.length ? state.framePaths[mid] : null;

    // A scrollable list avoids the fixed-height overflow PoseResultsView caused
    // here; the frame keeps its 3:4 aspect and the metrics table scrolls below.
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const PatientHeader(patient: ClinicalPatient.demo, detailed: true),
        const SizedBox(height: 16),
        GlassPanel(
          padding: EdgeInsets.zero,
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (repFrame != null && File(repFrame).existsSync())
                  Image.file(File(repFrame), fit: BoxFit.contain),
                CustomPaint(
                  painter: PoseOverlayPainter(
                    landmarks: rep.landmarks,
                    imageSize: rep.imageSize ?? const Size(1, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text('${poses.length} frames analyzed · showing mid-frame',
            style: AppTheme.labelCaps(fontSize: 9)),
        const SizedBox(height: 16),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('LANDMARK METRICS (mid-frame)', style: AppTheme.labelCaps()),
              const SizedBox(height: 8),
              LandmarkMetricsTable(landmarks: rep.landmarks),
            ],
          ),
        ),
      ],
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.onPick, this.note});
  final VoidCallback onPick;

  /// Optional context line (e.g. shown after a clip yielded no detections).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final bool isEmptyResult = note != null;
    return Center(
      child: GestureDetector(
        onTap: onPick,
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(isEmptyResult ? Icons.person_off_outlined : Icons.biotech_outlined,
                  color: isEmptyResult ? AppColors.warning : AppColors.primary,
                  size: 48),
              const SizedBox(height: 16),
              Text(isEmptyResult ? 'No human detected' : 'Select a clip to analyze',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                note ??
                    'Side-on, full body. Landmark depth (mm) is uncalibrated.',
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                    color: AppColors.onSurfaceVariant, fontSize: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: GlassPanel(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.biotech, color: AppColors.primary, size: 40),
              const SizedBox(height: 12),
              Text('BIOMECHANICAL SCAN', style: AppTheme.labelCaps()),
              const SizedBox(height: 4),
              Text('Frame $frame',
                  style: AppTheme.data(
                      fontSize: 28, color: AppColors.primary)),
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
              const SizedBox(height: 8),
              Text('${(progress * 100).round()}% · extracting landmarks',
                  style: AppTheme.labelCaps(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}

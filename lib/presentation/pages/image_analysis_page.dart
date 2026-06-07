import 'dart:io';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/utils/gait_analyzer.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/data/services/pdf_report_service.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/joint_angles_panel.dart';
import 'package:poseweave/presentation/widgets/landmark_table.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';
import 'package:share_plus/share_plus.dart';

/// Detect a pose in a single still image and inspect it three ways
/// (skeleton overlay, joint angles, landmark coordinates).
class ImageAnalysisPage extends StatelessWidget {
  const ImageAnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create:
          (_) => getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeImage()),
      child: const _ImageAnalysisView(),
    );
  }
}

class _ImageAnalysisView extends StatelessWidget {
  const _ImageAnalysisView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Image Analysis'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
              if (state is PoseImageProcessing) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primaryContainer,
                    ),
                  ),
                );
              }
              if (state is PoseImageComplete) {
                return _ImageResult(
                  imagePath: state.imagePath,
                  pose: state.pose,
                  onPick:
                      () => context.read<PoseBloc>().add(
                        const PoseEvent.pickAndAnalyzeImage(),
                      ),
                );
              }
              return _Prompt(
                onPick:
                    () => context.read<PoseBloc>().add(
                      const PoseEvent.pickAndAnalyzeImage(),
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
                Icons.image_search,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Select an image',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _View { skeleton, angles, coordinates }

class _ImageResult extends StatefulWidget {
  const _ImageResult({
    required this.imagePath,
    required this.pose,
    required this.onPick,
  });
  final String imagePath;
  final PoseEntity? pose;
  final VoidCallback onPick;

  @override
  State<_ImageResult> createState() => _ImageResultState();
}

class _ImageResultState extends State<_ImageResult> {
  _View _view = _View.skeleton;

  @override
  Widget build(BuildContext context) {
    final PoseEntity? pose = widget.pose;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3 / 4,
          child: GlassPanel(
            padding: EdgeInsets.zero,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.file(File(widget.imagePath), fit: BoxFit.contain),
                if (pose != null)
                  CustomPaint(
                    painter: PoseOverlayPainter(
                      landmarks: pose.landmarks,
                      imageSize: pose.imageSize ?? const Size(1, 1),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (pose == null)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(Icons.person_off,
                      color: AppColors.warning, size: 40),
                  const SizedBox(height: 12),
                  Text('No human detected',
                      style: AppTheme.labelCaps(color: AppColors.warning)),
                  const SizedBox(height: 4),
                  Text(
                    'Pick an image with a person, full body visible',
                    textAlign: TextAlign.center,
                    style: AppTheme.mono(
                        color: AppColors.onSurfaceVariant, fontSize: 11),
                  ),
                  const SizedBox(height: 16),
                  _pickButton(),
                ],
              ),
            ),
          )
        else ...<Widget>[
          SegmentedButton<_View>(
            segments: const <ButtonSegment<_View>>[
              ButtonSegment<_View>(
                value: _View.skeleton,
                label: Text('Skeleton'),
              ),
              ButtonSegment<_View>(value: _View.angles, label: Text('Angles')),
              ButtonSegment<_View>(
                value: _View.coordinates,
                label: Text('Coords'),
              ),
            ],
            selected: <_View>{_view},
            onSelectionChanged:
                (Set<_View> s) => setState(() => _view = s.first),
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text('EXPORT', style: AppTheme.labelCaps()),
              const Spacer(),
              IconButton(
                tooltip: 'Export PDF report',
                icon: const Icon(Icons.picture_as_pdf,
                    color: AppColors.primary, size: 20),
                onPressed: () => _exportPdf(pose),
              ),
              IconButton(
                tooltip: 'Export pose as JSON',
                icon: const Icon(Icons.download,
                    color: AppColors.primary, size: 20),
                onPressed: () => _exportJson(pose),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(child: _body(pose)),
        ],
      ],
    );
  }

  Future<void> _exportJson(PoseEntity pose) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final Either<Failure, String> result = await getIt<PoseRepository>()
        .exportPosesToJson(<PoseEntity>[pose]);
    if (!mounted) return;
    result.fold(
      (Failure f) => messenger.showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
      (String jsonPath) => Share.shareXFiles(
        <XFile>[XFile(jsonPath), XFile(widget.imagePath)],
        subject: 'PoseWeave image export',
      ),
    );
  }

  Future<void> _exportPdf(PoseEntity pose) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final Either<Failure, String> result =
        await getIt<PdfReportService>().generateReport(
      ReportData(
        generatedAt: DateTime.now(),
        exerciseType: 'Image pose analysis',
        gait: GaitAnalyzer.analyze(<PoseEntity>[pose]),
        segments: SegmentAggregator.summarize(<PoseEntity>[pose]),
        framePaths: <String>[widget.imagePath],
      ),
    );
    if (!mounted) return;
    result.fold(
      (Failure f) => messenger.showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
      (String path) =>
          Share.shareXFiles(<XFile>[XFile(path)], subject: 'PoseWeave report'),
    );
  }

  Widget _body(PoseEntity pose) {
    switch (_view) {
      case _View.skeleton:
        return Center(child: _pickButton());
      case _View.angles:
        return SingleChildScrollView(child: JointAnglesPanel(pose: pose));
      case _View.coordinates:
        return GlassPanel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: LandmarkTable(landmarks: pose.landmarks),
        );
    }
  }

  Widget _pickButton() => FilledButton.icon(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryContainer,
      foregroundColor: AppColors.onPrimary,
    ),
    onPressed: widget.onPick,
    icon: const Icon(Icons.image_search),
    label: const Text('Pick another image'),
  );
}

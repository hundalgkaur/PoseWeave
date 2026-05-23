import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/joint_angles_panel.dart';
import 'package:poseweave/presentation/widgets/landmark_table.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

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
      appBar: AppBar(
        title: const Text('Image Analysis'),
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
                  Text(
                    'No pose detected',
                    style: AppTheme.mono(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
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
          const SizedBox(height: 12),
          Expanded(child: _body(pose)),
        ],
      ],
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
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
    ),
    onPressed: widget.onPick,
    icon: const Icon(Icons.image_search),
    label: const Text('Pick another image'),
  );
}

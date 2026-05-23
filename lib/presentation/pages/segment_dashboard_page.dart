import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/segment_detail_card.dart';

/// Live per-segment dashboard: runs detection and shows left/right arm + leg
/// cards with joint-angle classification, updating from `PoseActive`.
class SegmentDashboardPage extends StatelessWidget {
  const SegmentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create: (_) => getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
      child: const _SegmentView(),
    );
  }
}

class _SegmentView extends StatefulWidget {
  const _SegmentView();

  @override
  State<_SegmentView> createState() => _SegmentViewState();
}

class _SegmentViewState extends State<_SegmentView> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segment Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<PoseBloc, PoseState>(
          listener: (BuildContext context, PoseState state) async {
            // Auto-start detection once the camera is live (one-shot).
            if (state is PoseStreaming && !_started) {
              _started = true;
              context.read<PoseBloc>().add(const PoseEvent.startDetection());
            } else if (state is PoseNoPermission) {
              final bool? retry = await PermissionRationaleDialog.show(context);
              if ((retry ?? false) && context.mounted) {
                context.read<PoseBloc>().add(
                  const PoseEvent.initializeCamera(),
                );
              }
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
            if (state is PoseActive) {
              return _Grid(pose: state.pose);
            }
            if (state is PoseNoPermission) {
              return Center(
                child: Text(
                  'Camera permission needed',
                  style: AppTheme.mono(color: AppColors.onSurfaceVariant),
                ),
              );
            }
            return const Stack(
              children: <Widget>[
                LoadingOverlay(message: 'Starting detection…'),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.pose});
  final PoseEntity pose;

  LandmarkEntity _lm(PoseLandmarkType type) =>
      pose.getLandmark(type) ??
      LandmarkEntity(type: type, x: 0, y: 0, confidence: 0);

  @override
  Widget build(BuildContext context) {
    final AngleAnalysis leftArm = PoseMath.analyzeElbow(
      shoulder: _lm(PoseLandmarkType.leftShoulder),
      elbow: _lm(PoseLandmarkType.leftElbow),
      wrist: _lm(PoseLandmarkType.leftWrist),
    );
    final AngleAnalysis rightArm = PoseMath.analyzeElbow(
      shoulder: _lm(PoseLandmarkType.rightShoulder),
      elbow: _lm(PoseLandmarkType.rightElbow),
      wrist: _lm(PoseLandmarkType.rightWrist),
    );
    final AngleAnalysis leftLeg = PoseMath.analyzeKnee(
      hip: _lm(PoseLandmarkType.leftHip),
      knee: _lm(PoseLandmarkType.leftKnee),
      ankle: _lm(PoseLandmarkType.leftAnkle),
      isLeftSide: true,
    );
    final AngleAnalysis rightLeg = PoseMath.analyzeKnee(
      hip: _lm(PoseLandmarkType.rightHip),
      knee: _lm(PoseLandmarkType.rightKnee),
      ankle: _lm(PoseLandmarkType.rightAnkle),
      isLeftSide: false,
    );

    SegmentDetailCard card(
      String title,
      AngleAnalysis a,
      PoseLandmarkType j1,
      String n1,
      PoseLandmarkType j2,
      String n2,
      PoseLandmarkType j3,
      String n3,
    ) => SegmentDetailCard(
      title: title,
      analysis: a,
      joints: <(String, double)>[
        (n1, _lm(j1).confidence),
        (n2, _lm(j2).confidence),
        (n3, _lm(j3).confidence),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: card(
                    'LEFT ARM',
                    leftArm,
                    PoseLandmarkType.leftShoulder,
                    'Shoulder',
                    PoseLandmarkType.leftElbow,
                    'Elbow',
                    PoseLandmarkType.leftWrist,
                    'Wrist',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: card(
                    'RIGHT ARM',
                    rightArm,
                    PoseLandmarkType.rightShoulder,
                    'Shoulder',
                    PoseLandmarkType.rightElbow,
                    'Elbow',
                    PoseLandmarkType.rightWrist,
                    'Wrist',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: card(
                    'LEFT LEG',
                    leftLeg,
                    PoseLandmarkType.leftHip,
                    'Hip',
                    PoseLandmarkType.leftKnee,
                    'Knee',
                    PoseLandmarkType.leftAnkle,
                    'Ankle',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: card(
                    'RIGHT LEG',
                    rightLeg,
                    PoseLandmarkType.rightHip,
                    'Hip',
                    PoseLandmarkType.rightKnee,
                    'Knee',
                    PoseLandmarkType.rightAnkle,
                    'Ankle',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

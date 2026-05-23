import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/sample_pose.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/presentation/widgets/clinical/hud_frame.dart';
import 'package:poseweave/presentation/widgets/clinical/kinematics_panel.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/skeleton_3d_painter.dart';

/// Clinical 3D reconstruction: reuses [Skeleton3DPainter] (gesture rotate/zoom)
/// with clinical chrome — patient header, live kinematics, HUD crosshairs, and a
/// mock "Export DICOM" action.
class Clinical3DReconstructionPage extends StatefulWidget {
  const Clinical3DReconstructionPage({super.key, this.pose});

  final PoseEntity? pose;

  @override
  State<Clinical3DReconstructionPage> createState() =>
      _Clinical3DReconstructionPageState();
}

class _Clinical3DReconstructionPageState
    extends State<Clinical3DReconstructionPage> {
  late final PoseEntity _pose = widget.pose ?? sampleStandingPose();

  double _rotationY = 0.4;
  double _rotationX = 0;
  double _zoom = 1;
  double _zoomAtStart = 1;

  void _onScaleStart(ScaleStartDetails d) => _zoomAtStart = _zoom;

  void _onScaleUpdate(ScaleUpdateDetails d) {
    setState(() {
      _rotationY += d.focalPointDelta.dx * 0.01;
      _rotationX = (_rotationX + d.focalPointDelta.dy * 0.01)
          .clamp(-math.pi / 4, math.pi / 4);
      if (d.scale != 1.0) {
        _zoom = (_zoomAtStart * d.scale).clamp(0.5, 2.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('3D Reconstruction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
              painter: Skeleton3DPainter(
                landmarks: _pose.landmarks,
                rotationY: _rotationY,
                rotationX: _rotationX,
                zoom: _zoom,
              ),
            ),
            const HudFrame(),
            const _Crosshair(),
            SafeArea(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child:
                        PatientHeader(patient: ClinicalPatient.demo, detailed: true),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: KinematicsPanel(pose: _pose),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() {
                              _rotationY = 0.4;
                              _rotationX = 0;
                              _zoom = 1;
                            }),
                            icon: const Icon(Icons.restart_alt),
                            label: const Text('RESET VIEW'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                            ),
                            onPressed: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'DICOM export is mocked in this demo.',
                                  style: AppTheme.mono(
                                      color: AppColors.onPrimary, fontSize: 12),
                                ),
                                backgroundColor: AppColors.primaryContainer,
                              ),
                            ),
                            icon: const Icon(Icons.file_download_outlined),
                            label: const Text('EXPORT DICOM'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Drag to rotate • pinch to zoom',
                      style: AppTheme.labelCaps(fontSize: 9)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Crosshair extends StatelessWidget {
  const _Crosshair();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Center(
        child: Icon(Icons.add, size: 28, color: AppColors.outlineVariant),
      ),
    );
  }
}

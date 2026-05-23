import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/clinical/hud_frame.dart';
import 'package:poseweave/presentation/widgets/clinical/kinematics_panel.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/clinical/sensor_status_panel.dart';
import 'package:poseweave/presentation/widgets/confidence_indicator.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

/// Clinical live diagnostic feed: reuses [PoseBloc] camera detection +
/// [PoseOverlayPainter], wrapped in clinical chrome (patient header, calibration
/// badge, live kinematics, mock sensor status). Mock mode (triple-tap the
/// consumer logo) works here on emulators.
class ClinicalLiveDiagnosticPage extends StatelessWidget {
  const ClinicalLiveDiagnosticPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create: (_) => getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
      child: const _LiveView(),
    );
  }
}

class _LiveView extends StatelessWidget {
  const _LiveView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: BlocConsumer<PoseBloc, PoseState>(
        listener: (BuildContext context, PoseState state) async {
          if (state is PoseNoPermission) {
            final bool? retry = await PermissionRationaleDialog.show(context);
            if ((retry ?? false) && context.mounted) {
              context.read<PoseBloc>().add(const PoseEvent.initializeCamera());
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
          final PoseBloc bloc = context.read<PoseBloc>();
          final bool detecting = state is PoseActive;
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _Background(bloc: bloc),
              if (state is PoseActive)
                CustomPaint(
                  painter: PoseOverlayPainter(
                    landmarks: state.pose.landmarks,
                    imageSize: state.pose.imageSize ?? const Size(1, 1),
                    mirror: bloc.lensDirection == CameraLensDirection.front,
                  ),
                ),
              const HudFrame(),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    _TopBar(
                      confidence:
                          state is PoseActive ? state.averageConfidence : 0,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child:
                          PatientHeader(patient: ClinicalPatient.demo),
                    ),
                    const Spacer(),
                    if (detecting)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                                child: KinematicsPanel(pose: state.pose)),
                            const SizedBox(width: 12),
                            const Expanded(
                                child: SensorStatusPanel(tracking: true)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    _Controls(detecting: detecting, bloc: bloc),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              if (state is PoseLoading)
                const LoadingOverlay(message: 'Initializing sensors…'),
            ],
          );
        },
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.bloc});
  final PoseBloc bloc;

  @override
  Widget build(BuildContext context) {
    final CameraController? controller = bloc.cameraController;
    if (controller != null && controller.value.isInitialized) {
      return Center(child: CameraPreview(controller));
    }
    return ColoredBox(
      color: AppColors.surfaceContainerLowest,
      child: bloc.isMockMode
          ? Center(
              child: Text('MOCK MODE',
                  style: AppTheme.labelCaps(color: AppColors.outline)),
            )
          : null,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.confidence});
  final double confidence;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          ),
          const Spacer(),
          const _CalibrationBadge(),
          const SizedBox(width: 8),
          ConfidenceIndicator(confidence: confidence),
        ],
      ),
    );
  }
}

class _CalibrationBadge extends StatelessWidget {
  const _CalibrationBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.verified_outlined,
              size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text('DIAGNOSTIC GRADE',
              style: AppTheme.labelCaps(fontSize: 9, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({required this.detecting, required this.bloc});
  final bool detecting;
  final PoseBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor:
                    detecting ? AppColors.error : AppColors.primary,
                foregroundColor:
                    detecting ? AppColors.onError : AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: () {
                HapticFeedback.mediumImpact();
                bloc.add(
                  detecting
                      ? const PoseEvent.stopDetection()
                      : const PoseEvent.startDetection(),
                );
              },
              icon: Icon(detecting ? Icons.stop : Icons.play_arrow),
              label: Text(
                detecting ? 'END SESSION' : 'BEGIN DIAGNOSTIC SESSION',
                style: AppTheme.labelCaps(
                  color: detecting ? AppColors.onError : AppColors.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.outlined(
            onPressed: () => bloc.add(const PoseEvent.switchCamera()),
            icon: const Icon(Icons.cameraswitch, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

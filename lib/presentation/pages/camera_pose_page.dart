import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/body_region_legend.dart';
import 'package:poseweave/presentation/widgets/confidence_indicator.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';
import 'package:poseweave/presentation/widgets/pose_results_view.dart';

/// Full-screen live camera with the skeleton overlay and HUD controls, plus a
/// record→analyze flow that produces synchronized video + pose data.
class CameraPosePage extends StatelessWidget {
  const CameraPosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PoseBloc>(
      create: (_) => getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
      child: const _CameraView(),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView();

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

          // Recording produced a clip that's being / has been analyzed.
          if (state is PoseVideoProcessing) {
            return _ProcessingView(state: state);
          }
          if (state is PoseVideoComplete) {
            return _RecordingResults(state: state);
          }

          final bool detecting = state is PoseActive;
          final bool recording = state is PoseRecordingVideo;
          final bool canRecord = !bloc.isMockMode &&
              (state is PoseStreaming || detecting || recording);

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
              const _HudCorners(),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    _TopBar(
                      confidence:
                          state is PoseActive ? state.averageConfidence : 0,
                      fps: state is PoseActive ? state.fps : 0,
                    ),
                    const Spacer(),
                    _Controls(
                      detecting: detecting,
                      recording: recording,
                      canRecord: canRecord,
                      bloc: bloc,
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: BodyRegionLegend(),
                ),
              ),
              if (state is PoseLoading)
                const LoadingOverlay(message: 'Initializing camera…'),
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
              child: Text(
                'MOCK MODE',
                style: AppTheme.labelCaps(color: AppColors.outline),
              ),
            )
          : null,
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.confidence, required this.fps});
  final double confidence;
  final double fps;

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
          ConfidenceIndicator(confidence: confidence),
          const SizedBox(width: 8),
          _FpsBadge(fps: fps),
        ],
      ),
    );
  }
}

class _FpsBadge extends StatelessWidget {
  const _FpsBadge({required this.fps});
  final double fps;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        'FPS ${fps.toStringAsFixed(0)}',
        style: AppTheme.mono(fontSize: 12, color: AppColors.primary),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.detecting,
    required this.recording,
    required this.canRecord,
    required this.bloc,
  });
  final bool detecting;
  final bool recording;
  final bool canRecord;
  final PoseBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      child: Column(
        children: <Widget>[
          if (recording) const _RecBadge(),
          if (recording) const SizedBox(height: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: detecting ? AppColors.error : AppColors.primary,
              foregroundColor:
                  detecting ? AppColors.onError : AppColors.onPrimary,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            // Detection is disabled while recording (mutually exclusive).
            onPressed: recording
                ? null
                : () {
                    HapticFeedback.mediumImpact();
                    bloc.add(
                      detecting
                          ? const PoseEvent.stopDetection()
                          : const PoseEvent.startDetection(),
                    );
                  },
            icon: Icon(detecting ? Icons.stop : Icons.play_arrow),
            label: Text(
              detecting ? 'STOP DETECTION' : 'START DETECTION',
              style: AppTheme.labelCaps(
                color: detecting ? AppColors.onError : AppColors.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _DockButton(
                icon: Icons.cameraswitch,
                label: 'FLIP',
                onTap: recording
                    ? null
                    : () => bloc.add(const PoseEvent.switchCamera()),
              ),
              _DockButton(
                icon:
                    recording ? Icons.stop_circle : Icons.fiber_manual_record,
                label: recording ? 'STOP REC' : 'RECORD',
                color: recording ? AppColors.error : null,
                onTap: canRecord
                    ? () {
                        HapticFeedback.mediumImpact();
                        bloc.add(
                          recording
                              ? const PoseEvent.stopVideoRecording()
                              : const PoseEvent.startVideoRecording(),
                        );
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecBadge extends StatefulWidget {
  const _RecBadge();

  @override
  State<_RecBadge> createState() => _RecBadgeState();
}

class _RecBadgeState extends State<_RecBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FadeTransition(
            opacity: Tween<double>(begin: 0.35, end: 1).animate(_pulse),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('REC', style: AppTheme.mono(fontSize: 12, color: AppColors.error)),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;

  /// Null disables the button (greyed out).
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color tint = onTap == null
        ? AppColors.onSurfaceVariant.withValues(alpha: 0.35)
        : (color ?? AppColors.onSurfaceVariant);
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, color: tint),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.labelCaps(color: tint, fontSize: 9)),
        ],
      ),
    );
  }
}

/// Shown while the just-recorded clip is analyzed frame-by-frame.
class _ProcessingView extends StatelessWidget {
  const _ProcessingView({required this.state});
  final PoseVideoProcessing state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Analyzing recording · frame ${state.framesProcessed}',
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
        ),
      ),
    );
  }
}

/// Results of a recorded-clip analysis: scrub poses, export video + JSON, or
/// return to the live camera.
class _RecordingResults extends StatelessWidget {
  const _RecordingResults({required this.state});
  final PoseVideoComplete state;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                Text('RECORDING ANALYZED', style: AppTheme.labelCaps()),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: PoseResultsView(
                poses: state.poses,
                frameCount: state.frameCount,
                videoPath: state.videoPath,
                restartLabel: 'Back to live camera',
                onRestart: () =>
                    context.read<PoseBloc>().add(const PoseEvent.startDetection()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Four L-shaped corner brackets framing the viewport (the "scanning" HUD).
class _HudCorners extends StatelessWidget {
  const _HudCorners();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.topLeft, child: _Corner(top: true, left: true)),
            Align(alignment: Alignment.topRight, child: _Corner(top: true, left: false)),
            Align(alignment: Alignment.bottomLeft, child: _Corner(top: false, left: true)),
            Align(alignment: Alignment.bottomRight, child: _Corner(top: false, left: false)),
          ],
        ),
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  const _Corner({required this.top, required this.left});
  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    const BorderSide side = BorderSide(color: AppColors.primary, width: 2);
    return SizedBox(
      width: 20,
      height: 20,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: top ? side : BorderSide.none,
            bottom: top ? BorderSide.none : side,
            left: left ? side : BorderSide.none,
            right: left ? BorderSide.none : side,
          ),
        ),
      ),
    );
  }
}

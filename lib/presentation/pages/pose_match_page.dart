import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/pose_guide_builder.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/domain/entities/pose_template.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_match_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/camera_pose_view.dart';
import 'package:poseweave/presentation/widgets/camera_switch_button.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/no_person_banner.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/pose_match_panel.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

/// Guided "Match a target": shows a reference (preset icon / bundled photo /
/// uploaded image) and live-scores how well the user matches it. Reuses
/// `PoseBloc` for the camera and `PoseMatchBloc` for scoring + hold-to-complete.
class PoseMatchPage extends StatelessWidget {
  const PoseMatchPage({
    required this.label,
    required this.icon,
    super.key,
    this.template,
    this.referencePose,
    this.referenceImagePath,
  });

  final String label;
  final IconData icon;

  /// Preset target (matched against its template variants).
  final PoseTemplate? template;

  /// Uploaded target (matched against this detected pose).
  final PoseEntity? referencePose;

  /// Uploaded reference image to display (file path), if any.
  final String? referenceImagePath;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
        ),
        BlocProvider<PoseMatchBloc>(
          create: (_) {
            final PoseMatchBloc bloc = getIt<PoseMatchBloc>();
            final PoseEntity? ref = referencePose;
            final PoseTemplate? tpl = template;
            if (ref != null) {
              bloc.add(PoseMatchEvent.selectReferencePose(ref));
            } else if (tpl != null) {
              bloc.add(PoseMatchEvent.selectTemplate(tpl));
            }
            return bloc;
          },
        ),
      ],
      child: _MatchView(
        label: label,
        icon: icon,
        imageAsset: template?.imageAsset,
        referenceImagePath: referenceImagePath,
        // A guide skeleton of the target pose (presets only), so the user sees
        // the actual shape to copy instead of a generic icon.
        guide: template == null ? null : PoseGuideBuilder.build(template!),
      ),
    );
  }
}

class _MatchView extends StatefulWidget {
  const _MatchView({
    required this.label,
    required this.icon,
    this.imageAsset,
    this.referenceImagePath,
    this.guide,
  });

  final String label;
  final IconData icon;
  final String? imageAsset;
  final String? referenceImagePath;
  final PoseEntity? guide;

  @override
  State<_MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<_MatchView> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: widget.label),
      body: BlocConsumer<PoseBloc, PoseState>(
        listener: (BuildContext context, PoseState state) async {
          if (state is PoseStreaming && !_started) {
            _started = true;
            context.read<PoseBloc>().add(const PoseEvent.startDetection());
          } else if (state is PoseActive) {
            context
                .read<PoseMatchBloc>()
                .add(PoseMatchEvent.poseReceived(state.pose));
          } else if (state is PoseNoPermission) {
            final bool? retry = await PermissionRationaleDialog.show(context);
            if ((retry ?? false) && context.mounted) {
              context.read<PoseBloc>().add(const PoseEvent.initializeCamera());
            }
          }
        },
        builder: (BuildContext context, PoseState state) {
          if (state is PoseError) {
            return _ErrorView(
              message: state.message,
              onRetry: () {
                _started = false;
                context
                    .read<PoseBloc>()
                    .add(const PoseEvent.initializeCamera());
              },
            );
          }
          final PoseBloc bloc = context.read<PoseBloc>();
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CameraPoseView(bloc: bloc, state: state),
              if (state is PoseSearching)
                const NoPersonBanner(
                  message: 'Step into frame, full body visible',
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _ReferenceChip(
                            label: widget.label,
                            icon: widget.icon,
                            imageAsset: widget.imageAsset,
                            referenceImagePath: widget.referenceImagePath,
                            guide: widget.guide,
                          ),
                          const Spacer(),
                          CameraSwitchButton(bloc: bloc),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      const _MatchOverlay(),
                    ],
                  ),
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

/// The reference the user is copying — uploaded image, bundled photo, or icon.
class _ReferenceChip extends StatelessWidget {
  const _ReferenceChip({
    required this.label,
    required this.icon,
    this.imageAsset,
    this.referenceImagePath,
    this.guide,
  });

  final String label;
  final IconData icon;
  final String? imageAsset;
  final String? referenceImagePath;
  final PoseEntity? guide;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 56, height: 76, child: _thumb()),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('TARGET', style: AppTheme.labelCaps(fontSize: 8)),
              Text(label, style: AppTheme.headingSm()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _thumb() {
    final String? path = referenceImagePath;
    if (path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(File(path), fit: BoxFit.cover),
      );
    }
    final String? asset = imageAsset;
    if (asset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _guideOrIcon(),
        ),
      );
    }
    return _guideOrIcon();
  }

  Widget _guideOrIcon() {
    final PoseEntity? g = guide;
    if (g != null) {
      // The actual target-pose shape, so the user knows what to copy.
      return CustomPaint(
        painter: PoseOverlayPainter(
          landmarks: g.landmarks,
          imageSize: const Size(1, 1),
        ),
      );
    }
    return Icon(icon, color: AppColors.primaryContainer, size: 28);
  }
}

class _MatchOverlay extends StatelessWidget {
  const _MatchOverlay();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoseMatchBloc, PoseMatchState>(
      builder: (BuildContext context, PoseMatchState state) {
        if (state is PoseMatchCompleted) {
          return _CompletedCard(
            label: state.label,
            onReset: () =>
                context.read<PoseMatchBloc>().add(const PoseMatchEvent.reset()),
          );
        }
        if (state is PoseMatchMatching) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: state.holdProgress,
                  minHeight: 6,
                  backgroundColor: AppColors.surfaceContainerHigh,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              PoseMatchPanel(result: _withLabel(state)),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Show the target's name (not "No match") while the live score is still low.
  PoseMatchResult _withLabel(PoseMatchMatching s) => PoseMatchResult(
        poseName: s.label,
        matchPercent: s.result.matchPercent,
        confidence: s.result.confidence,
        deviations: s.result.deviations,
      );
}

class _CompletedCard extends StatelessWidget {
  const _CompletedCard({required this.label, required this.onReset});
  final String label;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check_circle, color: AppColors.success, size: 44),
          const SizedBox(height: AppSpacing.sm),
          Text('MATCHED', style: AppTheme.labelCaps(color: AppColors.success)),
          Text(label, style: AppTheme.headingMd()),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.list),
                  label: const Text('TARGETS'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onReset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('AGAIN'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTheme.mono(
                  color: AppColors.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

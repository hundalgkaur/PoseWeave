import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';

/// The live camera preview with the skeleton overlay drawn **in the same rect**,
/// so the skeleton lands on the body.
///
/// Both the [CameraPreview] and the [PoseOverlayPainter] are constrained to one
/// [AspectRatio] box matching the rotation-corrected frame size. Because the box
/// aspect equals `imageSize`'s aspect, the painter's aspect-preserving mapping
/// has no letterbox margin and maps normalized coordinates 1:1 onto the preview.
///
/// Replaces the old `_Background` + separate `CustomPaint` pattern that each live
/// page duplicated (preview letterboxed one way, overlay another → drift).
class CameraPoseView extends StatelessWidget {
  const CameraPoseView({required this.bloc, required this.state, super.key});

  final PoseBloc bloc;
  final PoseState state;

  @override
  Widget build(BuildContext context) {
    final CameraController? controller = bloc.cameraController;
    if (controller == null || !controller.value.isInitialized) {
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

    final PoseState s = state;
    final List<PoseEntity> poses = s is PoseActive
        ? (s.allPoses.isNotEmpty ? s.allPoses : <PoseEntity>[s.pose])
        : const <PoseEntity>[];
    final Size? poseSize = poses.isNotEmpty ? poses.first.imageSize : null;
    final Size imageSize = poseSize ?? _portraitFrame(controller);
    final double aspect = (imageSize.width <= 0 || imageSize.height <= 0)
        ? 1.0
        : imageSize.width / imageSize.height;
    final bool mirror = bloc.lensDirection == CameraLensDirection.front;

    return ColoredBox(
      color: AppColors.surfaceContainerLowest,
      child: Center(
        child: AspectRatio(
          aspectRatio: aspect,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CameraPreview(controller),
              // One painter per detected person — draws all skeletons.
              for (final PoseEntity p in poses)
                if (p.landmarks.length == 33)
                  CustomPaint(
                    painter: PoseOverlayPainter(
                      landmarks: p.landmarks,
                      imageSize: imageSize,
                      mirror: mirror,
                    ),
                  ),
              if (poses.length > 1)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _PersonBadge(count: poses.length),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Portrait display size of the preview (the sensor `previewSize` is
  /// landscape, so swap w/h). Used before the first pose carries an imageSize.
  static Size _portraitFrame(CameraController controller) {
    final Size? preview = controller.value.previewSize;
    if (preview == null) return const Size(9, 16);
    return Size(preview.height, preview.width);
  }
}

/// "N persons" chip shown when more than one person is detected.
class _PersonBadge extends StatelessWidget {
  const _PersonBadge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          '$count PERSONS',
          style: AppTheme.labelCaps(color: AppColors.primary, fontSize: 10),
        ),
      ),
    );
  }
}

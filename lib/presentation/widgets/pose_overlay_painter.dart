import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/pose_constants.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Draws the 2D skeleton: region-colored bones (with a neon glow) behind white
/// landmark dots whose radius scales with confidence. Low-confidence landmarks
/// (and any bone attached to one) are hidden entirely.
class PoseOverlayPainter extends CustomPainter {
  const PoseOverlayPainter({
    required this.landmarks,
    required this.imageSize,
    this.mirror = false,
  });

  /// The 33 landmarks to draw.
  final List<LandmarkEntity> landmarks;

  /// Source frame size, for aspect-preserving scaling onto the canvas.
  final Size imageSize;

  /// Flip horizontally (front-facing camera preview is mirrored).
  final bool mirror;

  // Pre-created paints reused every frame (no per-paint allocation). The bone
  // paint's color is set per-bone inside [paint].
  static final Paint _bonePaint =
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
  static final Paint _dotFill =
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
  static final Paint _dotStroke =
      Paint()
        ..color = Colors.black.withValues(alpha: 0.6)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.length != 33) return;

    // Resolve every landmark to a canvas point, or null if it shouldn't show.
    final List<Offset?> points = List<Offset?>.filled(33, null);
    for (int i = 0; i < landmarks.length; i++) {
      final LandmarkEntity lm = landmarks[i];
      if (!lm.isVisible) continue;
      Offset o = PoseMath.normalizedToCanvas(lm, size, imageSize);
      if (mirror) o = Offset(size.width - o.dx, o.dy);
      points[i] = o;
    }

    // Bones first (behind the dots).
    const List<List<int>> connections = PoseBones.connections;
    for (int b = 0; b < connections.length; b++) {
      final Offset? a = points[connections[b][0]];
      final Offset? c = points[connections[b][1]];
      if (a == null || c == null) continue;
      _bonePaint.color = PoseBones.colorForBone(b);
      canvas.drawLine(a, c, _bonePaint);
    }

    // Dots on top, sized by confidence.
    for (int i = 0; i < 33; i++) {
      final Offset? o = points[i];
      if (o == null) continue;
      final double radius = 4.0 + landmarks[i].confidence * 4.0;
      canvas.drawCircle(o, radius, _dotFill);
      canvas.drawCircle(o, radius, _dotStroke);
    }
  }

  @override
  bool shouldRepaint(PoseOverlayPainter old) =>
      !identical(old.landmarks, landmarks) ||
      old.imageSize != imageSize ||
      old.mirror != mirror;
}

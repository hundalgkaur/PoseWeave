import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/pose_constants.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Projects the 33 landmarks into a rotatable 3D skeleton.
///
/// Coordinates are centered on the origin (x,y around 0) and z is normalized
/// across the pose so depth is comparable regardless of ML Kit's raw z scale.
/// Points are rotated by the gesture-driven [rotationY]/[rotationX], projected
/// with a perspective divide, and depth-shaded (nearer = brighter).
class Skeleton3DPainter extends CustomPainter {
  const Skeleton3DPainter({
    required this.landmarks,
    required this.rotationY,
    required this.rotationX,
    required this.zoom,
  });

  final List<LandmarkEntity> landmarks;
  final double rotationY;
  final double rotationX;
  final double zoom;

  static const double _focalLength = 2;

  static final Paint _bonePaint =
      Paint()
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
  static final Paint _dotPaint = Paint()..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.length != 33) return;

    // Normalize z across the pose to roughly [-0.5, 0.5].
    double zMin = double.infinity;
    double zMax = -double.infinity;
    for (final LandmarkEntity l in landmarks) {
      final double z = l.z ?? 0;
      if (z < zMin) zMin = z;
      if (z > zMax) zMax = z;
    }
    final double zMid = (zMax + zMin) / 2;
    final double zSpan = (zMax - zMin).abs() < 1e-6 ? 1.0 : (zMax - zMin);

    final double scale = math.min(size.width, size.height) * 0.7 * zoom;

    final List<Offset?> points = List<Offset?>.filled(33, null);
    final List<double> depths = List<double>.filled(33, 0);
    for (int i = 0; i < 33; i++) {
      final LandmarkEntity l = landmarks[i];
      if (!l.isVisible) continue;
      final vm.Vector3 rotated = PoseMath.rotate3D(
        vm.Vector3(l.x - 0.5, l.y - 0.5, ((l.z ?? 0) - zMid) / zSpan),
        rotationY,
        rotationX,
      );
      points[i] = PoseMath.perspectiveProject(
        rotated,
        size,
        _focalLength,
        scale,
      );
      depths[i] = rotated.z;
    }

    // Bones first, depth-shaded by the average of their endpoints.
    const List<List<int>> connections = PoseBones.connections;
    for (int b = 0; b < connections.length; b++) {
      final Offset? a = points[connections[b][0]];
      final Offset? c = points[connections[b][1]];
      if (a == null || c == null) continue;
      final double t =
          (_brightness(depths[connections[b][0]]) +
              _brightness(depths[connections[b][1]])) /
          2;
      _bonePaint.color = PoseBones.colorForBone(
        b,
      ).withValues(alpha: 0.35 + 0.65 * t);
      canvas.drawLine(a, c, _bonePaint);
    }

    // Joints on top.
    for (int i = 0; i < 33; i++) {
      final Offset? o = points[i];
      if (o == null) continue;
      final double t = _brightness(depths[i]);
      final double radius = 3 + landmarks[i].confidence * 3 * (0.6 + 0.4 * t);
      _dotPaint.color = Color.lerp(
        AppColors.primaryContainer,
        Colors.white,
        t,
      )!.withValues(alpha: 0.5 + 0.5 * t);
      canvas.drawCircle(o, radius, _dotPaint);
    }
  }

  /// Maps rotated depth to [0,1] brightness: nearer (smaller z) is brighter.
  double _brightness(double z) => (1 - (z + 0.7) / 1.4).clamp(0.0, 1.0);

  @override
  bool shouldRepaint(Skeleton3DPainter old) =>
      old.rotationY != rotationY ||
      old.rotationX != rotationX ||
      old.zoom != zoom ||
      !identical(old.landmarks, landmarks);
}

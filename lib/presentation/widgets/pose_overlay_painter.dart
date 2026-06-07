import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/pose_constants.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Draws the 2D skeleton: region-colored bones (with a neon glow) behind white
/// landmark dots whose radius scales with confidence. Low-confidence landmarks
/// (and any bone attached to one) are hidden entirely. When [showAngles] is on,
/// each visible joint also gets its angle (degrees) rendered next to it.
class PoseOverlayPainter extends CustomPainter {
  const PoseOverlayPainter({
    required this.landmarks,
    required this.imageSize,
    this.mirror = false,
    this.showAngles = false,
  });

  /// The 33 landmarks to draw.
  final List<LandmarkEntity> landmarks;

  /// Source frame size, for aspect-preserving scaling onto the canvas.
  final Size imageSize;

  /// Flip horizontally (front-facing camera preview is mirrored).
  final bool mirror;

  /// Draw the 8 canonical joint angles (elbow / shoulder / hip / knee, L+R) as
  /// small labels next to each vertex. Opt-in so small thumbnails stay clean.
  final bool showAngles;

  /// Draw a landmark/bone down to this confidence. Lower than the domain
  /// `isVisible` gate (0.5) so more of the skeleton renders — weak joints
  /// (partly out of frame, occluded) still show, just faintly.
  static const double _kDrawThreshold = 0.3;

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

  /// Joint vertices to label when [showAngles] is on (b is the vertex; a-c form
  /// the angle). Mirrors the conventions used by `PoseMath.analyzeKnee` /
  /// `analyzeElbow` and the segment/clinical screens.
  static const List<List<int>> _angleJoints = <List<int>>[
    // [a, b (vertex), c]
    <int>[11, 13, 15], // left elbow (LSh-LEl-LWr)
    <int>[12, 14, 16], // right elbow
    <int>[23, 11, 13], // left shoulder (LHip-LSh-LEl)
    <int>[24, 12, 14], // right shoulder
    <int>[11, 23, 25], // left hip (LSh-LHip-LKn)
    <int>[12, 24, 26], // right hip
    <int>[23, 25, 27], // left knee (LHip-LKn-LAn)
    <int>[24, 26, 28], // right knee
  ];

  /// Tabular figures so the digits don't shift width as the angle changes.
  static const TextStyle _angleStyle = TextStyle(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    height: 1.0,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
    shadows: <Shadow>[
      Shadow(color: Colors.black, blurRadius: 3),
      Shadow(color: Colors.black, blurRadius: 2),
    ],
  );

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.length != 33) return;

    // Resolve every landmark to a canvas point, or null if it shouldn't show.
    final List<Offset?> points = List<Offset?>.filled(33, null);
    for (int i = 0; i < landmarks.length; i++) {
      final LandmarkEntity lm = landmarks[i];
      if (lm.confidence < _kDrawThreshold) continue;
      Offset o = PoseMath.normalizedToCanvas(lm, size, imageSize);
      // Display-only horizontal flip for the front camera. The landmark data
      // itself stays un-mirrored so angle/rep math (which is mirror-invariant)
      // keeps left/right identity — never feed mirrored coords back into math.
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

    // Angle labels next to each visible joint (left elbow, right elbow, …).
    if (showAngles) _paintAngles(canvas, points);
  }

  void _paintAngles(Canvas canvas, List<Offset?> points) {
    for (final List<int> j in _angleJoints) {
      final Offset? pa = points[j[0]];
      final Offset? pb = points[j[1]];
      final Offset? pc = points[j[2]];
      // Only label joints whose three points are all confidently visible.
      if (pa == null || pb == null || pc == null) continue;
      final double deg = PoseMath.calculateAngle3Points(
        landmarks[j[0]],
        landmarks[j[1]],
        landmarks[j[2]],
      );
      if (deg <= 0) continue; // degenerate (zero-length arm)

      final TextPainter tp = TextPainter(
        text: TextSpan(text: '${deg.round()}°', style: _angleStyle),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      // Offset the label slightly away from the joint so it doesn't sit under
      // the dot, biased outside the elbow/knee bend (a-b + b-c midpoint).
      final Offset bias = _labelBias(pa, pb, pc);
      tp.paint(canvas, pb + bias - Offset(tp.width / 2, tp.height / 2));
    }
  }

  /// A small offset away from the average of the two arms so the label sits on
  /// the outside of the bend, not over the bone. Falls back to a fixed up-right
  /// nudge if the geometry is degenerate.
  Offset _labelBias(Offset a, Offset b, Offset c) {
    final Offset ba = a - b;
    final Offset bc = c - b;
    final Offset sum = ba + bc;
    final double mag = sum.distance;
    const double dist = 14;
    if (mag < 1e-3) return const Offset(8, -10);
    return -sum * (dist / mag); // opposite to bisector → outside of bend
  }

  @override
  bool shouldRepaint(PoseOverlayPainter old) =>
      !identical(old.landmarks, landmarks) ||
      old.imageSize != imageSize ||
      old.mirror != mirror ||
      old.showAngles != showAngles;
}

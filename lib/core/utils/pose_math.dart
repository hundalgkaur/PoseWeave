import 'dart:math' as math;
import 'dart:ui';

import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Pure geometry helpers for pose work. No side effects, no Flutter widgets.
class PoseMath {
  const PoseMath._();

  /// Angle in degrees at vertex [b], formed by the points a-b-c.
  ///
  /// Uses the dot-product form of the law of cosines:
  ///   cos(theta) = (BA · BC) / (|BA| · |BC|)
  /// Returns 0 if either arm has zero length (degenerate, can't form an angle).
  /// Result is in [0, 180]; the cosine is clamped to [-1, 1] to absorb
  /// floating-point drift before `acos`.
  static double calculateAngle3Points(
    LandmarkEntity a,
    LandmarkEntity b,
    LandmarkEntity c,
  ) {
    final double baX = a.x - b.x;
    final double baY = a.y - b.y;
    final double bcX = c.x - b.x;
    final double bcY = c.y - b.y;

    final double dot = baX * bcX + baY * bcY;
    final double magBa = math.sqrt(baX * baX + baY * baY);
    final double magBc = math.sqrt(bcX * bcX + bcY * bcY);
    if (magBa == 0 || magBc == 0) return 0.0;

    final double cosAngle = (dot / (magBa * magBc)).clamp(-1.0, 1.0);
    return math.acos(cosAngle) * 180.0 / math.pi;
  }

  /// Maps a landmark's normalized (0..1) coordinates to a pixel [Offset] on a
  /// [canvasSize], preserving the source [imageSize]'s aspect ratio and
  /// letterboxing (centering) any leftover space — the same fit the camera
  /// preview uses, so dots land on the body rather than drifting off it.
  static Offset normalizedToCanvas(
    LandmarkEntity landmark,
    Size canvasSize,
    Size imageSize,
  ) {
    if (imageSize.width == 0 || imageSize.height == 0) {
      return Offset(
        landmark.x * canvasSize.width,
        landmark.y * canvasSize.height,
      );
    }

    final double scale = math.min(
      canvasSize.width / imageSize.width,
      canvasSize.height / imageSize.height,
    );
    final double drawnWidth = imageSize.width * scale;
    final double drawnHeight = imageSize.height * scale;
    final double offsetX = (canvasSize.width - drawnWidth) / 2;
    final double offsetY = (canvasSize.height - drawnHeight) / 2;

    return Offset(
      offsetX + landmark.x * drawnWidth,
      offsetY + landmark.y * drawnHeight,
    );
  }

  /// Rotates a 3D point around the Y then X axes (the gesture-driven turntable).
  static vm.Vector3 rotate3D(
    vm.Vector3 point,
    double rotationY,
    double rotationX,
  ) {
    final vm.Matrix4 m = vm.Matrix4.rotationY(rotationY)
      ..multiply(vm.Matrix4.rotationX(rotationX));
    return m.transformed3(point);
  }

  /// Projects a (rotated) 3D point onto the canvas with a simple perspective
  /// divide. Points farther away (larger z) shrink toward the center.
  /// [scale] sizes the figure; [focalLength] controls perspective strength.
  static Offset perspectiveProject(
    vm.Vector3 rotated,
    Size canvasSize,
    double focalLength,
    double scale,
  ) {
    final double f = focalLength / (focalLength + rotated.z);
    return Offset(
      canvasSize.width / 2 + rotated.x * scale * f,
      canvasSize.height / 2 + rotated.y * scale * f,
    );
  }

  /// Convenience: rotate then project in one call (unit scale).
  static Offset project3DTo2D(
    vm.Vector3 point,
    double rotationY,
    double rotationX,
    Size canvasSize,
    double focalLength,
  ) {
    return perspectiveProject(
      rotate3D(point, rotationY, rotationX),
      canvasSize,
      focalLength,
      1,
    );
  }
}

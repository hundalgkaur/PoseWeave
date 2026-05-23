import 'dart:math' as math;
import 'dart:ui';

import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

/// Anatomical classification of a joint angle.
enum AngleClassification {
  neutral,
  valgus, // knee collapsing inward (often hip weakness)
  varus, // knee bowing outward
  hyperflexed, // joint over-bent
  flexed, // normal flexion
  extended, // normal/full extension
  hyperextended, // locked past straight (injury risk)
}

/// Result of analyzing a single joint: the measured angle, its classification,
/// the limiting landmark confidence, and an optional risk flag.
class AngleAnalysis {
  const AngleAnalysis({
    required this.degrees,
    required this.classification,
    required this.confidence,
    this.riskFlag,
  });

  final double degrees;
  final AngleClassification classification;
  final double confidence;
  final String? riskFlag;

  /// True when this analysis carries a risk flag worth surfacing.
  bool get isRisk => riskFlag != null;
}

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

  /// Knee deviation threshold (normalized x) past which it reads as valgus/varus.
  static const double _kneeDeviation = 0.04;

  /// Classifies a knee from hip/knee/ankle. Frontal-plane deviation of the knee
  /// from the straight hip→ankle line marks valgus (inward collapse) or varus
  /// (outward bow); otherwise it's hyperflexed (<90°) or neutral.
  /// [isLeftSide] flips the inward direction so the sign means the same thing
  /// for both legs.
  static AngleAnalysis analyzeKnee({
    required LandmarkEntity hip,
    required LandmarkEntity knee,
    required LandmarkEntity ankle,
    required bool isLeftSide,
  }) {
    final double degrees = calculateAngle3Points(hip, knee, ankle);
    final double confidence = math.min(
      hip.confidence,
      math.min(knee.confidence, ankle.confidence),
    );

    // Where the straight hip→ankle line sits at the knee's height.
    final double dy = ankle.y - hip.y;
    final double lineX =
        dy.abs() < 1e-6
            ? hip.x
            : hip.x + (ankle.x - hip.x) * ((knee.y - hip.y) / dy);
    // Positive = inward (toward midline) for either leg.
    final double inward = (knee.x - lineX) * (isLeftSide ? 1 : -1);

    AngleClassification classification;
    String? risk;
    if (inward > _kneeDeviation) {
      classification = AngleClassification.valgus;
      risk = 'knee_valgus';
    } else if (inward < -_kneeDeviation) {
      classification = AngleClassification.varus;
      risk = 'knee_varus';
    } else if (degrees < 90) {
      classification = AngleClassification.hyperflexed;
    } else {
      classification = AngleClassification.neutral;
    }

    return AngleAnalysis(
      degrees: degrees,
      classification: classification,
      confidence: confidence,
      riskFlag: risk,
    );
  }

  /// Classifies an elbow (or any 3-point limb) by flexion only:
  /// <30° hyperflexed, 30–160° flexed, >160° extended.
  static AngleAnalysis analyzeElbow({
    required LandmarkEntity shoulder,
    required LandmarkEntity elbow,
    required LandmarkEntity wrist,
  }) {
    final double degrees = calculateAngle3Points(shoulder, elbow, wrist);
    final double confidence = math.min(
      shoulder.confidence,
      math.min(elbow.confidence, wrist.confidence),
    );
    final AngleClassification classification =
        degrees < 30
            ? AngleClassification.hyperflexed
            : (degrees > 160
                ? AngleClassification.extended
                : AngleClassification.flexed);
    return AngleAnalysis(
      degrees: degrees,
      classification: classification,
      confidence: confidence,
    );
  }
}

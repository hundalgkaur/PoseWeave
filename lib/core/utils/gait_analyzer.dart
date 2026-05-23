import 'dart:math' as math;

import 'package:poseweave/core/constants/analysis_constants.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Derives gait parameters from a time-ordered sequence of poses (a walking
/// clip). All heuristics are 2D-monocular estimates; speed and leg rotation are
/// the roughest (the UI labels them estimated). Everything is guarded so any
/// input — including degenerate/empty — yields finite values and never throws.
class GaitAnalyzer {
  const GaitAnalyzer._();

  static const double _assumedHeightM = 1.7;

  static GaitParameters analyze(
    List<PoseEntity> poses, {
    Duration sampleInterval = kVideoSampleInterval,
  }) {
    if (poses.isEmpty) return _empty(0);

    final double totalSeconds =
        (poses.length - 1) * sampleInterval.inMilliseconds / 1000.0;

    final List<double> lKnee = <double>[];
    final List<double> rKnee = <double>[];
    final List<double> lArm = <double>[];
    final List<double> rArm = <double>[];
    final List<double> ankleDx = <double>[];
    final List<double> lAnkleY = <double>[];
    final List<double> rAnkleY = <double>[];
    final List<double> hipX = <double>[];
    final List<double> bodyHeights = <double>[];
    final List<double> lFootAngle = <double>[];
    final List<double> rFootAngle = <double>[];
    double maxKneeFlexion = 0;

    for (final PoseEntity p in poses) {
      final double? lk = _angle(
        p,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftKnee,
        PoseLandmarkType.leftAnkle,
      );
      final double? rk = _angle(
        p,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightKnee,
        PoseLandmarkType.rightAnkle,
      );
      if (lk != null) {
        lKnee.add(lk);
        maxKneeFlexion = math.max(maxKneeFlexion, 180 - lk);
      }
      if (rk != null) {
        rKnee.add(rk);
        maxKneeFlexion = math.max(maxKneeFlexion, 180 - rk);
      }

      final double? la = _angle(
        p,
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
      );
      final double? ra = _angle(
        p,
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
      );
      if (la != null) lArm.add(la);
      if (ra != null) rArm.add(ra);

      final LandmarkEntity? lAnkle = p.getLandmark(PoseLandmarkType.leftAnkle);
      final LandmarkEntity? rAnkle = p.getLandmark(PoseLandmarkType.rightAnkle);
      if (lAnkle != null && rAnkle != null) ankleDx.add(lAnkle.x - rAnkle.x);
      if (lAnkle != null) lAnkleY.add(lAnkle.y);
      if (rAnkle != null) rAnkleY.add(rAnkle.y);

      final LandmarkEntity? lHip = p.getLandmark(PoseLandmarkType.leftHip);
      final LandmarkEntity? rHip = p.getLandmark(PoseLandmarkType.rightHip);
      if (lHip != null && rHip != null) hipX.add((lHip.x + rHip.x) / 2);

      final double? h = _bodyHeight(p);
      if (h != null) bodyHeights.add(h);

      final LandmarkEntity? lFoot = p.getLandmark(
        PoseLandmarkType.leftFootIndex,
      );
      final LandmarkEntity? rFoot = p.getLandmark(
        PoseLandmarkType.rightFootIndex,
      );
      if (lAnkle != null && lFoot != null) {
        lFootAngle.add(_footAngleDeg(lAnkle, lFoot));
      }
      if (rAnkle != null && rFoot != null) {
        rFootAngle.add(_footAngleDeg(rAnkle, rFoot));
      }
    }

    final double lKneeRom = _range(lKnee);
    final double rKneeRom = _range(rKnee);

    final int steps = _meanCrossings(ankleDx);
    final double cadence = totalSeconds > 0 ? steps / totalSeconds * 60 : 0;

    final ({double inDeg, double outDeg}) lRot = _legRotation(lFootAngle);
    final ({double inDeg, double outDeg}) rRot = _legRotation(rFootAngle);

    final double stance = _stancePercent(lAnkleY, rAnkleY);

    return GaitParameters(
      speedMps: _estimateSpeed(hipX, bodyHeights, totalSeconds),
      cadenceSpm: cadence,
      symmetryPercent: _symmetry(lKneeRom, rKneeRom),
      leftArmSwingDeg: _range(lArm),
      rightArmSwingDeg: _range(rArm),
      kneeFlexionMaxDeg: maxKneeFlexion,
      leftLegRotInDeg: lRot.inDeg,
      leftLegRotOutDeg: lRot.outDeg,
      rightLegRotInDeg: rRot.inDeg,
      rightLegRotOutDeg: rRot.outDeg,
      stancePercent: stance,
      swingPercent: 100 - stance,
      framesAnalyzed: poses.length,
    );
  }

  // --- helpers --------------------------------------------------------------

  static double? _angle(
    PoseEntity p,
    PoseLandmarkType a,
    PoseLandmarkType b,
    PoseLandmarkType c,
  ) {
    final LandmarkEntity? la = p.getLandmark(a);
    final LandmarkEntity? lb = p.getLandmark(b);
    final LandmarkEntity? lc = p.getLandmark(c);
    if (la == null || lb == null || lc == null) return null;
    return PoseMath.calculateAngle3Points(la, lb, lc);
  }

  /// Full-body vertical extent (normalized) — nose to lowest ankle.
  static double? _bodyHeight(PoseEntity p) {
    final LandmarkEntity? nose = p.getLandmark(PoseLandmarkType.nose);
    final LandmarkEntity? la = p.getLandmark(PoseLandmarkType.leftAnkle);
    final LandmarkEntity? ra = p.getLandmark(PoseLandmarkType.rightAnkle);
    if (nose == null || (la == null && ra == null)) return null;
    final double footY = math.max(la?.y ?? 0, ra?.y ?? 0);
    final double h = (footY - nose.y).abs();
    return h > 0 ? h : null;
  }

  /// Angle (deg) of the foot vector (ankle→toe) from the downward vertical.
  static double _footAngleDeg(LandmarkEntity ankle, LandmarkEntity foot) {
    return math.atan2(foot.x - ankle.x, (foot.y - ankle.y).abs() + 1e-6) *
        180 /
        math.pi;
  }

  static double _range(List<double> xs) {
    if (xs.length < 2) return 0;
    double lo = xs.first;
    double hi = xs.first;
    for (final double x in xs) {
      if (x < lo) lo = x;
      if (x > hi) hi = x;
    }
    return hi - lo;
  }

  /// Counts how often a signal crosses its mean — a coarse step counter.
  static int _meanCrossings(List<double> xs) {
    if (xs.length < 2) return 0;
    final double mean = xs.reduce((double a, double b) => a + b) / xs.length;
    int crossings = 0;
    bool? above;
    for (final double x in xs) {
      final bool isAbove = x >= mean;
      if (above != null && isAbove != above) crossings++;
      above = isAbove;
    }
    return crossings;
  }

  static double _symmetry(double left, double right) {
    final double max = math.max(left, right);
    if (max == 0) return 100;
    return (100 * (1 - (left - right).abs() / max)).clamp(0, 100);
  }

  /// Fraction of frames each foot is "planted" (in the lower part of its own
  /// vertical range), averaged across feet → stance %. Approximate.
  static double _stancePercent(List<double> lY, List<double> rY) {
    final double l = _plantedFraction(lY);
    final double r = _plantedFraction(rY);
    final int have = (lY.isNotEmpty ? 1 : 0) + (rY.isNotEmpty ? 1 : 0);
    if (have == 0) return 60; // sensible default
    return (((l + r) / have) * 100).clamp(0, 100);
  }

  static double _plantedFraction(List<double> ys) {
    if (ys.isEmpty) return 0;
    double lo = ys.first;
    double hi = ys.first;
    for (final double y in ys) {
      if (y < lo) lo = y;
      if (y > hi) hi = y;
    }
    if (hi - lo < 1e-6) return 1; // not moving → planted
    final double threshold = lo + 0.6 * (hi - lo); // lower 40% = planted
    final int planted = ys.where((double y) => y >= threshold).length;
    return planted / ys.length;
  }

  static ({double inDeg, double outDeg}) _legRotation(List<double> angles) {
    if (angles.isEmpty) return (inDeg: 0, outDeg: 0);
    double lo = angles.first;
    double hi = angles.first;
    for (final double a in angles) {
      if (a < lo) lo = a;
      if (a > hi) hi = a;
    }
    // Positive angle = toe-out, negative = toe-in (toward midline).
    return (
      inDeg: (lo < 0 ? -lo : 0).clamp(0, 45).toDouble(),
      outDeg: (hi > 0 ? hi : 0).clamp(0, 45).toDouble(),
    );
  }

  /// Estimated speed: scale normalized hip displacement to metres using an
  /// assumed subject height, divided by elapsed time. Rough — labeled estimated.
  static double _estimateSpeed(
    List<double> hipX,
    List<double> bodyHeights,
    double totalSeconds,
  ) {
    if (hipX.length < 2 || bodyHeights.isEmpty || totalSeconds <= 0) return 0;
    final double medianHeight = _median(bodyHeights);
    if (medianHeight <= 0) return 0;
    final double metresPerNorm = _assumedHeightM / medianHeight;
    final double displacementNorm = (hipX.last - hipX.first).abs();
    final double metres = displacementNorm * metresPerNorm;
    return (metres / totalSeconds).clamp(0, 10);
  }

  static double _median(List<double> xs) {
    final List<double> s = List<double>.from(xs)..sort();
    final int mid = s.length ~/ 2;
    return s.length.isOdd ? s[mid] : (s[mid - 1] + s[mid]) / 2;
  }

  static GaitParameters _empty(int frames) => GaitParameters(
    speedMps: 0,
    cadenceSpm: 0,
    symmetryPercent: 0,
    leftArmSwingDeg: 0,
    rightArmSwingDeg: 0,
    kneeFlexionMaxDeg: 0,
    leftLegRotInDeg: 0,
    leftLegRotOutDeg: 0,
    rightLegRotInDeg: 0,
    rightLegRotOutDeg: 0,
    stancePercent: 0,
    swingPercent: 0,
    framesAnalyzed: frames,
  );
}

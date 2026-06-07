import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_template.dart';

/// Builds a drawable front-facing "guide" skeleton from a [PoseTemplate]'s joint
/// angles, so the UI can show the *actual pose shape* the user should copy
/// (instead of a generic icon). Pure 2D forward kinematics: a fixed torso/head,
/// then each limb segment is rotated to realize the template's target angles —
/// so the guide is faithful by construction (its angles equal the template's).
///
/// It's a frontal approximation: angles are exact, but strongly side-on poses
/// (Triangle, deep folds) can only be hinted in 2D. No Flutter/ML Kit imports.
class PoseGuideBuilder {
  const PoseGuideBuilder._();

  // Canonical normalized landmarks (y grows downward).
  static const _V _lShoulder = _V(0.40, 0.30);
  static const _V _rShoulder = _V(0.60, 0.30);
  static const _V _lHip = _V(0.44, 0.56);
  static const _V _rHip = _V(0.56, 0.56);

  static const double _upperArm = 0.14;
  static const double _foreArm = 0.13;
  static const double _thigh = 0.18;
  static const double _shin = 0.17;

  /// Defaults when a template omits a joint (arms by the sides, limbs straight).
  static const double _defShoulder = 15;
  static const double _defElbow = 178;
  static const double _defHip = 178;
  static const double _defKnee = 178;

  static PoseEntity build(PoseTemplate t) {
    final Map<PoseLandmarkType, _V> p = <PoseLandmarkType, _V>{
      // Head cluster (fixed).
      PoseLandmarkType.nose: const _V(0.50, 0.16),
      PoseLandmarkType.leftEyeInner: const _V(0.485, 0.145),
      PoseLandmarkType.leftEye: const _V(0.475, 0.145),
      PoseLandmarkType.leftEyeOuter: const _V(0.465, 0.145),
      PoseLandmarkType.rightEyeInner: const _V(0.515, 0.145),
      PoseLandmarkType.rightEye: const _V(0.525, 0.145),
      PoseLandmarkType.rightEyeOuter: const _V(0.535, 0.145),
      PoseLandmarkType.leftEar: const _V(0.455, 0.155),
      PoseLandmarkType.rightEar: const _V(0.545, 0.155),
      PoseLandmarkType.leftMouth: const _V(0.487, 0.185),
      PoseLandmarkType.rightMouth: const _V(0.513, 0.185),
      // Torso (fixed).
      PoseLandmarkType.leftShoulder: _lShoulder,
      PoseLandmarkType.rightShoulder: _rShoulder,
      PoseLandmarkType.leftHip: _lHip,
      PoseLandmarkType.rightHip: _rHip,
    };

    _arm(p, t, left: true);
    _arm(p, t, left: false);
    _leg(p, t, left: true);
    _leg(p, t, left: false);

    return PoseEntity(
      landmarks: <LandmarkEntity>[
        for (final PoseLandmarkType type in PoseLandmarkType.values)
          LandmarkEntity(
            type: type,
            x: (p[type] ?? const _V(0.5, 0.5)).x,
            y: (p[type] ?? const _V(0.5, 0.5)).y,
            confidence: 0.95,
          ),
      ],
      timestamp: DateTime.now(),
      source: PoseSource.mock,
      imageSize: const Size(1, 1),
    );
  }

  static void _arm(
    Map<PoseLandmarkType, _V> p,
    PoseTemplate t, {
    required bool left,
  }) {
    final _V shoulder = left ? _lShoulder : _rShoulder;
    final double shoulderDeg = _target(
      t,
      left ? PoseLandmarkType.leftShoulder : PoseLandmarkType.rightShoulder,
      _defShoulder,
    );
    final double elbowDeg = _target(
      t,
      left ? PoseLandmarkType.leftElbow : PoseLandmarkType.rightElbow,
      _defElbow,
    );
    // Left arm rotates the downward vector +deg (toward screen-left & up);
    // right mirrors with -deg.
    final double sign = left ? 1 : -1;
    final _V elbowDir = _rot(const _V(0, 1), sign * shoulderDeg);
    final _V elbow = shoulder.add(elbowDir.scale(_upperArm));
    final _V elbowToShoulder = shoulder.sub(elbow).norm();
    final _V wristDir = _rot(elbowToShoulder, sign * elbowDeg);
    final _V wrist = elbow.add(wristDir.scale(_foreArm));

    if (left) {
      p[PoseLandmarkType.leftElbow] = elbow;
      p[PoseLandmarkType.leftWrist] = wrist;
      p[PoseLandmarkType.leftPinky] = wrist;
      p[PoseLandmarkType.leftIndex] = wrist;
      p[PoseLandmarkType.leftThumb] = wrist;
    } else {
      p[PoseLandmarkType.rightElbow] = elbow;
      p[PoseLandmarkType.rightWrist] = wrist;
      p[PoseLandmarkType.rightPinky] = wrist;
      p[PoseLandmarkType.rightIndex] = wrist;
      p[PoseLandmarkType.rightThumb] = wrist;
    }
  }

  static void _leg(
    Map<PoseLandmarkType, _V> p,
    PoseTemplate t, {
    required bool left,
  }) {
    final _V hip = left ? _lHip : _rHip;
    final double hipDeg = _target(
      t,
      left ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip,
      _defHip,
    );
    final double kneeDeg = _target(
      t,
      left ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee,
      _defKnee,
    );
    // Left knee splays toward screen-left (-deg from "up"); right mirrors.
    final double sign = left ? -1 : 1;
    final _V kneeDir = _rot(const _V(0, -1), sign * hipDeg);
    final _V knee = hip.add(kneeDir.scale(_thigh));
    final _V kneeToHip = hip.sub(knee).norm();
    final _V ankleDir = _rot(kneeToHip, sign * kneeDeg);
    final _V ankle = knee.add(ankleDir.scale(_shin));
    // Feet just below/ahead of the ankle.
    final _V foot = ankle.add(const _V(0, 0.03));

    if (left) {
      p[PoseLandmarkType.leftKnee] = knee;
      p[PoseLandmarkType.leftAnkle] = ankle;
      p[PoseLandmarkType.leftHeel] = ankle;
      p[PoseLandmarkType.leftFootIndex] = foot;
    } else {
      p[PoseLandmarkType.rightKnee] = knee;
      p[PoseLandmarkType.rightAnkle] = ankle;
      p[PoseLandmarkType.rightHeel] = ankle;
      p[PoseLandmarkType.rightFootIndex] = foot;
    }
  }

  /// The target angle (deg) for the constraint whose vertex is [vertex], else
  /// [fallback].
  static double _target(
    PoseTemplate t,
    PoseLandmarkType vertex,
    double fallback,
  ) {
    for (final JointConstraint c in t.constraints) {
      if (c.b == vertex) return c.targetDeg;
    }
    return fallback;
  }

  /// Rotate [v] by [deg] (screen coords: x right, y down).
  static _V _rot(_V v, double deg) {
    final double r = deg * math.pi / 180.0;
    final double c = math.cos(r);
    final double s = math.sin(r);
    return _V(v.x * c - v.y * s, v.x * s + v.y * c);
  }
}

/// Minimal 2D vector (normalized landmark space).
class _V {
  const _V(this.x, this.y);
  final double x;
  final double y;

  _V add(_V o) => _V(x + o.x, y + o.y);
  _V sub(_V o) => _V(x - o.x, y - o.y);
  _V scale(double k) => _V(x * k, y * k);
  _V norm() {
    final double len = math.sqrt(x * x + y * y);
    return len == 0 ? const _V(0, 0) : _V(x / len, y / len);
  }
}

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/rep_counter.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/rep_count_result.dart';

/// Builds a 33-landmark pose, overriding only the landmarks that matter for the
/// exercise under test; everything else sits at the center with [baseConf].
PoseEntity _poseWith(
  Map<PoseLandmarkType, LandmarkEntity> overrides, {
  double baseConf = 0.9,
}) {
  return PoseEntity(
    landmarks: <LandmarkEntity>[
      for (final PoseLandmarkType t in PoseLandmarkType.values)
        overrides[t] ??
            LandmarkEntity(type: t, x: 0.5, y: 0.5, confidence: baseConf),
    ],
    timestamp: DateTime(2026, 5, 24),
    source: PoseSource.mock,
    imageSize: const Size(1, 1),
  );
}

LandmarkEntity _at(PoseLandmarkType t, double x, double y, double conf) =>
    LandmarkEntity(type: t, x: x, y: y, confidence: conf);

/// A 3-point limb where the angle at the vertex equals [deg]. The proximal
/// point sits straight above the vertex; the distal point is rotated by
/// (180 - deg) from straight-down so [deg] is the included angle.
({Offset proximal, Offset vertex, Offset distal}) _limb(
  double deg,
  Offset vertex,
) {
  final double phi = (180 - deg) * math.pi / 180;
  return (
    proximal: Offset(vertex.dx, vertex.dy - 0.2),
    vertex: vertex,
    distal: Offset(vertex.dx + 0.2 * math.sin(phi), vertex.dy + 0.2 * math.cos(phi)),
  );
}

PoseEntity _armPose(double elbowDeg, {double conf = 0.9}) {
  final ({Offset proximal, Offset vertex, Offset distal}) l =
      _limb(elbowDeg, const Offset(0.4, 0.5));
  final ({Offset proximal, Offset vertex, Offset distal}) r =
      _limb(elbowDeg, const Offset(0.6, 0.5));
  return _poseWith(<PoseLandmarkType, LandmarkEntity>{
    PoseLandmarkType.leftShoulder: _at(PoseLandmarkType.leftShoulder, l.proximal.dx, l.proximal.dy, conf),
    PoseLandmarkType.leftElbow: _at(PoseLandmarkType.leftElbow, l.vertex.dx, l.vertex.dy, conf),
    PoseLandmarkType.leftWrist: _at(PoseLandmarkType.leftWrist, l.distal.dx, l.distal.dy, conf),
    PoseLandmarkType.rightShoulder: _at(PoseLandmarkType.rightShoulder, r.proximal.dx, r.proximal.dy, conf),
    PoseLandmarkType.rightElbow: _at(PoseLandmarkType.rightElbow, r.vertex.dx, r.vertex.dy, conf),
    PoseLandmarkType.rightWrist: _at(PoseLandmarkType.rightWrist, r.distal.dx, r.distal.dy, conf),
  });
}

PoseEntity _legPose(double kneeDeg, {double conf = 0.9}) {
  final ({Offset proximal, Offset vertex, Offset distal}) l =
      _limb(kneeDeg, const Offset(0.4, 0.5));
  final ({Offset proximal, Offset vertex, Offset distal}) r =
      _limb(kneeDeg, const Offset(0.6, 0.5));
  return _poseWith(<PoseLandmarkType, LandmarkEntity>{
    PoseLandmarkType.leftHip: _at(PoseLandmarkType.leftHip, l.proximal.dx, l.proximal.dy, conf),
    PoseLandmarkType.leftKnee: _at(PoseLandmarkType.leftKnee, l.vertex.dx, l.vertex.dy, conf),
    PoseLandmarkType.leftAnkle: _at(PoseLandmarkType.leftAnkle, l.distal.dx, l.distal.dy, conf),
    PoseLandmarkType.rightHip: _at(PoseLandmarkType.rightHip, r.proximal.dx, r.proximal.dy, conf),
    PoseLandmarkType.rightKnee: _at(PoseLandmarkType.rightKnee, r.vertex.dx, r.vertex.dy, conf),
    PoseLandmarkType.rightAnkle: _at(PoseLandmarkType.rightAnkle, r.distal.dx, r.distal.dy, conf),
  });
}

PoseEntity _hipPose(double hipDeg, {double conf = 0.9}) {
  final ({Offset proximal, Offset vertex, Offset distal}) l =
      _limb(hipDeg, const Offset(0.4, 0.5));
  final ({Offset proximal, Offset vertex, Offset distal}) r =
      _limb(hipDeg, const Offset(0.6, 0.5));
  return _poseWith(<PoseLandmarkType, LandmarkEntity>{
    PoseLandmarkType.leftShoulder: _at(PoseLandmarkType.leftShoulder, l.proximal.dx, l.proximal.dy, conf),
    PoseLandmarkType.leftHip: _at(PoseLandmarkType.leftHip, l.vertex.dx, l.vertex.dy, conf),
    PoseLandmarkType.leftKnee: _at(PoseLandmarkType.leftKnee, l.distal.dx, l.distal.dy, conf),
    PoseLandmarkType.rightShoulder: _at(PoseLandmarkType.rightShoulder, r.proximal.dx, r.proximal.dy, conf),
    PoseLandmarkType.rightHip: _at(PoseLandmarkType.rightHip, r.vertex.dx, r.vertex.dy, conf),
    PoseLandmarkType.rightKnee: _at(PoseLandmarkType.rightKnee, r.distal.dx, r.distal.dy, conf),
  });
}

PoseEntity _jackPose(double separation, {double conf = 0.9}) {
  return _poseWith(<PoseLandmarkType, LandmarkEntity>{
    PoseLandmarkType.leftAnkle:
        _at(PoseLandmarkType.leftAnkle, 0.5 - separation / 2, 0.8, conf),
    PoseLandmarkType.rightAnkle:
        _at(PoseLandmarkType.rightAnkle, 0.5 + separation / 2, 0.8, conf),
  });
}

void _feed(RepCounter c, PoseEntity p, int n) {
  for (int i = 0; i < n; i++) {
    c.update(p);
  }
}

void main() {
  group('RepCounter — squats', () {
    test('counts a full rep (stand → deep → stand)', () {
      final RepCounter c = RepCounter(Exercise.squat);
      _feed(c, _legPose(175), 6);
      _feed(c, _legPose(85), 8);
      _feed(c, _legPose(175), 8);
      expect(c.repCount, 1);
    });

    test('counts two reps across two cycles', () {
      final RepCounter c = RepCounter(Exercise.squat);
      for (int i = 0; i < 2; i++) {
        _feed(c, _legPose(175), 6);
        _feed(c, _legPose(85), 8);
        _feed(c, _legPose(175), 8);
      }
      expect(c.repCount, 2);
    });

    test('hysteresis: hovering in the dead-band does not complete a rep', () {
      final RepCounter c = RepCounter(Exercise.squat);
      _feed(c, _legPose(175), 6); // standing
      _feed(c, _legPose(85), 8); // entered the down phase
      _feed(c, _legPose(150), 10); // hover below the 160 exit threshold
      expect(c.repCount, 0, reason: 'never crossed the exit threshold');
    });

    test('low-confidence frames are ignored (no count)', () {
      final RepCounter c = RepCounter(Exercise.squat);
      _feed(c, _legPose(175), 6);
      _feed(c, _legPose(85, conf: 0.2), 8); // invisible joints → skipped
      _feed(c, _legPose(175), 8);
      expect(c.repCount, 0);
    });

    test('degenerate all-at-one-point pose does not throw', () {
      final RepCounter c = RepCounter(Exercise.squat);
      final RepCountResult r = c.update(
        _poseWith(const <PoseLandmarkType, LandmarkEntity>{}),
      );
      expect(r, isA<RepCountResult>());
    });
  });

  group('RepCounter — form quality', () {
    test('deep push-ups score good form', () {
      final RepCounter c = RepCounter(Exercise.pushup);
      _feed(c, _armPose(170), 6);
      _feed(c, _armPose(80), 8); // below the 95° "good" depth
      _feed(c, _armPose(170), 8);
      expect(c.repCount, 1);
      // The last completed rep is reflected in a final update.
      final RepCountResult r = c.update(_armPose(170));
      expect(r.formQuality, FormQuality.good);
    });

    test('shallow push-ups score partial form', () {
      final RepCounter c = RepCounter(Exercise.pushup);
      _feed(c, _armPose(170), 6);
      _feed(c, _armPose(105), 10); // enters active but never reaches 95°
      _feed(c, _armPose(170), 8);
      expect(c.repCount, 1);
      final RepCountResult r = c.update(_armPose(170));
      expect(r.formQuality, FormQuality.partial);
    });
  });

  group('RepCounter — other exercises', () {
    test('counts a bicep curl', () {
      final RepCounter c = RepCounter(Exercise.bicepCurl);
      _feed(c, _armPose(170), 6);
      _feed(c, _armPose(40), 8);
      _feed(c, _armPose(170), 8);
      expect(c.repCount, 1);
    });

    test('counts a sit-up', () {
      final RepCounter c = RepCounter(Exercise.situp);
      _feed(c, _hipPose(170), 6); // lying back
      _feed(c, _hipPose(60), 8); // curled up
      _feed(c, _hipPose(170), 8);
      expect(c.repCount, 1);
    });

    test('counts a jumping jack', () {
      final RepCounter c = RepCounter(Exercise.jumpingJack);
      _feed(c, _jackPose(0.08), 6); // closed
      _feed(c, _jackPose(0.42), 8); // open
      _feed(c, _jackPose(0.08), 8); // closed
      expect(c.repCount, 1);
    });
  });

  group('RepCounter — live vs video parity', () {
    test('analyze() over a list equals streaming update()', () {
      final List<PoseEntity> seq = <PoseEntity>[
        ...List<PoseEntity>.filled(6, _legPose(175)),
        ...List<PoseEntity>.filled(8, _legPose(85)),
        ...List<PoseEntity>.filled(8, _legPose(175)),
        ...List<PoseEntity>.filled(8, _legPose(85)),
        ...List<PoseEntity>.filled(8, _legPose(175)),
      ];
      final RepCounter streaming = RepCounter(Exercise.squat);
      for (final PoseEntity p in seq) {
        streaming.update(p);
      }
      final RepCountResult batch = RepCounter.analyze(Exercise.squat, seq);
      expect(batch.repCount, streaming.repCount);
      expect(batch.repCount, 2);
    });

    test('analyze() on empty list returns initial', () {
      expect(
        RepCounter.analyze(Exercise.squat, const <PoseEntity>[]),
        RepCountResult.initial,
      );
    });
  });
}

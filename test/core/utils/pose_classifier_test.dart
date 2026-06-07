import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/pose_classifier.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';

/// Base T-pose coordinates: shoulders over hips (so the shoulder angle is a
/// clean 90°), arms straight out horizontally, legs straight down.
const Map<PoseLandmarkType, Offset> _tPoseBase = <PoseLandmarkType, Offset>{
  PoseLandmarkType.leftShoulder: Offset(0.4, 0.3),
  PoseLandmarkType.rightShoulder: Offset(0.6, 0.3),
  PoseLandmarkType.leftHip: Offset(0.4, 0.6),
  PoseLandmarkType.rightHip: Offset(0.6, 0.6),
  PoseLandmarkType.leftElbow: Offset(0.25, 0.3),
  PoseLandmarkType.leftWrist: Offset(0.1, 0.3),
  PoseLandmarkType.rightElbow: Offset(0.75, 0.3),
  PoseLandmarkType.rightWrist: Offset(0.9, 0.3),
  PoseLandmarkType.leftKnee: Offset(0.4, 0.78),
  PoseLandmarkType.rightKnee: Offset(0.6, 0.78),
  PoseLandmarkType.leftAnkle: Offset(0.4, 0.95),
  PoseLandmarkType.rightAnkle: Offset(0.6, 0.95),
};

PoseEntity _poseFrom(
  Map<PoseLandmarkType, Offset> coords, {
  double conf = 0.9,
  double scale = 1.0,
}) {
  Offset scaled(Offset o) =>
      Offset(0.5 + (o.dx - 0.5) * scale, 0.5 + (o.dy - 0.5) * scale);
  return PoseEntity(
    landmarks: <LandmarkEntity>[
      for (final PoseLandmarkType t in PoseLandmarkType.values)
        coords.containsKey(t)
            ? LandmarkEntity(
                type: t,
                x: scaled(coords[t] ?? Offset.zero).dx,
                y: scaled(coords[t] ?? Offset.zero).dy,
                confidence: conf,
              )
            : LandmarkEntity(type: t, x: 0.5, y: 0.5, confidence: conf),
    ],
    timestamp: DateTime(2026, 5, 24),
    source: PoseSource.mock,
    imageSize: const Size(1, 1),
  );
}

void main() {
  group('PoseClassifier', () {
    test('an exact T-pose matches "T-Pose" with high confidence', () {
      final PoseMatchResult r = PoseClassifier.classify(_poseFrom(_tPoseBase));
      expect(r.poseName, 'T-Pose');
      expect(r.matchPercent, greaterThan(85));
    });

    test('a bent arm lowers the score and lists the off joint', () {
      final Map<PoseLandmarkType, Offset> bent =
          Map<PoseLandmarkType, Offset>.from(_tPoseBase)
            // Bend the left elbow to ~140° — clearly off T-Pose's straight-arm
            // target (and not the 90° of Cactus Arms), so it still reads T-Pose.
            ..[PoseLandmarkType.leftWrist] = const Offset(0.12, 0.40);
      final PoseMatchResult clean =
          PoseClassifier.classify(_poseFrom(_tPoseBase));
      final PoseMatchResult r = PoseClassifier.classify(_poseFrom(bent));
      expect(r.poseName, 'T-Pose');
      expect(r.matchPercent, lessThan(clean.matchPercent));
      expect(
        r.deviations.any((JointDeviation d) => d.label == 'Left elbow'),
        isTrue,
      );
    });

    test('a neutral/ambiguous pose returns "No match"', () {
      final PoseEntity neutral = PoseEntity(
        landmarks: <LandmarkEntity>[
          for (final PoseLandmarkType t in PoseLandmarkType.values)
            LandmarkEntity(type: t, x: 0.5, y: 0.5, confidence: 0.9),
        ],
        timestamp: DateTime(2026, 5, 24),
        source: PoseSource.mock,
        imageSize: const Size(1, 1),
      );
      expect(PoseClassifier.classify(neutral).poseName,
          PoseMatchResult.noMatchName);
    });

    test('low-confidence joints are excluded (reports no match, not wrong)', () {
      final PoseMatchResult r =
          PoseClassifier.classify(_poseFrom(_tPoseBase, conf: 0.2));
      expect(r.poseName, PoseMatchResult.noMatchName);
    });

    test('scale invariance: a smaller T-pose still matches "T-Pose"', () {
      final PoseMatchResult full =
          PoseClassifier.classify(_poseFrom(_tPoseBase));
      final PoseMatchResult small =
          PoseClassifier.classify(_poseFrom(_tPoseBase, scale: 0.5));
      expect(small.poseName, 'T-Pose');
      expect((small.matchPercent - full.matchPercent).abs(), lessThan(1.0));
    });

    // Arms out level (like T-Pose) but the left knee is bent — a left-lead
    // Warrior II. Should beat T-Pose (whose straight-knee rule is now off).
    test('a Warrior II pose (arms out, one knee bent) matches "Warrior II"', () {
      final Map<PoseLandmarkType, Offset> warrior =
          Map<PoseLandmarkType, Offset>.from(_tPoseBase)
            ..[PoseLandmarkType.leftAnkle] = const Offset(0.55, 0.9);
      final PoseMatchResult r = PoseClassifier.classify(_poseFrom(warrior));
      expect(r.poseName, 'Warrior II');
    });

    test('summarize returns the dominant pose held across a clip', () {
      final List<PoseEntity> clip = <PoseEntity>[
        for (int i = 0; i < 8; i++) _poseFrom(_tPoseBase),
      ];
      final PoseMatchResult r = PoseClassifier.summarize(clip);
      expect(r.poseName, 'T-Pose');
      expect(r.matchPercent, greaterThan(85));
    });

    test('summarize on an empty clip returns "No match"', () {
      expect(
        PoseClassifier.summarize(const <PoseEntity>[]).poseName,
        PoseMatchResult.noMatchName,
      );
    });

    group('matchPose (uploaded reference)', () {
      test('a pose matched against itself scores ~100%', () {
        final PoseEntity p = _poseFrom(_tPoseBase);
        final PoseMatchResult r = PoseClassifier.matchPose(p, p);
        expect(r.matchPercent, greaterThan(95));
        expect(r.deviations, isEmpty);
      });

      test('a different pose scores lower and lists the off joint', () {
        final PoseEntity reference = _poseFrom(_tPoseBase);
        final Map<PoseLandmarkType, Offset> bent =
            Map<PoseLandmarkType, Offset>.from(_tPoseBase)
              ..[PoseLandmarkType.leftWrist] = const Offset(0.12, 0.40);
        final PoseMatchResult r =
            PoseClassifier.matchPose(_poseFrom(bent), reference);
        expect(r.matchPercent, lessThan(100));
        expect(
          r.deviations.any((JointDeviation d) => d.label == 'Left elbow'),
          isTrue,
        );
      });

      test('all-low-confidence joints are excluded → no match', () {
        final PoseEntity ref = _poseFrom(_tPoseBase);
        final PoseEntity weak = _poseFrom(_tPoseBase, conf: 0.2);
        expect(
          PoseClassifier.matchPose(weak, ref).poseName,
          PoseMatchResult.noMatchName,
        );
      });
    });
  });
}

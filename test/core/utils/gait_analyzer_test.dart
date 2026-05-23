import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/gait_analyzer.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Builds a synthetic, left/right-symmetric walking pose at phase [t] (radians).
PoseEntity _walkingPose(double t) {
  final double s = math.sin(t);
  final Map<PoseLandmarkType, List<double>> pos =
      <PoseLandmarkType, List<double>>{
        for (final PoseLandmarkType type in PoseLandmarkType.values)
          type: <double>[0.5, 0.5],
        PoseLandmarkType.nose: <double>[0.5, 0.10],
        PoseLandmarkType.leftShoulder: <double>[0.55, 0.30],
        PoseLandmarkType.rightShoulder: <double>[0.45, 0.30],
        PoseLandmarkType.leftElbow: <double>[0.60, 0.40 + 0.05 * s],
        PoseLandmarkType.rightElbow: <double>[0.40, 0.40 - 0.05 * s],
        PoseLandmarkType.leftWrist: <double>[0.62, 0.50 + 0.05 * s],
        PoseLandmarkType.rightWrist: <double>[0.38, 0.50 - 0.05 * s],
        PoseLandmarkType.leftHip: <double>[0.52, 0.55],
        PoseLandmarkType.rightHip: <double>[0.48, 0.55],
        PoseLandmarkType.leftKnee: <double>[0.52 + 0.06 * s, 0.70],
        PoseLandmarkType.rightKnee: <double>[0.48 - 0.06 * s, 0.70],
        PoseLandmarkType.leftAnkle: <double>[0.52 + 0.10 * s, 0.88],
        PoseLandmarkType.rightAnkle: <double>[0.48 - 0.10 * s, 0.88],
        PoseLandmarkType.leftFootIndex: <double>[0.54 + 0.10 * s, 0.90],
        PoseLandmarkType.rightFootIndex: <double>[0.46 - 0.10 * s, 0.90],
      };
  return PoseEntity(
    landmarks: <LandmarkEntity>[
      for (final PoseLandmarkType type in PoseLandmarkType.values)
        LandmarkEntity(
          type: type,
          x: pos[type]![0],
          y: pos[type]![1],
          confidence: 0.9,
        ),
    ],
    timestamp: DateTime(2026),
    source: PoseSource.videoFile,
    imageSize: const Size(1, 1),
  );
}

void main() {
  group('GaitAnalyzer', () {
    test('symmetric walking sequence yields plausible parameters', () {
      final List<PoseEntity> poses = <PoseEntity>[
        for (int i = 0; i < 20; i++) _walkingPose(i / 20 * 2 * math.pi * 2),
      ];
      final GaitParameters g = GaitAnalyzer.analyze(poses);

      expect(g.framesAnalyzed, 20);
      expect(g.cadenceSpm, greaterThan(0));
      expect(g.kneeFlexionMaxDeg, greaterThan(0));
      expect(g.kneeFlexionMaxDeg, lessThan(180));
      expect(g.symmetryPercent, closeTo(100, 1)); // mirror-symmetric input
      expect(g.stancePercent + g.swingPercent, closeTo(100, 0.01));
    });

    test('a still sequence has ~zero cadence and never throws', () {
      final List<PoseEntity> still = <PoseEntity>[
        for (int i = 0; i < 10; i++) _walkingPose(0),
      ];
      final GaitParameters g = GaitAnalyzer.analyze(still);
      expect(g.cadenceSpm, 0);
    });

    test('empty input returns zeros without throwing', () {
      final GaitParameters g = GaitAnalyzer.analyze(<PoseEntity>[]);
      expect(g.framesAnalyzed, 0);
      expect(g.cadenceSpm, 0);
    });
  });
}

import 'dart:ui';

import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Builds a valid 33-landmark pose for tests.
PoseEntity buildTestPose({double confidence = 0.9}) {
  return PoseEntity(
    landmarks: <LandmarkEntity>[
      for (final PoseLandmarkType type in PoseLandmarkType.values)
        LandmarkEntity(type: type, x: 0.5, y: 0.5, confidence: confidence),
    ],
    timestamp: DateTime(2026, 5, 22),
    source: PoseSource.mock,
    imageSize: const Size(1, 1),
  );
}

LandmarkEntity landmarkAt(double x, double y) => LandmarkEntity(
      type: PoseLandmarkType.nose,
      x: x,
      y: y,
      confidence: 1,
    );

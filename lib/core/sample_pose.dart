import 'dart:ui' show Size;

import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// A built-in standing pose with depth (non-zero z), used by the 3D viewer when
/// no real pose has been captured yet — so the screen always has something to
/// rotate. x,y are normalized; z varies (arms forward, feet back) so rotation
/// visibly reveals depth.
PoseEntity sampleStandingPose() {
  const Map<int, List<double>> base = <int, List<double>>{
    0: <double>[0.50, 0.12, 0.10],
    1: <double>[0.52, 0.10, 0.10],
    2: <double>[0.53, 0.10, 0.10],
    3: <double>[0.54, 0.10, 0.08],
    4: <double>[0.48, 0.10, 0.10],
    5: <double>[0.47, 0.10, 0.10],
    6: <double>[0.46, 0.10, 0.08],
    7: <double>[0.55, 0.11, -0.02],
    8: <double>[0.45, 0.11, -0.02],
    9: <double>[0.52, 0.14, 0.10],
    10: <double>[0.48, 0.14, 0.10],
    11: <double>[0.60, 0.25, 0.0],
    12: <double>[0.40, 0.25, 0.0],
    13: <double>[0.65, 0.38, -0.10],
    14: <double>[0.35, 0.38, -0.10],
    15: <double>[0.68, 0.50, -0.20],
    16: <double>[0.32, 0.50, -0.20],
    17: <double>[0.69, 0.53, -0.22],
    18: <double>[0.31, 0.53, -0.22],
    19: <double>[0.70, 0.53, -0.22],
    20: <double>[0.30, 0.53, -0.22],
    21: <double>[0.67, 0.52, -0.18],
    22: <double>[0.33, 0.52, -0.18],
    23: <double>[0.56, 0.55, 0.0],
    24: <double>[0.44, 0.55, 0.0],
    25: <double>[0.57, 0.72, 0.05],
    26: <double>[0.43, 0.72, 0.05],
    27: <double>[0.58, 0.90, 0.10],
    28: <double>[0.42, 0.90, 0.10],
    29: <double>[0.57, 0.92, 0.12],
    30: <double>[0.43, 0.92, 0.12],
    31: <double>[0.60, 0.93, 0.0],
    32: <double>[0.40, 0.93, 0.0],
  };

  return PoseEntity(
    landmarks: <LandmarkEntity>[
      for (final PoseLandmarkType type in PoseLandmarkType.values)
        LandmarkEntity(
          type: type,
          x: base[type.index]![0],
          y: base[type.index]![1],
          z: base[type.index]![2],
          confidence: 0.95,
        ),
    ],
    timestamp: DateTime.now(),
    source: PoseSource.mock,
    imageSize: const Size(1, 1),
  );
}

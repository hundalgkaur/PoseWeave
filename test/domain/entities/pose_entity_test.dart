import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

import '../../helpers/test_data.dart';

void main() {
  group('PoseEntity', () {
    test('accepts exactly 33 landmarks', () {
      expect(buildTestPose().landmarks.length, 33);
    });

    test('throws if not given 33 landmarks', () {
      expect(
        () => PoseEntity(
          landmarks: <LandmarkEntity>[landmarkAt(0, 0)],
          timestamp: DateTime(2026),
          source: PoseSource.mock,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('getLandmark returns the requested type', () {
      final PoseEntity pose = buildTestPose();
      expect(
        pose.getLandmark(PoseLandmarkType.leftShoulder)?.type,
        PoseLandmarkType.leftShoulder,
      );
    });

    test('averageConfidence is the mean across landmarks', () {
      expect(
        buildTestPose(confidence: 0.8).averageConfidence,
        closeTo(0.8, 1e-9),
      );
    });

    test('isVisible reflects the 0.5 threshold', () {
      expect(landmarkAt(0, 0).isVisible, isTrue); // confidence 1.0
      const LandmarkEntity low = LandmarkEntity(
        type: PoseLandmarkType.nose,
        x: 0,
        y: 0,
        confidence: 0.3,
      );
      expect(low.isVisible, isFalse);
    });
  });
}

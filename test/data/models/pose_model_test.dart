import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/data/models/landmark_model.dart';
import 'package:poseweave/data/models/pose_model.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

void main() {
  group('LandmarkModel', () {
    test('round-trips through entity', () {
      const LandmarkModel model = LandmarkModel(
        type: PoseLandmarkType.leftWrist,
        x: 0.25,
        y: 0.75,
        confidence: 0.6,
        z: 0.1,
      );
      final LandmarkEntity entity = model.toEntity();
      expect(entity.type, PoseLandmarkType.leftWrist);
      expect(entity.x, 0.25);
      expect(LandmarkModel.fromEntity(entity), model);
    });
  });

  group('PoseModel JSON export', () {
    test('fromEntity then toJson/fromJson round-trips', () {
      final PoseModel model = PoseModel(
        landmarks: <LandmarkModel>[
          for (final PoseLandmarkType t in PoseLandmarkType.values)
            LandmarkModel(type: t, x: 0.1, y: 0.2, confidence: 0.7, z: 0.3),
        ],
        timestamp: DateTime(2026),
        source: PoseSource.mock,
        imageWidth: 1,
        imageHeight: 1,
      );
      // entity -> model -> json -> model
      final PoseModel rebuilt = PoseModel.fromJson(
        PoseModel.fromEntity(model.toEntity()).toJson(),
      );
      expect(rebuilt.landmarks.length, 33);
      expect(rebuilt.source, PoseSource.mock);
      expect(rebuilt.landmarks.first.type, PoseLandmarkType.nose);
      expect(rebuilt.landmarks.first.z, 0.3);
    });
  });

  group('PoseModel.toEntity', () {
    test('produces a 33-landmark entity with image size', () {
      final PoseModel model = PoseModel(
        landmarks: <LandmarkModel>[
          for (final PoseLandmarkType t in PoseLandmarkType.values)
            LandmarkModel(type: t, x: 0.5, y: 0.5, confidence: 0.9),
        ],
        timestamp: DateTime(2026),
        source: PoseSource.videoFile,
        imageWidth: 640,
        imageHeight: 480,
      );
      final PoseEntity entity = model.toEntity();
      expect(entity.landmarks.length, 33);
      expect(entity.imageSize?.width, 640);
      expect(entity.source, PoseSource.videoFile);
    });
  });
}

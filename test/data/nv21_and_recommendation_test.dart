import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/data/datasources/mlkit_camera_datasource_impl.dart';
import 'package:poseweave/data/services/recommendation_prompt_builder.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';

void main() {
  group('yuv420ToNv21', () {
    test('packs Y then interleaved V,U for a 2x2 frame', () {
      final Uint8List y = Uint8List.fromList(<int>[1, 2, 3, 4]);
      final Uint8List u = Uint8List.fromList(<int>[100]);
      final Uint8List v = Uint8List.fromList(<int>[200]);

      final Uint8List out = yuv420ToNv21(
        width: 2,
        height: 2,
        y: y,
        yRowStride: 2,
        u: u,
        uRowStride: 1,
        uPixelStride: 1,
        v: v,
        vRowStride: 1,
        vPixelStride: 1,
      );

      expect(out.length, 6); // 2*2 Y + 2 chroma
      expect(out.sublist(0, 4), <int>[1, 2, 3, 4]);
      expect(out[4], 200); // V before U (NV21)
      expect(out[5], 100);
    });

    test('drops right-edge Y row padding (rowStride > width)', () {
      // Two rows of width 2 with 2 padding bytes each.
      final Uint8List y =
          Uint8List.fromList(<int>[1, 2, 0, 0, 3, 4, 0, 0]);
      final Uint8List u = Uint8List.fromList(<int>[10]);
      final Uint8List v = Uint8List.fromList(<int>[20]);

      final Uint8List out = yuv420ToNv21(
        width: 2,
        height: 2,
        y: y,
        yRowStride: 4,
        u: u,
        uRowStride: 1,
        uPixelStride: 1,
        v: v,
        vRowStride: 1,
        vPixelStride: 1,
      );

      expect(out.sublist(0, 4), <int>[1, 2, 3, 4]);
      expect(out[4], 20);
      expect(out[5], 10);
    });

    test('honors interleaved chroma pixelStride (semi-planar)', () {
      final Uint8List y = Uint8List.fromList(<int>[1, 2, 3, 4]);
      final Uint8List u = Uint8List.fromList(<int>[50, 99]);
      final Uint8List v = Uint8List.fromList(<int>[60, 88]);

      final Uint8List out = yuv420ToNv21(
        width: 2,
        height: 2,
        y: y,
        yRowStride: 2,
        u: u,
        uRowStride: 2,
        uPixelStride: 2,
        v: v,
        vRowStride: 2,
        vPixelStride: 2,
      );

      expect(out.length, 6);
      expect(out[4], 60); // first V sample
      expect(out[5], 50); // first U sample
    });
  });

  group('RecommendationPromptBuilder.parse', () {
    test('parses a plain JSON array (Gemini JSON mime)', () {
      final List<RecommendationEntity> items = RecommendationPromptBuilder.parse(
        '[{"title":"Strengthen left knee","detail":"Add squats",'
        '"severity":"high","bodyPart":"left knee"}]',
      );
      expect(items.length, 1);
      expect(items.first.severity, Severity.high);
      expect(items.first.bodyPart, 'left knee');
    });

    test('tolerates markdown fences', () {
      final List<RecommendationEntity> items = RecommendationPromptBuilder.parse(
        '```json\n[{"title":"A","detail":"B","severity":"low","bodyPart":"x"}]\n```',
      );
      expect(items.length, 1);
      expect(items.first.title, 'A');
    });
  });
}

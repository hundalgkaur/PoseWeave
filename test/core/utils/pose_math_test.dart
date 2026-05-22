import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../../helpers/test_data.dart';

void main() {
  group('PoseMath.calculateAngle3Points', () {
    test('returns 90 degrees for a right angle', () {
      final double angle = PoseMath.calculateAngle3Points(
        landmarkAt(0, 1),
        landmarkAt(0, 0),
        landmarkAt(1, 0),
      );
      expect(angle, closeTo(90, 0.001));
    });

    test('returns 180 degrees for a straight line', () {
      final double angle = PoseMath.calculateAngle3Points(
        landmarkAt(0, 0),
        landmarkAt(1, 0),
        landmarkAt(2, 0),
      );
      expect(angle, closeTo(180, 0.001));
    });

    test('returns 0 for a degenerate (zero-length) arm', () {
      final double angle = PoseMath.calculateAngle3Points(
        landmarkAt(1, 1),
        landmarkAt(1, 1),
        landmarkAt(2, 2),
      );
      expect(angle, 0);
    });
  });

  group('PoseMath.normalizedToCanvas', () {
    test('centers a midpoint of a square image on a square canvas', () {
      final Offset o = PoseMath.normalizedToCanvas(
        landmarkAt(0.5, 0.5),
        const Size(100, 100),
        const Size(1, 1),
      );
      expect(o.dx, closeTo(50, 0.001));
      expect(o.dy, closeTo(50, 0.001));
    });

    test('letterboxes a square image into a wide canvas', () {
      // 200x100 canvas, square image -> drawn 100x100 centered, offsetX = 50.
      final Offset o = PoseMath.normalizedToCanvas(
        landmarkAt(0, 0),
        const Size(200, 100),
        const Size(1, 1),
      );
      expect(o.dx, closeTo(50, 0.001));
      expect(o.dy, closeTo(0, 0.001));
    });
  });

  group('PoseMath 3D projection', () {
    test('origin projects to the canvas center', () {
      final Offset o = PoseMath.project3DTo2D(
        vm.Vector3.zero(),
        0,
        0,
        const Size(200, 200),
        4,
      );
      expect(o.dx, closeTo(100, 1e-6));
      expect(o.dy, closeTo(100, 1e-6));
    });

    test('90° Y rotation collapses the x of a point on the x-axis', () {
      final vm.Vector3 r = PoseMath.rotate3D(vm.Vector3(1, 0, 0), math.pi / 2, 0);
      expect(r.x, closeTo(0, 1e-6));
    });
  });
}

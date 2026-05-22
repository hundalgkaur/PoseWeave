import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/constants/pose_constants.dart';

void main() {
  group('PoseBones', () {
    test('defines exactly 32 bone connections', () {
      expect(PoseBones.connections.length, 32);
    });

    test('every connection joins two distinct valid landmark indices', () {
      for (final List<int> bone in PoseBones.connections) {
        expect(bone.length, 2);
        expect(bone[0], isNot(bone[1]));
        expect(bone[0], inInclusiveRange(0, 32));
        expect(bone[1], inInclusiveRange(0, 32));
      }
    });

    test('region ranges cover all 32 bone indices contiguously', () {
      final List<List<int>> ranges = PoseBones.regionRanges.values.toList();
      expect(ranges.first[0], 0);
      expect(ranges.last[1], 31);
    });

    test('colorForBone maps regions to their palette color', () {
      expect(PoseBones.colorForBone(0), const Color(0xFF00E5FF)); // face
      expect(PoseBones.colorForBone(31), const Color(0xFF448AFF)); // right leg
    });
  });
}

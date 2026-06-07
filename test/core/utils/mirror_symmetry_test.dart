import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Locks the §8.5 decision: the front-camera mirror is display-only. The angle
/// math must be mirror-invariant, so mirroring the coordinates (x → 1-x) and
/// swapping the side flag yields the same angle and the same valgus/varus class.
LandmarkEntity _p(double x, double y, {double conf = 1}) =>
    LandmarkEntity(type: PoseLandmarkType.nose, x: x, y: y, confidence: conf);

LandmarkEntity _mirror(LandmarkEntity e) =>
    LandmarkEntity(type: e.type, x: 1 - e.x, y: e.y, confidence: e.confidence);

void main() {
  test('calculateAngle3Points is invariant under horizontal mirror', () {
    final LandmarkEntity a = _p(0.6, 0.3);
    final LandmarkEntity b = _p(0.55, 0.55);
    final LandmarkEntity c = _p(0.6, 0.8);

    final double original = PoseMath.calculateAngle3Points(a, b, c);
    final double mirrored = PoseMath.calculateAngle3Points(
      _mirror(a),
      _mirror(b),
      _mirror(c),
    );
    expect(mirrored, closeTo(original, 1e-9));
  });

  test('analyzeKnee: mirror + side-swap preserves angle and classification', () {
    // A left leg with the knee deviated off the hip→ankle line.
    final LandmarkEntity hip = _p(0.6, 0.5);
    final LandmarkEntity knee = _p(0.55, 0.7);
    final LandmarkEntity ankle = _p(0.6, 0.9);

    final AngleAnalysis left = PoseMath.analyzeKnee(
      hip: hip,
      knee: knee,
      ankle: ankle,
      isLeftSide: true,
    );

    // Mirror to the right side: x → 1-x and treat as the right leg.
    final AngleAnalysis right = PoseMath.analyzeKnee(
      hip: _mirror(hip),
      knee: _mirror(knee),
      ankle: _mirror(ankle),
      isLeftSide: false,
    );

    expect(right.degrees, closeTo(left.degrees, 1e-9));
    expect(right.classification, left.classification);
    expect(right.riskFlag, left.riskFlag);
  });
}

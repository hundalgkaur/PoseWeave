import 'package:flutter_test/flutter_test.dart';
import 'package:poseweave/core/utils/clinical_assessment.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';

GaitParameters _gait({
  double speed = 1.3,
  double cadence = 108,
  double symmetry = 96,
  double kneeFlex = 60,
}) => GaitParameters(
  speedMps: speed,
  cadenceSpm: cadence,
  symmetryPercent: symmetry,
  leftArmSwingDeg: 20,
  rightArmSwingDeg: 20,
  kneeFlexionMaxDeg: kneeFlex,
  leftLegRotInDeg: 0,
  leftLegRotOutDeg: 0,
  rightLegRotInDeg: 0,
  rightLegRotOutDeg: 0,
  stancePercent: 60,
  swingPercent: 40,
  framesAnalyzed: 10,
);

void main() {
  group('ClinicalAssessment', () {
    test('cadence bands', () {
      expect(ClinicalAssessment.cadenceStatus(108), ClinicalStatus.normal);
      expect(ClinicalAssessment.cadenceStatus(120), ClinicalStatus.warning);
      expect(ClinicalAssessment.cadenceStatus(128), ClinicalStatus.critical);
    });

    test('symmetry bands', () {
      expect(ClinicalAssessment.symmetryStatus(96), ClinicalStatus.normal);
      expect(ClinicalAssessment.symmetryStatus(88), ClinicalStatus.warning);
      expect(ClinicalAssessment.symmetryStatus(70), ClinicalStatus.critical);
    });

    test('speed bands', () {
      expect(ClinicalAssessment.speedStatus(1.3), ClinicalStatus.normal);
      expect(ClinicalAssessment.speedStatus(1.1), ClinicalStatus.warning);
      expect(ClinicalAssessment.speedStatus(0.6), ClinicalStatus.critical);
    });

    test('all-normal gait yields no findings', () {
      expect(ClinicalAssessment.findings(_gait()), isEmpty);
    });

    test('out-of-range gait yields findings', () {
      final List<String> f = ClinicalAssessment.findings(
        _gait(cadence: 128, symmetry: 80, kneeFlex: 40),
      );
      expect(f.length, greaterThanOrEqualTo(3));
    });

    test('metrics returns three with reference text', () {
      final List<ClinicalMetric> m = ClinicalAssessment.metrics(_gait());
      expect(m.length, 3);
      expect(m.every((ClinicalMetric x) => x.reference.isNotEmpty), isTrue);
    });
  });
}

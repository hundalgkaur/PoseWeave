import 'dart:math' as math;

import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Aggregate angle stats for one body segment over a session.
class SegmentSummary {
  const SegmentSummary({
    required this.label,
    required this.avgDeg,
    required this.maxDeg,
    required this.classification,
    required this.isRisk,
  });

  final String label;
  final double avgDeg;
  final double maxDeg;
  final AngleClassification classification;
  final bool isRisk;
}

/// Reduces a pose sequence to per-limb angle summaries (avg, max, dominant
/// classification) for the four main segments. Pure / testable.
class SegmentAggregator {
  const SegmentAggregator._();

  static Map<String, SegmentSummary> summarize(List<PoseEntity> poses) {
    final Map<String, SegmentSummary> out = <String, SegmentSummary>{};
    out['L Arm'] = _arm(poses, isLeft: true);
    out['R Arm'] = _arm(poses, isLeft: false);
    out['L Leg'] = _leg(poses, isLeft: true);
    out['R Leg'] = _leg(poses, isLeft: false);
    return out;
  }

  static SegmentSummary _arm(List<PoseEntity> poses, {required bool isLeft}) {
    final List<AngleAnalysis> a = <AngleAnalysis>[];
    for (final PoseEntity p in poses) {
      final LandmarkEntity? s = p.getLandmark(
        isLeft ? PoseLandmarkType.leftShoulder : PoseLandmarkType.rightShoulder,
      );
      final LandmarkEntity? e = p.getLandmark(
        isLeft ? PoseLandmarkType.leftElbow : PoseLandmarkType.rightElbow,
      );
      final LandmarkEntity? w = p.getLandmark(
        isLeft ? PoseLandmarkType.leftWrist : PoseLandmarkType.rightWrist,
      );
      if (s != null && e != null && w != null) {
        a.add(PoseMath.analyzeElbow(shoulder: s, elbow: e, wrist: w));
      }
    }
    return _reduce(isLeft ? 'L Arm' : 'R Arm', a);
  }

  static SegmentSummary _leg(List<PoseEntity> poses, {required bool isLeft}) {
    final List<AngleAnalysis> a = <AngleAnalysis>[];
    for (final PoseEntity p in poses) {
      final LandmarkEntity? h = p.getLandmark(
        isLeft ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip,
      );
      final LandmarkEntity? k = p.getLandmark(
        isLeft ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee,
      );
      final LandmarkEntity? an = p.getLandmark(
        isLeft ? PoseLandmarkType.leftAnkle : PoseLandmarkType.rightAnkle,
      );
      if (h != null && k != null && an != null) {
        a.add(
          PoseMath.analyzeKnee(hip: h, knee: k, ankle: an, isLeftSide: isLeft),
        );
      }
    }
    return _reduce(isLeft ? 'L Leg' : 'R Leg', a);
  }

  static SegmentSummary _reduce(String label, List<AngleAnalysis> analyses) {
    if (analyses.isEmpty) {
      return SegmentSummary(
        label: label,
        avgDeg: 0,
        maxDeg: 0,
        classification: AngleClassification.neutral,
        isRisk: false,
      );
    }
    double sum = 0;
    double max = analyses.first.degrees;
    final Map<AngleClassification, int> counts = <AngleClassification, int>{};
    for (final AngleAnalysis a in analyses) {
      sum += a.degrees;
      max = math.max(max, a.degrees);
      counts.update(a.classification, (int c) => c + 1, ifAbsent: () => 1);
    }
    final AngleClassification dominant =
        counts.entries
            .reduce(
              (
                MapEntry<AngleClassification, int> a,
                MapEntry<AngleClassification, int> b,
              ) => a.value >= b.value ? a : b,
            )
            .key;
    final bool risk =
        dominant == AngleClassification.valgus ||
        dominant == AngleClassification.varus ||
        dominant == AngleClassification.hyperextended;
    return SegmentSummary(
      label: label,
      avgDeg: sum / analyses.length,
      maxDeg: max,
      classification: dominant,
      isRisk: risk,
    );
  }
}

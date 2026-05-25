import 'dart:math' as math;

import 'package:poseweave/core/constants/pose_templates.dart';
import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/domain/entities/pose_template.dart';

/// Pure, rule-based pose matcher. Scores a [PoseEntity] against each
/// [PoseTemplate] by how close each joint angle sits to its target, and returns
/// the best match with per-joint correction hints. No Flutter, no ML Kit.
class PoseClassifier {
  const PoseClassifier._();

  /// Below this limiting confidence a joint is treated as "not visible" and
  /// excluded from scoring rather than counted as wrong.
  static const double _minConfidence = 0.5;

  /// A joint at exactly its tolerance scores 0.5; at twice the tolerance, 0.
  static const double _falloff = 2.0;

  /// Best score below this floor reports "No match".
  static const double _matchFloor = 0.45;

  static PoseMatchResult classify(
    PoseEntity pose, {
    List<PoseTemplate> templates = kPoseTemplates,
  }) {
    PoseTemplate? best;
    double bestScore = -1;
    double bestConfidence = 0;
    List<JointDeviation> bestDeviations = const <JointDeviation>[];

    for (final PoseTemplate template in templates) {
      double scoreSum = 0;
      double confSum = 0;
      int counted = 0;
      final List<JointDeviation> deviations = <JointDeviation>[];

      for (final JointConstraint k in template.constraints) {
        final LandmarkEntity a = _lm(pose, k.a);
        final LandmarkEntity b = _lm(pose, k.b);
        final LandmarkEntity c = _lm(pose, k.c);
        final double conf = math.min(
          a.confidence,
          math.min(b.confidence, c.confidence),
        );
        if (conf < _minConfidence) continue; // joint not visible — skip

        final double angle = PoseMath.calculateAngle3Points(a, b, c);
        final double diff = (angle - k.targetDeg).abs();
        final double score = (1 - diff / (k.tolerance * _falloff)).clamp(0.0, 1.0);
        scoreSum += score;
        confSum += conf;
        counted++;
        if (diff > k.tolerance) {
          deviations.add(
            JointDeviation(
              label: k.label,
              measuredDeg: angle,
              targetDeg: k.targetDeg,
            ),
          );
        }
      }

      if (counted == 0) continue;
      final double templateScore = scoreSum / counted;
      if (templateScore > bestScore) {
        bestScore = templateScore;
        bestConfidence = confSum / counted;
        best = template;
        bestDeviations = deviations;
      }
    }

    if (best == null || bestScore < _matchFloor) {
      return PoseMatchResult(
        poseName: PoseMatchResult.noMatchName,
        matchPercent: bestScore < 0 ? 0 : bestScore * 100,
        confidence: bestConfidence,
      );
    }
    return PoseMatchResult(
      poseName: best.name,
      matchPercent: bestScore * 100,
      confidence: bestConfidence,
      deviations: bestDeviations,
    );
  }

  static LandmarkEntity _lm(PoseEntity pose, PoseLandmarkType type) =>
      pose.getLandmark(type) ??
      LandmarkEntity(type: type, x: 0, y: 0, confidence: 0);
}

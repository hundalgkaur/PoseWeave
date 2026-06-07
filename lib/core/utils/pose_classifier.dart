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

  /// Summarizes a clip (e.g. a recorded held pose) into one result: classifies
  /// every frame, finds the **dominant** matched pose (the name matched in the
  /// most frames), and reports its average match % over those frames plus that
  /// frame's correction hints. Returns [PoseMatchResult.none] if no frame
  /// matched. Pure — used by the Pose Coach video flow.
  static PoseMatchResult summarize(
    List<PoseEntity> poses, {
    List<PoseTemplate> templates = kPoseTemplates,
  }) {
    final Map<String, int> counts = <String, int>{};
    final Map<String, double> percentSums = <String, double>{};
    final Map<String, PoseMatchResult> exemplar = <String, PoseMatchResult>{};

    for (final PoseEntity pose in poses) {
      final PoseMatchResult r = classify(pose, templates: templates);
      if (!r.isMatch) continue;
      counts[r.poseName] = (counts[r.poseName] ?? 0) + 1;
      percentSums[r.poseName] = (percentSums[r.poseName] ?? 0) + r.matchPercent;
      // Keep the highest-scoring frame as the exemplar (for its hints).
      final PoseMatchResult? prev = exemplar[r.poseName];
      if (prev == null || r.matchPercent > prev.matchPercent) {
        exemplar[r.poseName] = r;
      }
    }

    if (counts.isEmpty) return PoseMatchResult.none;

    String dominant = counts.keys.first;
    for (final MapEntry<String, int> e in counts.entries) {
      if (e.value > (counts[dominant] ?? 0)) dominant = e.key;
    }
    final int n = counts[dominant] ?? 1;
    final PoseMatchResult sample = exemplar[dominant] ?? PoseMatchResult.none;
    return PoseMatchResult(
      poseName: dominant,
      matchPercent: (percentSums[dominant] ?? 0) / n,
      confidence: sample.confidence,
      deviations: sample.deviations,
    );
  }

  /// How close (degrees) a live joint angle must be to the reference before it
  /// stops being a "deviation" in [matchPose].
  static const double _matchTolerance = 22;

  /// The canonical joints compared when matching one pose against another:
  /// (vertex label, a, b=vertex, c). Mirrors the template angle conventions.
  static const List<(String, PoseLandmarkType, PoseLandmarkType, PoseLandmarkType)>
      _matchJoints =
      <(String, PoseLandmarkType, PoseLandmarkType, PoseLandmarkType)>[
    ('Left elbow', PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist),
    ('Right elbow', PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist),
    ('Left shoulder', PoseLandmarkType.leftHip, PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow),
    ('Right shoulder', PoseLandmarkType.rightHip, PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow),
    ('Left hip', PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee),
    ('Right hip', PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee),
    ('Left knee', PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle),
    ('Right knee', PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle),
  ];

  /// Scores how well a [live] pose matches an arbitrary [reference] pose (e.g.
  /// one detected from an uploaded photo) by comparing their canonical joint
  /// angles. Scale-/position-invariant (angles only). Joints below
  /// [_minConfidence] in either pose are skipped. Returns a [PoseMatchResult]
  /// with the match % and the joints that are off (for hints).
  static PoseMatchResult matchPose(
    PoseEntity live,
    PoseEntity reference, {
    String label = 'Reference',
  }) {
    double scoreSum = 0;
    double confSum = 0;
    int counted = 0;
    final List<JointDeviation> deviations = <JointDeviation>[];

    for (final (String, PoseLandmarkType, PoseLandmarkType, PoseLandmarkType) j
        in _matchJoints) {
      final LandmarkEntity la = _lm(live, j.$2);
      final LandmarkEntity lb = _lm(live, j.$3);
      final LandmarkEntity lc = _lm(live, j.$4);
      final LandmarkEntity ra = _lm(reference, j.$2);
      final LandmarkEntity rb = _lm(reference, j.$3);
      final LandmarkEntity rc = _lm(reference, j.$4);

      final double liveConf =
          math.min(la.confidence, math.min(lb.confidence, lc.confidence));
      final double refConf =
          math.min(ra.confidence, math.min(rb.confidence, rc.confidence));
      if (liveConf < _minConfidence || refConf < _minConfidence) continue;

      final double liveAngle = PoseMath.calculateAngle3Points(la, lb, lc);
      final double refAngle = PoseMath.calculateAngle3Points(ra, rb, rc);
      final double diff = (liveAngle - refAngle).abs();
      final double score =
          (1 - diff / (_matchTolerance * _falloff)).clamp(0.0, 1.0);
      scoreSum += score;
      confSum += liveConf;
      counted++;
      if (diff > _matchTolerance) {
        deviations.add(JointDeviation(
          label: j.$1,
          measuredDeg: liveAngle,
          targetDeg: refAngle,
        ));
      }
    }

    if (counted == 0) return PoseMatchResult.none;
    return PoseMatchResult(
      poseName: label,
      matchPercent: (scoreSum / counted) * 100,
      confidence: confSum / counted,
      deviations: deviations,
    );
  }

  static LandmarkEntity _lm(PoseEntity pose, PoseLandmarkType type) =>
      pose.getLandmark(type) ??
      LandmarkEntity(type: type, x: 0, y: 0, confidence: 0);
}

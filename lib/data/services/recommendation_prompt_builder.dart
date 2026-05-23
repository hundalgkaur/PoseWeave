import 'dart:convert';

import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';

/// Builds the Claude prompt from measurements and parses the JSON response.
/// Specificity (real numbers, JSON-only, capped count) drives output quality.
class RecommendationPromptBuilder {
  const RecommendationPromptBuilder._();

  static const String system =
      'You are a sports physiotherapist analysing gait and posture data.\n'
      'You will receive structured measurements from a pose detection system.\n'
      'Return ONLY a JSON array, no markdown, no commentary.\n'
      'Each item must have: title (max 8 words), detail (max 40 words), '
      'severity ("low"|"medium"|"high"), bodyPart (e.g. "left knee").\n'
      'Give 3 to 5 recommendations, prioritised by severity.';

  static String buildUser(
    GaitParameters gait,
    Map<String, SegmentSummary> segments,
  ) {
    final String segLines = segments.values
        .map(
          (SegmentSummary s) =>
              '- ${s.label}: avg ${s.avgDeg.round()}°, max ${s.maxDeg.round()}° '
              '(${s.classification.name})${s.isRisk ? ' [risk]' : ''}',
        )
        .join('\n');
    return 'Subject gait analysis:\n'
        '- Cadence: ${gait.cadenceSpm.round()} steps/min\n'
        '- Symmetry: ${gait.symmetryPercent.round()}%\n'
        '- Max knee flexion: ${gait.kneeFlexionMaxDeg.round()}°\n'
        '- Arm swing L/R: ${gait.leftArmSwingDeg.round()}° / ${gait.rightArmSwingDeg.round()}°\n'
        '- Stance/swing: ${gait.stancePercent.round()}% / ${gait.swingPercent.round()}%\n'
        '- Estimated speed: ${gait.speedMps.toStringAsFixed(1)} m/s\n\n'
        'Segment angles:\n$segLines\n\n'
        'Return a JSON array of 3-5 recommendations.';
  }

  /// Parses the model text (tolerating markdown fences) into entities.
  static List<RecommendationEntity> parse(String raw) {
    String text = raw.trim();
    if (text.startsWith('```')) {
      text =
          text
              .replaceAll(RegExp(r'^```(json)?\n?'), '')
              .replaceAll(RegExp(r'\n?```$'), '')
              .trim();
    }
    final dynamic decoded = jsonDecode(text);
    if (decoded is! List) return <RecommendationEntity>[];
    return decoded.whereType<Map<String, dynamic>>().map((
      Map<String, dynamic> j,
    ) {
      return RecommendationEntity(
        title: (j['title'] ?? '').toString(),
        detail: (j['detail'] ?? '').toString(),
        severity: _severity((j['severity'] ?? 'low').toString()),
        bodyPart: (j['bodyPart'] ?? '').toString(),
      );
    }).toList();
  }

  static Severity _severity(String s) {
    switch (s.toLowerCase()) {
      case 'high':
        return Severity.high;
      case 'medium':
        return Severity.medium;
      default:
        return Severity.low;
    }
  }
}

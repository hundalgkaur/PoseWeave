import 'package:equatable/equatable.dart';

/// A joint whose measured angle drifted outside its template tolerance. [error]
/// is signed (measured − target): negative means more bent than the target,
/// positive means straighter, so the UI can phrase a correction hint.
class JointDeviation extends Equatable {
  const JointDeviation({
    required this.label,
    required this.measuredDeg,
    required this.targetDeg,
  });

  final String label;
  final double measuredDeg;
  final double targetDeg;

  double get error => measuredDeg - targetDeg;

  /// Coaching hint: which way to move this joint.
  String get hint => error < 0
      ? 'straighten your ${label.toLowerCase()}'
      : 'bend your ${label.toLowerCase()}';

  @override
  List<Object?> get props => <Object?>[label, measuredDeg, targetDeg];
}

/// Result of matching a live pose against the template set: the best-matching
/// pose name, a 0..100 match score, the limiting confidence, and the joints
/// that are off (for correction hints).
class PoseMatchResult extends Equatable {
  const PoseMatchResult({
    required this.poseName,
    required this.matchPercent,
    required this.confidence,
    this.deviations = const <JointDeviation>[],
  });

  final String poseName;
  final double matchPercent;
  final double confidence;
  final List<JointDeviation> deviations;

  bool get isMatch => poseName != noMatchName;

  static const String noMatchName = 'No match';

  static const PoseMatchResult none = PoseMatchResult(
    poseName: noMatchName,
    matchPercent: 0,
    confidence: 0,
  );

  @override
  List<Object?> get props =>
      <Object?>[poseName, matchPercent, confidence, deviations];
}

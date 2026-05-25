import 'package:equatable/equatable.dart';

/// Which half of the rep cycle the body is in. `up` is the resting/extended
/// position (standing, arms straight, lying back, legs closed); `down` is the
/// active/contracted position (squatting, elbows bent, curled up, limbs open).
enum RepPhase { unknown, up, down }

/// Quality of the most recently completed rep.
enum FormQuality { unknown, good, partial, poor }

/// Immutable snapshot from [RepCounter]: the running tally plus the current
/// phase, the latest signal value (an angle in degrees, or a normalized
/// separation), confidence, and the form verdict of the last completed rep.
class RepCountResult extends Equatable {
  const RepCountResult({
    required this.repCount,
    required this.phase,
    required this.formQuality,
    required this.signalValue,
    required this.confidence,
    this.formIssues = const <String>[],
  });

  final int repCount;
  final RepPhase phase;
  final FormQuality formQuality;

  /// The (smoothed) driving signal — joint angle in degrees for most exercises,
  /// or a normalized limb separation for jumping jacks.
  final double signalValue;

  /// Limiting landmark confidence of the driving joints this frame (0..1).
  final double confidence;

  /// Human-readable issues from the last completed rep (e.g. shallow depth,
  /// knee valgus). Empty when form was clean.
  final List<String> formIssues;

  static const RepCountResult initial = RepCountResult(
    repCount: 0,
    phase: RepPhase.unknown,
    formQuality: FormQuality.unknown,
    signalValue: 0,
    confidence: 0,
  );

  @override
  List<Object?> get props => <Object?>[
        repCount,
        phase,
        formQuality,
        signalValue,
        confidence,
        formIssues,
      ];
}

import 'package:equatable/equatable.dart';

/// Gait parameters derived from a sequence of poses (a walking clip).
///
/// [speedMps] and the leg-rotation values are heuristic estimates from 2D
/// monocular video (see [GaitAnalyzer]); the UI tags them as estimated.
class GaitParameters extends Equatable {
  const GaitParameters({
    required this.speedMps,
    required this.cadenceSpm,
    required this.symmetryPercent,
    required this.leftArmSwingDeg,
    required this.rightArmSwingDeg,
    required this.kneeFlexionMaxDeg,
    required this.leftLegRotInDeg,
    required this.leftLegRotOutDeg,
    required this.rightLegRotInDeg,
    required this.rightLegRotOutDeg,
    required this.stancePercent,
    required this.swingPercent,
    required this.framesAnalyzed,
  });

  /// Estimated walking speed in metres/second (assumes ~1.7 m subject height).
  final double speedMps;

  /// Cadence in steps per minute.
  final double cadenceSpm;

  /// Left/right symmetry, 0..100 (100 = perfectly symmetric).
  final double symmetryPercent;

  final double leftArmSwingDeg;
  final double rightArmSwingDeg;

  /// Maximum knee flexion across the sequence (degrees).
  final double kneeFlexionMaxDeg;

  // Estimated foot in/out rotation (degrees).
  final double leftLegRotInDeg;
  final double leftLegRotOutDeg;
  final double rightLegRotInDeg;
  final double rightLegRotOutDeg;

  /// Gait-cycle stance/swing split (percent, sum ≈ 100).
  final double stancePercent;
  final double swingPercent;

  final int framesAnalyzed;

  @override
  List<Object?> get props => <Object?>[
    speedMps,
    cadenceSpm,
    symmetryPercent,
    leftArmSwingDeg,
    rightArmSwingDeg,
    kneeFlexionMaxDeg,
    leftLegRotInDeg,
    leftLegRotOutDeg,
    rightLegRotInDeg,
    rightLegRotOutDeg,
    stancePercent,
    swingPercent,
    framesAnalyzed,
  ];
}

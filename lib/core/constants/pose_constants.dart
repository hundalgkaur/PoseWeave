import 'package:flutter/material.dart';

/// Skeleton rig topology and visualization thresholds.
///
/// [connections] lists the 32 bones as `[startIndex, endIndex]` pairs, where
/// each index is a [PoseLandmarkType] ordinal. The painter walks this list to
/// draw the skeleton; [regionRanges] then maps slices of it to a body region
/// so each bone gets a [regionColors] color. Keep [connections] and
/// [regionRanges] in sync — the ranges are inclusive bone-index bounds.
class PoseBones {
  const PoseBones._();

  static const List<List<int>> connections = <List<int>>[
    // Face (indices 0-9)
    <int>[0, 1], // nose -> leftEyeInner
    <int>[1, 2], // leftEyeInner -> leftEye
    <int>[2, 3], // leftEye -> leftEyeOuter
    <int>[3, 7], // leftEyeOuter -> leftEar
    <int>[0, 4], // nose -> rightEyeInner
    <int>[4, 5], // rightEyeInner -> rightEye
    <int>[5, 6], // rightEye -> rightEyeOuter
    <int>[6, 8], // rightEyeOuter -> rightEar
    <int>[9, 10], // leftMouth -> rightMouth
    <int>[0, 9], // nose -> leftMouth (closes the face group at 10 bones)

    // Torso (indices 10-13)
    <int>[11, 12], // leftShoulder -> rightShoulder
    <int>[11, 23], // leftShoulder -> leftHip
    <int>[12, 24], // rightShoulder -> rightHip
    <int>[23, 24], // leftHip -> rightHip

    // Left arm (indices 14-18)
    <int>[11, 13], // leftShoulder -> leftElbow
    <int>[13, 15], // leftElbow -> leftWrist
    <int>[15, 17], // leftWrist -> leftPinky
    <int>[15, 19], // leftWrist -> leftIndex
    <int>[15, 21], // leftWrist -> leftThumb

    // Right arm (indices 19-23)
    <int>[12, 14], // rightShoulder -> rightElbow
    <int>[14, 16], // rightElbow -> rightWrist
    <int>[16, 18], // rightWrist -> rightPinky
    <int>[16, 20], // rightWrist -> rightIndex
    <int>[16, 22], // rightWrist -> rightThumb

    // Left leg (indices 24-27)
    <int>[23, 25], // leftHip -> leftKnee
    <int>[25, 27], // leftKnee -> leftAnkle
    <int>[27, 29], // leftAnkle -> leftHeel
    <int>[27, 31], // leftAnkle -> leftFootIndex

    // Right leg (indices 28-31)
    <int>[24, 26], // rightHip -> rightKnee
    <int>[26, 28], // rightKnee -> rightAnkle
    <int>[28, 30], // rightAnkle -> rightHeel
    <int>[28, 32], // rightAnkle -> rightFootIndex
  ];

  /// Inclusive `[firstBoneIndex, lastBoneIndex]` ranges into [connections].
  static const Map<String, List<int>> regionRanges = <String, List<int>>{
    'face': <int>[0, 9],
    'torso': <int>[10, 13],
    'leftArm': <int>[14, 18],
    'rightArm': <int>[19, 23],
    'leftLeg': <int>[24, 27],
    'rightLeg': <int>[28, 31],
  };

  /// Region -> bone color. Cyan face plus the limb palette used in the
  /// live-detection mockup, so each side reads at a glance.
  static const Map<String, Color> regionColors = <String, Color>{
    'face': Color(0xFF00E5FF), // cyan
    'torso': Color(0xFF00E676), // green
    'leftArm': Color(0xFFFF9100), // orange
    'rightArm': Color(0xFFE040FB), // purple
    'leftLeg': Color(0xFFFF5252), // red
    'rightLeg': Color(0xFF448AFF), // blue
  };

  /// Returns the color for the bone at [boneIndex] in [connections].
  static Color colorForBone(int boneIndex) {
    for (final MapEntry<String, List<int>> entry in regionRanges.entries) {
      if (boneIndex >= entry.value[0] && boneIndex <= entry.value[1]) {
        return regionColors[entry.key]!;
      }
    }
    return regionColors['face']!;
  }

  // Confidence visualization thresholds (PRD §6.3).
  static const double highConfidence = 0.8;
  static const double mediumConfidence = 0.5;
  static const double lowConfidence = 0.3;
}

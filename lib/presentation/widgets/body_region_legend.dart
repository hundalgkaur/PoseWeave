import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/pose_constants.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Vertical glass pill of colored dots keying each body region to its bone
/// color, matching the live-detection mockup's right-edge legend.
class BodyRegionLegend extends StatelessWidget {
  const BodyRegionLegend({super.key});

  static const Map<String, String> _labels = <String, String>{
    'face': 'Face',
    'torso': 'Torso',
    'leftArm': 'Left arm',
    'rightArm': 'Right arm',
    'leftLeg': 'Left leg',
    'rightLeg': 'Right leg',
  };

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            PoseBones.regionColors.entries.map((MapEntry<String, Color> e) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Tooltip(
                  message: _labels[e.key] ?? e.key,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: e.value,
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: e.value.withValues(alpha: 0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

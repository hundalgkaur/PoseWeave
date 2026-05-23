import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';

/// Scrollable list of the 33 landmarks with their normalized X/Y/Z and a
/// confidence dot (cyan, or error-red when below the visibility threshold).
/// Shared by the video results and image-analysis screens.
class LandmarkTable extends StatelessWidget {
  const LandmarkTable({required this.landmarks, super.key});

  final List<LandmarkEntity> landmarks;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: landmarks.length,
      itemBuilder:
          (BuildContext context, int i) => _LandmarkRow(landmark: landmarks[i]),
    );
  }
}

class _LandmarkRow extends StatelessWidget {
  const _LandmarkRow({required this.landmark});
  final LandmarkEntity landmark;

  @override
  Widget build(BuildContext context) {
    final bool low = landmark.confidence < 0.5;
    final Color dotColor = low ? AppColors.error : AppColors.primaryContainer;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              landmark.type.name,
              style: AppTheme.mono(fontSize: 12, color: AppColors.onSurface),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'X ${landmark.x.toStringAsFixed(3)}  '
              'Y ${landmark.y.toStringAsFixed(3)}  '
              'Z ${(landmark.z ?? 0).toStringAsFixed(3)}',
              textAlign: TextAlign.right,
              style: AppTheme.mono(
                fontSize: 11,
                color: low ? AppColors.error : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

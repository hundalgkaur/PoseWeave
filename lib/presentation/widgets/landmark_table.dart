import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_spacing.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/presentation/widgets/metric_row.dart';

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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm - 2,
      ),
      child: MetricRow(
        fontSize: 11,
        leading: Semantics(
          label: low ? 'Low confidence landmark' : 'Tracked landmark',
          child: Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ),
        cells: <MetricCell>[
          MetricCell(landmark.type.name, flex: 4, color: AppColors.onSurface),
          MetricCell(
            'X ${landmark.x.toStringAsFixed(3)}  '
            'Y ${landmark.y.toStringAsFixed(3)}  '
            'Z ${(landmark.z ?? 0).toStringAsFixed(3)}',
            flex: 6,
            align: TextAlign.right,
            color: low ? AppColors.error : AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

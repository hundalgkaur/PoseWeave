import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';

/// A round front/back camera toggle pinned over a live preview. Disabled in
/// mock mode (no real camera to switch).
class CameraSwitchButton extends StatelessWidget {
  const CameraSwitchButton({required this.bloc, super.key});

  final PoseBloc bloc;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.cameraswitch, color: AppColors.onSurface),
        tooltip: 'Switch camera',
        onPressed: bloc.isMockMode
            ? null
            : () => bloc.add(const PoseEvent.switchCamera()),
      ),
    );
  }
}

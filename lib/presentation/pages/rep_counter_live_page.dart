import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/domain/entities/rep_count_result.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/bloc/rep_counter_bloc.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/camera_pose_view.dart';
import 'package:poseweave/presentation/widgets/camera_switch_button.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/no_person_banner.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/rep_counter_display.dart';

/// Live rep counter: reuses `PoseBloc` for the camera/detection and feeds each
/// `PoseActive` pose into `RepCounterBloc`, which runs the pure `RepCounter`
/// engine. Mirrors the structure of `segment_dashboard_page.dart`.
class RepCounterLivePage extends StatelessWidget {
  const RepCounterLivePage({required this.exercise, super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
        ),
        BlocProvider<RepCounterBloc>(
          create: (_) =>
              getIt<RepCounterBloc>()..add(RepCounterEvent.selectExercise(exercise)),
        ),
      ],
      child: _RepLiveView(exercise: exercise),
    );
  }
}

class _RepLiveView extends StatefulWidget {
  const _RepLiveView({required this.exercise});
  final Exercise exercise;

  @override
  State<_RepLiveView> createState() => _RepLiveViewState();
}

class _RepLiveViewState extends State<_RepLiveView> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: widget.exercise.label),
      body: BlocConsumer<PoseBloc, PoseState>(
        listener: (BuildContext context, PoseState state) async {
          if (state is PoseStreaming && !_started) {
            _started = true;
            context.read<PoseBloc>().add(const PoseEvent.startDetection());
          } else if (state is PoseActive) {
            context
                .read<RepCounterBloc>()
                .add(RepCounterEvent.poseReceived(state.pose));
          } else if (state is PoseNoPermission) {
            final bool? retry = await PermissionRationaleDialog.show(context);
            if ((retry ?? false) && context.mounted) {
              context.read<PoseBloc>().add(const PoseEvent.initializeCamera());
            }
          } else if (state is PoseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (BuildContext context, PoseState state) {
          if (state is PoseError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(Icons.error_outline,
                        color: AppColors.error, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTheme.mono(
                          color: AppColors.onSurfaceVariant, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        _started = false;
                        context
                            .read<PoseBloc>()
                            .add(const PoseEvent.initializeCamera());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final PoseBloc bloc = context.read<PoseBloc>();
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CameraPoseView(bloc: bloc, state: state),
              if (state is PoseSearching)
                const NoPersonBanner(
                  message: 'Step into frame, full body visible',
                ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: CameraSwitchButton(bloc: bloc),
                      ),
                      const _RepOverlay(),
                      const Spacer(),
                      Text(
                        widget.exercise.instructions,
                        textAlign: TextAlign.center,
                        style: AppTheme.mono(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () => context
                            .read<RepCounterBloc>()
                            .add(const RepCounterEvent.reset()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('RESET'),
                      ),
                    ],
                  ),
                ),
              ),              if (state is PoseLoading)
                const LoadingOverlay(message: 'Initializing camera…'),
            ],
          );
        },
      ),
    );
  }
}

/// The translucent rep readout pinned to the top of the camera view. Also fires
/// a haptic pulse each time the rep count ticks up, so the user gets tactile
/// confirmation without watching the number.
class _RepOverlay extends StatelessWidget {
  const _RepOverlay();

  int _countOf(RepCounterState state) =>
      state is RepCounterCounting ? state.result.repCount : 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RepCounterBloc, RepCounterState>(
      listenWhen: (RepCounterState p, RepCounterState c) =>
          _countOf(c) > _countOf(p),
      listener: (BuildContext context, RepCounterState state) =>
          HapticFeedback.mediumImpact(),
      builder: (BuildContext context, RepCounterState state) {
        if (state is RepCounterCounting) {
          return RepCounterDisplay(
            exercise: state.exercise,
            result: state.result,
          );
        }
        return const RepCounterDisplay(
          exercise: Exercise.squat,
          result: RepCountResult.initial,
        );
      },
    );
  }
}

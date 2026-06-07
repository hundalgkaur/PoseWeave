import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_classifier_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/camera_pose_view.dart';
import 'package:poseweave/presentation/widgets/camera_switch_button.dart';
import 'package:poseweave/presentation/widgets/loading_overlay.dart';
import 'package:poseweave/presentation/widgets/no_person_banner.dart';
import 'package:poseweave/presentation/widgets/permission_rationale_dialog.dart';
import 'package:poseweave/presentation/widgets/pose_match_panel.dart';

/// Pose Coach: live camera + rule-based pose matching. Reuses `PoseBloc` for
/// detection and feeds each `PoseActive` pose into `PoseClassifierBloc`.
class PoseClassifierPage extends StatelessWidget {
  const PoseClassifierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.initializeCamera()),
        ),
        BlocProvider<PoseClassifierBloc>(
          create: (_) => getIt<PoseClassifierBloc>(),
        ),
      ],
      child: const _CoachView(),
    );
  }
}

class _CoachView extends StatefulWidget {
  const _CoachView();

  @override
  State<_CoachView> createState() => _CoachViewState();
}

class _CoachViewState extends State<_CoachView> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Pose Coach'),
      body: BlocConsumer<PoseBloc, PoseState>(
        listener: (BuildContext context, PoseState state) async {
          if (state is PoseStreaming && !_started) {
            _started = true;
            context.read<PoseBloc>().add(const PoseEvent.startDetection());
          } else if (state is PoseActive) {
            context
                .read<PoseClassifierBloc>()
                .add(PoseClassifierEvent.poseReceived(state.pose));
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
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: CameraSwitchButton(bloc: bloc),
                      ),
                      const SizedBox(height: 8),
                      _MatchOverlay(),
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

class _MatchOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PoseClassifierBloc, PoseClassifierState>(
      builder: (BuildContext context, PoseClassifierState state) {
        final PoseMatchResult result = state is PoseClassifierMatched
            ? state.result
            : PoseMatchResult.none;
        return PoseMatchPanel(result: result);
      },
    );
  }
}

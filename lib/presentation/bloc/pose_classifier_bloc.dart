import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/utils/pose_classifier.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';

part 'pose_classifier_bloc.freezed.dart';

@freezed
class PoseClassifierEvent with _$PoseClassifierEvent {
  /// A pose arrived from the live camera (`PoseActive`).
  const factory PoseClassifierEvent.poseReceived(PoseEntity pose) =
      ClassifierPoseReceived;
}

@freezed
class PoseClassifierState with _$PoseClassifierState {
  const factory PoseClassifierState.idle() = PoseClassifierIdle;
  const factory PoseClassifierState.matched(PoseMatchResult result) =
      PoseClassifierMatched;
}

/// Runs the pure [PoseClassifier] against each live pose the page feeds it from
/// `PoseBloc`'s `PoseActive` state. Holds no camera/video I/O.
@injectable
class PoseClassifierBloc
    extends Bloc<PoseClassifierEvent, PoseClassifierState> {
  PoseClassifierBloc() : super(const PoseClassifierState.idle()) {
    on<ClassifierPoseReceived>(_onPose);
  }

  void _onPose(
    ClassifierPoseReceived event,
    Emitter<PoseClassifierState> emit,
  ) {
    emit(PoseClassifierState.matched(PoseClassifier.classify(event.pose)));
  }
}

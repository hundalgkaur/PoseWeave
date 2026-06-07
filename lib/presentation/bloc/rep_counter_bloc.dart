import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/utils/rep_counter.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/rep_count_result.dart';

part 'rep_counter_bloc.freezed.dart';

@freezed
class RepCounterEvent with _$RepCounterEvent {
  /// Choose the exercise and (re)create the engine.
  const factory RepCounterEvent.selectExercise(Exercise exercise) =
      SelectExercise;

  /// Live: a pose arrived from the camera (`PoseActive`).
  const factory RepCounterEvent.poseReceived(PoseEntity pose) = RepPoseReceived;

  /// Video: the whole analyzed clip is ready (`PoseVideoComplete`).
  const factory RepCounterEvent.analyzeVideoPoses(List<PoseEntity> poses) =
      AnalyzeVideoPoses;

  /// Reset the running tally for another set.
  const factory RepCounterEvent.reset() = ResetReps;
}

@freezed
class RepCounterState with _$RepCounterState {
  /// No exercise chosen yet.
  const factory RepCounterState.idle() = RepCounterIdle;

  /// Live counting in progress (or freshly reset).
  const factory RepCounterState.counting({
    required Exercise exercise,
    required RepCountResult result,
  }) = RepCounterCounting;

  /// A video clip finished; [result] holds the final tally.
  const factory RepCounterState.complete({
    required Exercise exercise,
    required RepCountResult result,
  }) = RepCounterComplete;
}

/// Drives both the live and video rep-counter screens. It owns no camera/video
/// I/O — the page feeds it poses from the existing `PoseBloc` (`PoseActive` for
/// live, `PoseVideoComplete` for video) and this bloc runs the pure
/// [RepCounter] engine. Registered as a factory so each screen gets a fresh
/// engine.
@injectable
class RepCounterBloc extends Bloc<RepCounterEvent, RepCounterState> {
  RepCounterBloc() : super(const RepCounterState.idle()) {
    on<SelectExercise>(_onSelect);
    on<RepPoseReceived>(_onPose);
    on<AnalyzeVideoPoses>(_onVideo);
    on<ResetReps>(_onReset);
  }

  RepCounter? _engine;
  Exercise? _exercise;

  void _onSelect(SelectExercise event, Emitter<RepCounterState> emit) {
    _exercise = event.exercise;
    _engine = RepCounter(event.exercise);
    emit(
      RepCounterState.counting(
        exercise: event.exercise,
        result: RepCountResult.initial,
      ),
    );
  }

  void _onPose(RepPoseReceived event, Emitter<RepCounterState> emit) {
    final RepCounter? engine = _engine;
    final Exercise? exercise = _exercise;
    if (engine == null || exercise == null) return;
    emit(
      RepCounterState.counting(
        exercise: exercise,
        result: engine.update(event.pose),
      ),
    );
  }

  void _onVideo(AnalyzeVideoPoses event, Emitter<RepCounterState> emit) {
    final Exercise? exercise = _exercise;
    if (exercise == null) return;
    emit(
      RepCounterState.complete(
        exercise: exercise,
        result: RepCounter.analyze(exercise, event.poses),
      ),
    );
  }

  void _onReset(ResetReps event, Emitter<RepCounterState> emit) {
    _engine?.reset();
    final Exercise? exercise = _exercise;
    if (exercise != null) {
      emit(
        RepCounterState.counting(
          exercise: exercise,
          result: RepCountResult.initial,
        ),
      );
    } else {
      emit(const RepCounterState.idle());
    }
  }
}

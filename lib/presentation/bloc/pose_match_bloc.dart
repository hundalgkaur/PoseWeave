import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/constants/pose_templates.dart';
import 'package:poseweave/core/utils/pose_classifier.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/pose_match_result.dart';
import 'package:poseweave/domain/entities/pose_template.dart';

part 'pose_match_bloc.freezed.dart';

/// Drives the guided "Match a target" mode: the user picks a target (a preset
/// pose template, or a pose detected from an uploaded photo), holds it, and the
/// live camera scores how close they are. Holds no camera I/O — the page feeds
/// it `PoseActive` poses.
@freezed
class PoseMatchEvent with _$PoseMatchEvent {
  /// Target is a built-in pose (matched against every L/R template variant).
  const factory PoseMatchEvent.selectTemplate(PoseTemplate template) =
      MatchSelectTemplate;

  /// Target is a pose detected from an uploaded reference image.
  const factory PoseMatchEvent.selectReferencePose(PoseEntity reference) =
      MatchSelectReference;

  /// A live pose arrived from the camera (`PoseActive`).
  const factory PoseMatchEvent.poseReceived(PoseEntity pose) =
      MatchPoseReceived;

  /// Restart the hold after a completed match (retry / next attempt).
  const factory PoseMatchEvent.reset() = MatchReset;
}

@freezed
class PoseMatchState with _$PoseMatchState {
  const factory PoseMatchState.idle() = PoseMatchIdle;

  /// Actively matching: [label] is the target name, [result] the latest score,
  /// [holdProgress] 0..1 how long the user has held it above threshold.
  const factory PoseMatchState.matching({
    required String label,
    required PoseMatchResult result,
    required double holdProgress,
  }) = PoseMatchMatching;

  /// Held the target long enough — success.
  const factory PoseMatchState.completed({
    required String label,
    required PoseMatchResult result,
  }) = PoseMatchCompleted;
}

@injectable
class PoseMatchBloc extends Bloc<PoseMatchEvent, PoseMatchState> {
  PoseMatchBloc() : super(const PoseMatchState.idle()) {
    on<MatchSelectTemplate>(_onSelectTemplate);
    on<MatchSelectReference>(_onSelectReference);
    on<MatchPoseReceived>(_onPose);
    on<MatchReset>(_onReset);
  }

  /// Score ≥ this counts toward the hold.
  static const double _successPercent = 80;

  /// Consecutive qualifying frames required to "complete" (~1.5s at ~20 fps).
  static const int _holdFrames = 30;

  // The active target — exactly one of these is set.
  List<PoseTemplate> _targetTemplates = const <PoseTemplate>[];
  PoseEntity? _referencePose;
  String _label = '';
  int _hold = 0;

  void _onSelectTemplate(
    MatchSelectTemplate event,
    Emitter<PoseMatchState> emit,
  ) {
    _targetTemplates = templatesNamed(event.template.name);
    _referencePose = null;
    _label = event.template.name;
    _hold = 0;
    emit(PoseMatchState.matching(
      label: _label,
      result: PoseMatchResult.none,
      holdProgress: 0,
    ));
  }

  void _onSelectReference(
    MatchSelectReference event,
    Emitter<PoseMatchState> emit,
  ) {
    _referencePose = event.reference;
    _targetTemplates = const <PoseTemplate>[];
    _label = 'Reference';
    _hold = 0;
    emit(PoseMatchState.matching(
      label: _label,
      result: PoseMatchResult.none,
      holdProgress: 0,
    ));
  }

  void _onPose(MatchPoseReceived event, Emitter<PoseMatchState> emit) {
    final PoseMatchResult result = _score(event.pose);
    if (result.matchPercent >= _successPercent) {
      _hold++;
    } else {
      _hold = 0;
    }
    if (_hold >= _holdFrames) {
      emit(PoseMatchState.completed(label: _label, result: result));
      return;
    }
    emit(PoseMatchState.matching(
      label: _label,
      result: result,
      holdProgress: _hold / _holdFrames,
    ));
  }

  void _onReset(MatchReset event, Emitter<PoseMatchState> emit) {
    _hold = 0;
    if (_targetTemplates.isEmpty && _referencePose == null) {
      emit(const PoseMatchState.idle());
      return;
    }
    emit(PoseMatchState.matching(
      label: _label,
      result: PoseMatchResult.none,
      holdProgress: 0,
    ));
  }

  /// Scores the live pose against whichever target is active. For a template
  /// target, takes the best score across its L/R variants.
  PoseMatchResult _score(PoseEntity live) {
    final PoseEntity? reference = _referencePose;
    if (reference != null) {
      return PoseClassifier.matchPose(live, reference, label: _label);
    }
    PoseMatchResult best = PoseMatchResult.none;
    for (final PoseTemplate t in _targetTemplates) {
      final PoseMatchResult r =
          PoseClassifier.classify(live, templates: <PoseTemplate>[t]);
      if (r.matchPercent > best.matchPercent) best = r;
    }
    return best;
  }
}

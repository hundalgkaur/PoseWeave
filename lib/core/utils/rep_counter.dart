import 'dart:math' as math;

import 'package:poseweave/core/utils/pose_math.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/rep_count_result.dart';

/// Pure, testable repetition counter. No Flutter, no ML Kit — it consumes
/// [PoseEntity] frames only, so the same engine drives both the live camera
/// (one frame at a time via [update]) and an uploaded clip (the whole sequence
/// via [analyze]).
///
/// Counting uses a two-threshold (Schmitt-trigger) state machine: the signal
/// must cross an *enter* threshold to start the active half of a rep and a
/// separate *exit* threshold to complete it. The dead-band between the two
/// thresholds prevents noise around a single value from double-counting. Frames
/// whose driving joints fall below [_minConfidence] are skipped (they don't
/// advance the machine); a sustained low-confidence gap resets the phase so a
/// person re-entering frame mid-motion can't split one rep into two.
class RepCounter {
  RepCounter(this.exercise);

  final Exercise exercise;

  static const double _minConfidence = 0.5;
  static const double _emaAlpha = 0.4;
  static const int _resetAfterLowConfFrames = 8;

  int _reps = 0;
  RepPhase _phase = RepPhase.up; // assume start at rest/extended
  double? _smoothed;
  int _lowConfStreak = 0;

  // Extreme reached during the current active phase, used for form scoring.
  double? _activeExtreme;
  final Set<String> _activeIssues = <String>{};
  FormQuality _lastFormQuality = FormQuality.unknown;
  List<String> _lastIssues = const <String>[];

  int get repCount => _reps;

  void reset() {
    _reps = 0;
    _phase = RepPhase.up;
    _smoothed = null;
    _lowConfStreak = 0;
    _activeExtreme = null;
    _activeIssues.clear();
    _lastFormQuality = FormQuality.unknown;
    _lastIssues = const <String>[];
  }

  /// Folds [update] over a whole clip and returns the final tally. Live and
  /// video therefore share one code path.
  static RepCountResult analyze(Exercise exercise, List<PoseEntity> poses) {
    if (poses.isEmpty) return RepCountResult.initial;
    final RepCounter counter = RepCounter(exercise);
    RepCountResult result = RepCountResult.initial;
    for (final PoseEntity pose in poses) {
      result = counter.update(pose);
    }
    return result;
  }

  /// Feeds one pose; returns the running tally + current phase/form.
  RepCountResult update(PoseEntity pose) {
    final _Signal? sig = _signalFor(pose);
    if (sig == null || sig.confidence < _minConfidence) {
      _lowConfStreak++;
      if (_lowConfStreak >= _resetAfterLowConfFrames) {
        _phase = RepPhase.up;
        _activeExtreme = null;
        _activeIssues.clear();
        _smoothed = null;
      }
      return RepCountResult(
        repCount: _reps,
        phase: RepPhase.unknown,
        formQuality: _lastFormQuality,
        signalValue: _smoothed ?? 0,
        confidence: sig?.confidence ?? 0,
        formIssues: _lastIssues,
      );
    }
    _lowConfStreak = 0;

    final double s = _smoothed == null
        ? sig.value
        : _emaAlpha * sig.value + (1 - _emaAlpha) * (_smoothed ?? sig.value);
    _smoothed = s;

    final _Spec spec = _specs[exercise] ?? _specs[Exercise.squat]!;
    final bool inActive =
        spec.activeWhenBelow ? s <= spec.enter : s >= spec.enter;
    final bool inRest = spec.activeWhenBelow ? s >= spec.exit : s <= spec.exit;

    if (_phase != RepPhase.down && inActive) {
      _phase = RepPhase.down;
      _activeExtreme = s;
      _activeIssues.clear();
      if (sig.issue != null) _activeIssues.add(sig.issue ?? '');
    } else if (_phase == RepPhase.down) {
      final double current = _activeExtreme ?? s;
      _activeExtreme = spec.activeWhenBelow
          ? math.min(current, s)
          : math.max(current, s);
      if (sig.issue != null) _activeIssues.add(sig.issue ?? '');
      if (inRest) {
        _reps++;
        _phase = RepPhase.up;
        _lastFormQuality = _evalForm(spec, _activeExtreme);
        _lastIssues = _activeIssues.toList();
        _activeExtreme = null;
        _activeIssues.clear();
      }
    }

    return RepCountResult(
      repCount: _reps,
      phase: _phase,
      formQuality: _lastFormQuality,
      signalValue: s,
      confidence: sig.confidence,
      formIssues: _lastIssues,
    );
  }

  FormQuality _evalForm(_Spec spec, double? extreme) {
    if (_activeIssues.isNotEmpty) return FormQuality.poor;
    if (extreme == null) return FormQuality.partial;
    final bool reachedGood =
        spec.activeWhenBelow ? extreme <= spec.good : extreme >= spec.good;
    return reachedGood ? FormQuality.good : FormQuality.partial;
  }

  // --- Per-exercise signal extraction --------------------------------------

  _Signal? _signalFor(PoseEntity pose) {
    switch (exercise) {
      case Exercise.squat:
        return _kneeSignal(pose);
      case Exercise.pushup:
      case Exercise.bicepCurl:
        return _elbowSignal(pose);
      case Exercise.situp:
        return _hipSignal(pose);
      case Exercise.jumpingJack:
        return _ankleSeparationSignal(pose);
    }
  }

  LandmarkEntity _lm(PoseEntity pose, PoseLandmarkType type) =>
      pose.getLandmark(type) ??
      LandmarkEntity(type: type, x: 0, y: 0, confidence: 0);

  _Signal _kneeSignal(PoseEntity pose) {
    final AngleAnalysis left = PoseMath.analyzeKnee(
      hip: _lm(pose, PoseLandmarkType.leftHip),
      knee: _lm(pose, PoseLandmarkType.leftKnee),
      ankle: _lm(pose, PoseLandmarkType.leftAnkle),
      isLeftSide: true,
    );
    final AngleAnalysis right = PoseMath.analyzeKnee(
      hip: _lm(pose, PoseLandmarkType.rightHip),
      knee: _lm(pose, PoseLandmarkType.rightKnee),
      ankle: _lm(pose, PoseLandmarkType.rightAnkle),
      isLeftSide: false,
    );
    final List<AngleAnalysis> sides = <AngleAnalysis>[left, right];
    final double value =
        sides.map((AngleAnalysis a) => a.degrees).reduce((double a, double b) => a + b) /
            sides.length;
    final double conf = math.min(left.confidence, right.confidence);
    final String? issue = sides.any((AngleAnalysis a) => a.riskFlag == 'knee_valgus')
        ? 'Knees caving inward (valgus)'
        : sides.any((AngleAnalysis a) => a.riskFlag == 'knee_varus')
            ? 'Knees bowing outward (varus)'
            : null;
    return _Signal(value, conf, issue);
  }

  _Signal _elbowSignal(PoseEntity pose) {
    final AngleAnalysis left = PoseMath.analyzeElbow(
      shoulder: _lm(pose, PoseLandmarkType.leftShoulder),
      elbow: _lm(pose, PoseLandmarkType.leftElbow),
      wrist: _lm(pose, PoseLandmarkType.leftWrist),
    );
    final AngleAnalysis right = PoseMath.analyzeElbow(
      shoulder: _lm(pose, PoseLandmarkType.rightShoulder),
      elbow: _lm(pose, PoseLandmarkType.rightElbow),
      wrist: _lm(pose, PoseLandmarkType.rightWrist),
    );
    final double value = (left.degrees + right.degrees) / 2;
    final double conf = math.min(left.confidence, right.confidence);
    return _Signal(value, conf, null);
  }

  _Signal _hipSignal(PoseEntity pose) {
    final double leftAngle = PoseMath.calculateAngle3Points(
      _lm(pose, PoseLandmarkType.leftShoulder),
      _lm(pose, PoseLandmarkType.leftHip),
      _lm(pose, PoseLandmarkType.leftKnee),
    );
    final double rightAngle = PoseMath.calculateAngle3Points(
      _lm(pose, PoseLandmarkType.rightShoulder),
      _lm(pose, PoseLandmarkType.rightHip),
      _lm(pose, PoseLandmarkType.rightKnee),
    );
    final double conf = <double>[
      _lm(pose, PoseLandmarkType.leftShoulder).confidence,
      _lm(pose, PoseLandmarkType.leftHip).confidence,
      _lm(pose, PoseLandmarkType.leftKnee).confidence,
      _lm(pose, PoseLandmarkType.rightShoulder).confidence,
      _lm(pose, PoseLandmarkType.rightHip).confidence,
      _lm(pose, PoseLandmarkType.rightKnee).confidence,
    ].reduce(math.min);
    return _Signal((leftAngle + rightAngle) / 2, conf, null);
  }

  _Signal _ankleSeparationSignal(PoseEntity pose) {
    final LandmarkEntity leftAnkle = _lm(pose, PoseLandmarkType.leftAnkle);
    final LandmarkEntity rightAnkle = _lm(pose, PoseLandmarkType.rightAnkle);
    final double separation = (leftAnkle.x - rightAnkle.x).abs();
    final double conf = math.min(leftAnkle.confidence, rightAnkle.confidence);
    return _Signal(separation, conf, null);
  }

  /// Per-exercise threshold table — the single place to tune counting. `enter`
  /// crosses into the active half, `exit` completes the rep (the dead-band
  /// between them debounces), `good` is the depth/range for clean form.
  static const Map<Exercise, _Spec> _specs = <Exercise, _Spec>{
    Exercise.squat:
        _Spec(activeWhenBelow: true, enter: 120, exit: 160, good: 95),
    Exercise.pushup:
        _Spec(activeWhenBelow: true, enter: 110, exit: 150, good: 95),
    Exercise.situp:
        _Spec(activeWhenBelow: true, enter: 95, exit: 130, good: 75),
    Exercise.bicepCurl:
        _Spec(activeWhenBelow: true, enter: 75, exit: 150, good: 55),
    Exercise.jumpingJack: _Spec(
      activeWhenBelow: false,
      enter: 0.28,
      exit: 0.14,
      good: 0.30,
    ),
  };
}

/// One frame's driving signal: the measured value, its limiting confidence, and
/// an optional form issue (e.g. knee valgus) observed this frame.
class _Signal {
  const _Signal(this.value, this.confidence, this.issue);
  final double value;
  final double confidence;
  final String? issue;
}

/// Thresholds for one exercise. [activeWhenBelow] is true when the active phase
/// is reached by the signal *dropping* (joint angles flexing); false when it is
/// reached by the signal *rising* (limb separation opening).
class _Spec {
  const _Spec({
    required this.activeWhenBelow,
    required this.enter,
    required this.exit,
    required this.good,
  });
  final bool activeWhenBelow;
  final double enter;
  final double exit;
  final double good;
}

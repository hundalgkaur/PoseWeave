// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rep_counter_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RepCounterEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exercise exercise) selectExercise,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
    required TResult Function() reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exercise exercise)? selectExercise,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult? Function()? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exercise exercise)? selectExercise,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult Function()? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectExercise value) selectExercise,
    required TResult Function(RepPoseReceived value) poseReceived,
    required TResult Function(AnalyzeVideoPoses value) analyzeVideoPoses,
    required TResult Function(ResetReps value) reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectExercise value)? selectExercise,
    TResult? Function(RepPoseReceived value)? poseReceived,
    TResult? Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult? Function(ResetReps value)? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectExercise value)? selectExercise,
    TResult Function(RepPoseReceived value)? poseReceived,
    TResult Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult Function(ResetReps value)? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepCounterEventCopyWith<$Res> {
  factory $RepCounterEventCopyWith(
    RepCounterEvent value,
    $Res Function(RepCounterEvent) then,
  ) = _$RepCounterEventCopyWithImpl<$Res, RepCounterEvent>;
}

/// @nodoc
class _$RepCounterEventCopyWithImpl<$Res, $Val extends RepCounterEvent>
    implements $RepCounterEventCopyWith<$Res> {
  _$RepCounterEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SelectExerciseImplCopyWith<$Res> {
  factory _$$SelectExerciseImplCopyWith(
    _$SelectExerciseImpl value,
    $Res Function(_$SelectExerciseImpl) then,
  ) = __$$SelectExerciseImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Exercise exercise});
}

/// @nodoc
class __$$SelectExerciseImplCopyWithImpl<$Res>
    extends _$RepCounterEventCopyWithImpl<$Res, _$SelectExerciseImpl>
    implements _$$SelectExerciseImplCopyWith<$Res> {
  __$$SelectExerciseImplCopyWithImpl(
    _$SelectExerciseImpl _value,
    $Res Function(_$SelectExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? exercise = null}) {
    return _then(
      _$SelectExerciseImpl(
        null == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                as Exercise,
      ),
    );
  }
}

/// @nodoc

class _$SelectExerciseImpl implements SelectExercise {
  const _$SelectExerciseImpl(this.exercise);

  @override
  final Exercise exercise;

  @override
  String toString() {
    return 'RepCounterEvent.selectExercise(exercise: $exercise)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectExerciseImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectExerciseImplCopyWith<_$SelectExerciseImpl> get copyWith =>
      __$$SelectExerciseImplCopyWithImpl<_$SelectExerciseImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exercise exercise) selectExercise,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
    required TResult Function() reset,
  }) {
    return selectExercise(exercise);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exercise exercise)? selectExercise,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult? Function()? reset,
  }) {
    return selectExercise?.call(exercise);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exercise exercise)? selectExercise,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (selectExercise != null) {
      return selectExercise(exercise);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectExercise value) selectExercise,
    required TResult Function(RepPoseReceived value) poseReceived,
    required TResult Function(AnalyzeVideoPoses value) analyzeVideoPoses,
    required TResult Function(ResetReps value) reset,
  }) {
    return selectExercise(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectExercise value)? selectExercise,
    TResult? Function(RepPoseReceived value)? poseReceived,
    TResult? Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult? Function(ResetReps value)? reset,
  }) {
    return selectExercise?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectExercise value)? selectExercise,
    TResult Function(RepPoseReceived value)? poseReceived,
    TResult Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult Function(ResetReps value)? reset,
    required TResult orElse(),
  }) {
    if (selectExercise != null) {
      return selectExercise(this);
    }
    return orElse();
  }
}

abstract class SelectExercise implements RepCounterEvent {
  const factory SelectExercise(final Exercise exercise) = _$SelectExerciseImpl;

  Exercise get exercise;

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SelectExerciseImplCopyWith<_$SelectExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RepPoseReceivedImplCopyWith<$Res> {
  factory _$$RepPoseReceivedImplCopyWith(
    _$RepPoseReceivedImpl value,
    $Res Function(_$RepPoseReceivedImpl) then,
  ) = __$$RepPoseReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseEntity pose});
}

/// @nodoc
class __$$RepPoseReceivedImplCopyWithImpl<$Res>
    extends _$RepCounterEventCopyWithImpl<$Res, _$RepPoseReceivedImpl>
    implements _$$RepPoseReceivedImplCopyWith<$Res> {
  __$$RepPoseReceivedImplCopyWithImpl(
    _$RepPoseReceivedImpl _value,
    $Res Function(_$RepPoseReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pose = null}) {
    return _then(
      _$RepPoseReceivedImpl(
        null == pose
            ? _value.pose
            : pose // ignore: cast_nullable_to_non_nullable
                as PoseEntity,
      ),
    );
  }
}

/// @nodoc

class _$RepPoseReceivedImpl implements RepPoseReceived {
  const _$RepPoseReceivedImpl(this.pose);

  @override
  final PoseEntity pose;

  @override
  String toString() {
    return 'RepCounterEvent.poseReceived(pose: $pose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepPoseReceivedImpl &&
            (identical(other.pose, pose) || other.pose == pose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pose);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepPoseReceivedImplCopyWith<_$RepPoseReceivedImpl> get copyWith =>
      __$$RepPoseReceivedImplCopyWithImpl<_$RepPoseReceivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exercise exercise) selectExercise,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
    required TResult Function() reset,
  }) {
    return poseReceived(pose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exercise exercise)? selectExercise,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult? Function()? reset,
  }) {
    return poseReceived?.call(pose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exercise exercise)? selectExercise,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (poseReceived != null) {
      return poseReceived(pose);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectExercise value) selectExercise,
    required TResult Function(RepPoseReceived value) poseReceived,
    required TResult Function(AnalyzeVideoPoses value) analyzeVideoPoses,
    required TResult Function(ResetReps value) reset,
  }) {
    return poseReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectExercise value)? selectExercise,
    TResult? Function(RepPoseReceived value)? poseReceived,
    TResult? Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult? Function(ResetReps value)? reset,
  }) {
    return poseReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectExercise value)? selectExercise,
    TResult Function(RepPoseReceived value)? poseReceived,
    TResult Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult Function(ResetReps value)? reset,
    required TResult orElse(),
  }) {
    if (poseReceived != null) {
      return poseReceived(this);
    }
    return orElse();
  }
}

abstract class RepPoseReceived implements RepCounterEvent {
  const factory RepPoseReceived(final PoseEntity pose) = _$RepPoseReceivedImpl;

  PoseEntity get pose;

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepPoseReceivedImplCopyWith<_$RepPoseReceivedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AnalyzeVideoPosesImplCopyWith<$Res> {
  factory _$$AnalyzeVideoPosesImplCopyWith(
    _$AnalyzeVideoPosesImpl value,
    $Res Function(_$AnalyzeVideoPosesImpl) then,
  ) = __$$AnalyzeVideoPosesImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PoseEntity> poses});
}

/// @nodoc
class __$$AnalyzeVideoPosesImplCopyWithImpl<$Res>
    extends _$RepCounterEventCopyWithImpl<$Res, _$AnalyzeVideoPosesImpl>
    implements _$$AnalyzeVideoPosesImplCopyWith<$Res> {
  __$$AnalyzeVideoPosesImplCopyWithImpl(
    _$AnalyzeVideoPosesImpl _value,
    $Res Function(_$AnalyzeVideoPosesImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poses = null}) {
    return _then(
      _$AnalyzeVideoPosesImpl(
        null == poses
            ? _value._poses
            : poses // ignore: cast_nullable_to_non_nullable
                as List<PoseEntity>,
      ),
    );
  }
}

/// @nodoc

class _$AnalyzeVideoPosesImpl implements AnalyzeVideoPoses {
  const _$AnalyzeVideoPosesImpl(final List<PoseEntity> poses) : _poses = poses;

  final List<PoseEntity> _poses;
  @override
  List<PoseEntity> get poses {
    if (_poses is EqualUnmodifiableListView) return _poses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_poses);
  }

  @override
  String toString() {
    return 'RepCounterEvent.analyzeVideoPoses(poses: $poses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyzeVideoPosesImpl &&
            const DeepCollectionEquality().equals(other._poses, _poses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_poses));

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyzeVideoPosesImplCopyWith<_$AnalyzeVideoPosesImpl> get copyWith =>
      __$$AnalyzeVideoPosesImplCopyWithImpl<_$AnalyzeVideoPosesImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exercise exercise) selectExercise,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
    required TResult Function() reset,
  }) {
    return analyzeVideoPoses(poses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exercise exercise)? selectExercise,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult? Function()? reset,
  }) {
    return analyzeVideoPoses?.call(poses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exercise exercise)? selectExercise,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (analyzeVideoPoses != null) {
      return analyzeVideoPoses(poses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectExercise value) selectExercise,
    required TResult Function(RepPoseReceived value) poseReceived,
    required TResult Function(AnalyzeVideoPoses value) analyzeVideoPoses,
    required TResult Function(ResetReps value) reset,
  }) {
    return analyzeVideoPoses(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectExercise value)? selectExercise,
    TResult? Function(RepPoseReceived value)? poseReceived,
    TResult? Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult? Function(ResetReps value)? reset,
  }) {
    return analyzeVideoPoses?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectExercise value)? selectExercise,
    TResult Function(RepPoseReceived value)? poseReceived,
    TResult Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult Function(ResetReps value)? reset,
    required TResult orElse(),
  }) {
    if (analyzeVideoPoses != null) {
      return analyzeVideoPoses(this);
    }
    return orElse();
  }
}

abstract class AnalyzeVideoPoses implements RepCounterEvent {
  const factory AnalyzeVideoPoses(final List<PoseEntity> poses) =
      _$AnalyzeVideoPosesImpl;

  List<PoseEntity> get poses;

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyzeVideoPosesImplCopyWith<_$AnalyzeVideoPosesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetRepsImplCopyWith<$Res> {
  factory _$$ResetRepsImplCopyWith(
    _$ResetRepsImpl value,
    $Res Function(_$ResetRepsImpl) then,
  ) = __$$ResetRepsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetRepsImplCopyWithImpl<$Res>
    extends _$RepCounterEventCopyWithImpl<$Res, _$ResetRepsImpl>
    implements _$$ResetRepsImplCopyWith<$Res> {
  __$$ResetRepsImplCopyWithImpl(
    _$ResetRepsImpl _value,
    $Res Function(_$ResetRepsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetRepsImpl implements ResetReps {
  const _$ResetRepsImpl();

  @override
  String toString() {
    return 'RepCounterEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetRepsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Exercise exercise) selectExercise,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Exercise exercise)? selectExercise,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Exercise exercise)? selectExercise,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SelectExercise value) selectExercise,
    required TResult Function(RepPoseReceived value) poseReceived,
    required TResult Function(AnalyzeVideoPoses value) analyzeVideoPoses,
    required TResult Function(ResetReps value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SelectExercise value)? selectExercise,
    TResult? Function(RepPoseReceived value)? poseReceived,
    TResult? Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult? Function(ResetReps value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SelectExercise value)? selectExercise,
    TResult Function(RepPoseReceived value)? poseReceived,
    TResult Function(AnalyzeVideoPoses value)? analyzeVideoPoses,
    TResult Function(ResetReps value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class ResetReps implements RepCounterEvent {
  const factory ResetReps() = _$ResetRepsImpl;
}

/// @nodoc
mixin _$RepCounterState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Exercise exercise, RepCountResult result)
    counting,
    required TResult Function(Exercise exercise, RepCountResult result)
    complete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Exercise exercise, RepCountResult result)? counting,
    TResult? Function(Exercise exercise, RepCountResult result)? complete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Exercise exercise, RepCountResult result)? counting,
    TResult Function(Exercise exercise, RepCountResult result)? complete,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RepCounterIdle value) idle,
    required TResult Function(RepCounterCounting value) counting,
    required TResult Function(RepCounterComplete value) complete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RepCounterIdle value)? idle,
    TResult? Function(RepCounterCounting value)? counting,
    TResult? Function(RepCounterComplete value)? complete,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RepCounterIdle value)? idle,
    TResult Function(RepCounterCounting value)? counting,
    TResult Function(RepCounterComplete value)? complete,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RepCounterStateCopyWith<$Res> {
  factory $RepCounterStateCopyWith(
    RepCounterState value,
    $Res Function(RepCounterState) then,
  ) = _$RepCounterStateCopyWithImpl<$Res, RepCounterState>;
}

/// @nodoc
class _$RepCounterStateCopyWithImpl<$Res, $Val extends RepCounterState>
    implements $RepCounterStateCopyWith<$Res> {
  _$RepCounterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RepCounterIdleImplCopyWith<$Res> {
  factory _$$RepCounterIdleImplCopyWith(
    _$RepCounterIdleImpl value,
    $Res Function(_$RepCounterIdleImpl) then,
  ) = __$$RepCounterIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RepCounterIdleImplCopyWithImpl<$Res>
    extends _$RepCounterStateCopyWithImpl<$Res, _$RepCounterIdleImpl>
    implements _$$RepCounterIdleImplCopyWith<$Res> {
  __$$RepCounterIdleImplCopyWithImpl(
    _$RepCounterIdleImpl _value,
    $Res Function(_$RepCounterIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RepCounterIdleImpl implements RepCounterIdle {
  const _$RepCounterIdleImpl();

  @override
  String toString() {
    return 'RepCounterState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RepCounterIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Exercise exercise, RepCountResult result)
    counting,
    required TResult Function(Exercise exercise, RepCountResult result)
    complete,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Exercise exercise, RepCountResult result)? counting,
    TResult? Function(Exercise exercise, RepCountResult result)? complete,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Exercise exercise, RepCountResult result)? counting,
    TResult Function(Exercise exercise, RepCountResult result)? complete,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RepCounterIdle value) idle,
    required TResult Function(RepCounterCounting value) counting,
    required TResult Function(RepCounterComplete value) complete,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RepCounterIdle value)? idle,
    TResult? Function(RepCounterCounting value)? counting,
    TResult? Function(RepCounterComplete value)? complete,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RepCounterIdle value)? idle,
    TResult Function(RepCounterCounting value)? counting,
    TResult Function(RepCounterComplete value)? complete,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class RepCounterIdle implements RepCounterState {
  const factory RepCounterIdle() = _$RepCounterIdleImpl;
}

/// @nodoc
abstract class _$$RepCounterCountingImplCopyWith<$Res> {
  factory _$$RepCounterCountingImplCopyWith(
    _$RepCounterCountingImpl value,
    $Res Function(_$RepCounterCountingImpl) then,
  ) = __$$RepCounterCountingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Exercise exercise, RepCountResult result});
}

/// @nodoc
class __$$RepCounterCountingImplCopyWithImpl<$Res>
    extends _$RepCounterStateCopyWithImpl<$Res, _$RepCounterCountingImpl>
    implements _$$RepCounterCountingImplCopyWith<$Res> {
  __$$RepCounterCountingImplCopyWithImpl(
    _$RepCounterCountingImpl _value,
    $Res Function(_$RepCounterCountingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? exercise = null, Object? result = null}) {
    return _then(
      _$RepCounterCountingImpl(
        exercise:
            null == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                    as Exercise,
        result:
            null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as RepCountResult,
      ),
    );
  }
}

/// @nodoc

class _$RepCounterCountingImpl implements RepCounterCounting {
  const _$RepCounterCountingImpl({
    required this.exercise,
    required this.result,
  });

  @override
  final Exercise exercise;
  @override
  final RepCountResult result;

  @override
  String toString() {
    return 'RepCounterState.counting(exercise: $exercise, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepCounterCountingImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, result);

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepCounterCountingImplCopyWith<_$RepCounterCountingImpl> get copyWith =>
      __$$RepCounterCountingImplCopyWithImpl<_$RepCounterCountingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Exercise exercise, RepCountResult result)
    counting,
    required TResult Function(Exercise exercise, RepCountResult result)
    complete,
  }) {
    return counting(exercise, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Exercise exercise, RepCountResult result)? counting,
    TResult? Function(Exercise exercise, RepCountResult result)? complete,
  }) {
    return counting?.call(exercise, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Exercise exercise, RepCountResult result)? counting,
    TResult Function(Exercise exercise, RepCountResult result)? complete,
    required TResult orElse(),
  }) {
    if (counting != null) {
      return counting(exercise, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RepCounterIdle value) idle,
    required TResult Function(RepCounterCounting value) counting,
    required TResult Function(RepCounterComplete value) complete,
  }) {
    return counting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RepCounterIdle value)? idle,
    TResult? Function(RepCounterCounting value)? counting,
    TResult? Function(RepCounterComplete value)? complete,
  }) {
    return counting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RepCounterIdle value)? idle,
    TResult Function(RepCounterCounting value)? counting,
    TResult Function(RepCounterComplete value)? complete,
    required TResult orElse(),
  }) {
    if (counting != null) {
      return counting(this);
    }
    return orElse();
  }
}

abstract class RepCounterCounting implements RepCounterState {
  const factory RepCounterCounting({
    required final Exercise exercise,
    required final RepCountResult result,
  }) = _$RepCounterCountingImpl;

  Exercise get exercise;
  RepCountResult get result;

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepCounterCountingImplCopyWith<_$RepCounterCountingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RepCounterCompleteImplCopyWith<$Res> {
  factory _$$RepCounterCompleteImplCopyWith(
    _$RepCounterCompleteImpl value,
    $Res Function(_$RepCounterCompleteImpl) then,
  ) = __$$RepCounterCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Exercise exercise, RepCountResult result});
}

/// @nodoc
class __$$RepCounterCompleteImplCopyWithImpl<$Res>
    extends _$RepCounterStateCopyWithImpl<$Res, _$RepCounterCompleteImpl>
    implements _$$RepCounterCompleteImplCopyWith<$Res> {
  __$$RepCounterCompleteImplCopyWithImpl(
    _$RepCounterCompleteImpl _value,
    $Res Function(_$RepCounterCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? exercise = null, Object? result = null}) {
    return _then(
      _$RepCounterCompleteImpl(
        exercise:
            null == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                    as Exercise,
        result:
            null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as RepCountResult,
      ),
    );
  }
}

/// @nodoc

class _$RepCounterCompleteImpl implements RepCounterComplete {
  const _$RepCounterCompleteImpl({
    required this.exercise,
    required this.result,
  });

  @override
  final Exercise exercise;
  @override
  final RepCountResult result;

  @override
  String toString() {
    return 'RepCounterState.complete(exercise: $exercise, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RepCounterCompleteImpl &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exercise, result);

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RepCounterCompleteImplCopyWith<_$RepCounterCompleteImpl> get copyWith =>
      __$$RepCounterCompleteImplCopyWithImpl<_$RepCounterCompleteImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(Exercise exercise, RepCountResult result)
    counting,
    required TResult Function(Exercise exercise, RepCountResult result)
    complete,
  }) {
    return complete(exercise, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(Exercise exercise, RepCountResult result)? counting,
    TResult? Function(Exercise exercise, RepCountResult result)? complete,
  }) {
    return complete?.call(exercise, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(Exercise exercise, RepCountResult result)? counting,
    TResult Function(Exercise exercise, RepCountResult result)? complete,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(exercise, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RepCounterIdle value) idle,
    required TResult Function(RepCounterCounting value) counting,
    required TResult Function(RepCounterComplete value) complete,
  }) {
    return complete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RepCounterIdle value)? idle,
    TResult? Function(RepCounterCounting value)? counting,
    TResult? Function(RepCounterComplete value)? complete,
  }) {
    return complete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RepCounterIdle value)? idle,
    TResult Function(RepCounterCounting value)? counting,
    TResult Function(RepCounterComplete value)? complete,
    required TResult orElse(),
  }) {
    if (complete != null) {
      return complete(this);
    }
    return orElse();
  }
}

abstract class RepCounterComplete implements RepCounterState {
  const factory RepCounterComplete({
    required final Exercise exercise,
    required final RepCountResult result,
  }) = _$RepCounterCompleteImpl;

  Exercise get exercise;
  RepCountResult get result;

  /// Create a copy of RepCounterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RepCounterCompleteImplCopyWith<_$RepCounterCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

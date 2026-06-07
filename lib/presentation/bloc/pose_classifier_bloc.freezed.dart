// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pose_classifier_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PoseClassifierEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ClassifierPoseReceived value) poseReceived,
    required TResult Function(ClassifierAnalyzeVideo value) analyzeVideoPoses,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ClassifierPoseReceived value)? poseReceived,
    TResult? Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ClassifierPoseReceived value)? poseReceived,
    TResult Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseClassifierEventCopyWith<$Res> {
  factory $PoseClassifierEventCopyWith(
    PoseClassifierEvent value,
    $Res Function(PoseClassifierEvent) then,
  ) = _$PoseClassifierEventCopyWithImpl<$Res, PoseClassifierEvent>;
}

/// @nodoc
class _$PoseClassifierEventCopyWithImpl<$Res, $Val extends PoseClassifierEvent>
    implements $PoseClassifierEventCopyWith<$Res> {
  _$PoseClassifierEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ClassifierPoseReceivedImplCopyWith<$Res> {
  factory _$$ClassifierPoseReceivedImplCopyWith(
    _$ClassifierPoseReceivedImpl value,
    $Res Function(_$ClassifierPoseReceivedImpl) then,
  ) = __$$ClassifierPoseReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseEntity pose});
}

/// @nodoc
class __$$ClassifierPoseReceivedImplCopyWithImpl<$Res>
    extends
        _$PoseClassifierEventCopyWithImpl<$Res, _$ClassifierPoseReceivedImpl>
    implements _$$ClassifierPoseReceivedImplCopyWith<$Res> {
  __$$ClassifierPoseReceivedImplCopyWithImpl(
    _$ClassifierPoseReceivedImpl _value,
    $Res Function(_$ClassifierPoseReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pose = null}) {
    return _then(
      _$ClassifierPoseReceivedImpl(
        null == pose
            ? _value.pose
            : pose // ignore: cast_nullable_to_non_nullable
                as PoseEntity,
      ),
    );
  }
}

/// @nodoc

class _$ClassifierPoseReceivedImpl implements ClassifierPoseReceived {
  const _$ClassifierPoseReceivedImpl(this.pose);

  @override
  final PoseEntity pose;

  @override
  String toString() {
    return 'PoseClassifierEvent.poseReceived(pose: $pose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassifierPoseReceivedImpl &&
            (identical(other.pose, pose) || other.pose == pose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pose);

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassifierPoseReceivedImplCopyWith<_$ClassifierPoseReceivedImpl>
  get copyWith =>
      __$$ClassifierPoseReceivedImplCopyWithImpl<_$ClassifierPoseReceivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
  }) {
    return poseReceived(pose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
  }) {
    return poseReceived?.call(pose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
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
    required TResult Function(ClassifierPoseReceived value) poseReceived,
    required TResult Function(ClassifierAnalyzeVideo value) analyzeVideoPoses,
  }) {
    return poseReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ClassifierPoseReceived value)? poseReceived,
    TResult? Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
  }) {
    return poseReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ClassifierPoseReceived value)? poseReceived,
    TResult Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
    required TResult orElse(),
  }) {
    if (poseReceived != null) {
      return poseReceived(this);
    }
    return orElse();
  }
}

abstract class ClassifierPoseReceived implements PoseClassifierEvent {
  const factory ClassifierPoseReceived(final PoseEntity pose) =
      _$ClassifierPoseReceivedImpl;

  PoseEntity get pose;

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassifierPoseReceivedImplCopyWith<_$ClassifierPoseReceivedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClassifierAnalyzeVideoImplCopyWith<$Res> {
  factory _$$ClassifierAnalyzeVideoImplCopyWith(
    _$ClassifierAnalyzeVideoImpl value,
    $Res Function(_$ClassifierAnalyzeVideoImpl) then,
  ) = __$$ClassifierAnalyzeVideoImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<PoseEntity> poses});
}

/// @nodoc
class __$$ClassifierAnalyzeVideoImplCopyWithImpl<$Res>
    extends
        _$PoseClassifierEventCopyWithImpl<$Res, _$ClassifierAnalyzeVideoImpl>
    implements _$$ClassifierAnalyzeVideoImplCopyWith<$Res> {
  __$$ClassifierAnalyzeVideoImplCopyWithImpl(
    _$ClassifierAnalyzeVideoImpl _value,
    $Res Function(_$ClassifierAnalyzeVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? poses = null}) {
    return _then(
      _$ClassifierAnalyzeVideoImpl(
        null == poses
            ? _value._poses
            : poses // ignore: cast_nullable_to_non_nullable
                as List<PoseEntity>,
      ),
    );
  }
}

/// @nodoc

class _$ClassifierAnalyzeVideoImpl implements ClassifierAnalyzeVideo {
  const _$ClassifierAnalyzeVideoImpl(final List<PoseEntity> poses)
    : _poses = poses;

  final List<PoseEntity> _poses;
  @override
  List<PoseEntity> get poses {
    if (_poses is EqualUnmodifiableListView) return _poses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_poses);
  }

  @override
  String toString() {
    return 'PoseClassifierEvent.analyzeVideoPoses(poses: $poses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClassifierAnalyzeVideoImpl &&
            const DeepCollectionEquality().equals(other._poses, _poses));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_poses));

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClassifierAnalyzeVideoImplCopyWith<_$ClassifierAnalyzeVideoImpl>
  get copyWith =>
      __$$ClassifierAnalyzeVideoImplCopyWithImpl<_$ClassifierAnalyzeVideoImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function(List<PoseEntity> poses) analyzeVideoPoses,
  }) {
    return analyzeVideoPoses(poses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function(List<PoseEntity> poses)? analyzeVideoPoses,
  }) {
    return analyzeVideoPoses?.call(poses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function(List<PoseEntity> poses)? analyzeVideoPoses,
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
    required TResult Function(ClassifierPoseReceived value) poseReceived,
    required TResult Function(ClassifierAnalyzeVideo value) analyzeVideoPoses,
  }) {
    return analyzeVideoPoses(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ClassifierPoseReceived value)? poseReceived,
    TResult? Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
  }) {
    return analyzeVideoPoses?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ClassifierPoseReceived value)? poseReceived,
    TResult Function(ClassifierAnalyzeVideo value)? analyzeVideoPoses,
    required TResult orElse(),
  }) {
    if (analyzeVideoPoses != null) {
      return analyzeVideoPoses(this);
    }
    return orElse();
  }
}

abstract class ClassifierAnalyzeVideo implements PoseClassifierEvent {
  const factory ClassifierAnalyzeVideo(final List<PoseEntity> poses) =
      _$ClassifierAnalyzeVideoImpl;

  List<PoseEntity> get poses;

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassifierAnalyzeVideoImplCopyWith<_$ClassifierAnalyzeVideoImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PoseClassifierState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(PoseMatchResult result) matched,
    required TResult Function(PoseMatchResult result) summary,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
    TResult? Function(PoseMatchResult result)? summary,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
    TResult Function(PoseMatchResult result)? summary,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseClassifierIdle value) idle,
    required TResult Function(PoseClassifierMatched value) matched,
    required TResult Function(PoseClassifierSummary value) summary,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
    TResult? Function(PoseClassifierSummary value)? summary,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
    TResult Function(PoseClassifierSummary value)? summary,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseClassifierStateCopyWith<$Res> {
  factory $PoseClassifierStateCopyWith(
    PoseClassifierState value,
    $Res Function(PoseClassifierState) then,
  ) = _$PoseClassifierStateCopyWithImpl<$Res, PoseClassifierState>;
}

/// @nodoc
class _$PoseClassifierStateCopyWithImpl<$Res, $Val extends PoseClassifierState>
    implements $PoseClassifierStateCopyWith<$Res> {
  _$PoseClassifierStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PoseClassifierIdleImplCopyWith<$Res> {
  factory _$$PoseClassifierIdleImplCopyWith(
    _$PoseClassifierIdleImpl value,
    $Res Function(_$PoseClassifierIdleImpl) then,
  ) = __$$PoseClassifierIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseClassifierIdleImplCopyWithImpl<$Res>
    extends _$PoseClassifierStateCopyWithImpl<$Res, _$PoseClassifierIdleImpl>
    implements _$$PoseClassifierIdleImplCopyWith<$Res> {
  __$$PoseClassifierIdleImplCopyWithImpl(
    _$PoseClassifierIdleImpl _value,
    $Res Function(_$PoseClassifierIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseClassifierIdleImpl implements PoseClassifierIdle {
  const _$PoseClassifierIdleImpl();

  @override
  String toString() {
    return 'PoseClassifierState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseClassifierIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(PoseMatchResult result) matched,
    required TResult Function(PoseMatchResult result) summary,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
    TResult? Function(PoseMatchResult result)? summary,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
    TResult Function(PoseMatchResult result)? summary,
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
    required TResult Function(PoseClassifierIdle value) idle,
    required TResult Function(PoseClassifierMatched value) matched,
    required TResult Function(PoseClassifierSummary value) summary,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
    TResult? Function(PoseClassifierSummary value)? summary,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
    TResult Function(PoseClassifierSummary value)? summary,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PoseClassifierIdle implements PoseClassifierState {
  const factory PoseClassifierIdle() = _$PoseClassifierIdleImpl;
}

/// @nodoc
abstract class _$$PoseClassifierMatchedImplCopyWith<$Res> {
  factory _$$PoseClassifierMatchedImplCopyWith(
    _$PoseClassifierMatchedImpl value,
    $Res Function(_$PoseClassifierMatchedImpl) then,
  ) = __$$PoseClassifierMatchedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseMatchResult result});
}

/// @nodoc
class __$$PoseClassifierMatchedImplCopyWithImpl<$Res>
    extends _$PoseClassifierStateCopyWithImpl<$Res, _$PoseClassifierMatchedImpl>
    implements _$$PoseClassifierMatchedImplCopyWith<$Res> {
  __$$PoseClassifierMatchedImplCopyWithImpl(
    _$PoseClassifierMatchedImpl _value,
    $Res Function(_$PoseClassifierMatchedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null}) {
    return _then(
      _$PoseClassifierMatchedImpl(
        null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                as PoseMatchResult,
      ),
    );
  }
}

/// @nodoc

class _$PoseClassifierMatchedImpl implements PoseClassifierMatched {
  const _$PoseClassifierMatchedImpl(this.result);

  @override
  final PoseMatchResult result;

  @override
  String toString() {
    return 'PoseClassifierState.matched(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseClassifierMatchedImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseClassifierMatchedImplCopyWith<_$PoseClassifierMatchedImpl>
  get copyWith =>
      __$$PoseClassifierMatchedImplCopyWithImpl<_$PoseClassifierMatchedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(PoseMatchResult result) matched,
    required TResult Function(PoseMatchResult result) summary,
  }) {
    return matched(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
    TResult? Function(PoseMatchResult result)? summary,
  }) {
    return matched?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
    TResult Function(PoseMatchResult result)? summary,
    required TResult orElse(),
  }) {
    if (matched != null) {
      return matched(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseClassifierIdle value) idle,
    required TResult Function(PoseClassifierMatched value) matched,
    required TResult Function(PoseClassifierSummary value) summary,
  }) {
    return matched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
    TResult? Function(PoseClassifierSummary value)? summary,
  }) {
    return matched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
    TResult Function(PoseClassifierSummary value)? summary,
    required TResult orElse(),
  }) {
    if (matched != null) {
      return matched(this);
    }
    return orElse();
  }
}

abstract class PoseClassifierMatched implements PoseClassifierState {
  const factory PoseClassifierMatched(final PoseMatchResult result) =
      _$PoseClassifierMatchedImpl;

  PoseMatchResult get result;

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseClassifierMatchedImplCopyWith<_$PoseClassifierMatchedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseClassifierSummaryImplCopyWith<$Res> {
  factory _$$PoseClassifierSummaryImplCopyWith(
    _$PoseClassifierSummaryImpl value,
    $Res Function(_$PoseClassifierSummaryImpl) then,
  ) = __$$PoseClassifierSummaryImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseMatchResult result});
}

/// @nodoc
class __$$PoseClassifierSummaryImplCopyWithImpl<$Res>
    extends _$PoseClassifierStateCopyWithImpl<$Res, _$PoseClassifierSummaryImpl>
    implements _$$PoseClassifierSummaryImplCopyWith<$Res> {
  __$$PoseClassifierSummaryImplCopyWithImpl(
    _$PoseClassifierSummaryImpl _value,
    $Res Function(_$PoseClassifierSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? result = null}) {
    return _then(
      _$PoseClassifierSummaryImpl(
        null == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                as PoseMatchResult,
      ),
    );
  }
}

/// @nodoc

class _$PoseClassifierSummaryImpl implements PoseClassifierSummary {
  const _$PoseClassifierSummaryImpl(this.result);

  @override
  final PoseMatchResult result;

  @override
  String toString() {
    return 'PoseClassifierState.summary(result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseClassifierSummaryImpl &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, result);

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseClassifierSummaryImplCopyWith<_$PoseClassifierSummaryImpl>
  get copyWith =>
      __$$PoseClassifierSummaryImplCopyWithImpl<_$PoseClassifierSummaryImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(PoseMatchResult result) matched,
    required TResult Function(PoseMatchResult result) summary,
  }) {
    return summary(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
    TResult? Function(PoseMatchResult result)? summary,
  }) {
    return summary?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
    TResult Function(PoseMatchResult result)? summary,
    required TResult orElse(),
  }) {
    if (summary != null) {
      return summary(result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseClassifierIdle value) idle,
    required TResult Function(PoseClassifierMatched value) matched,
    required TResult Function(PoseClassifierSummary value) summary,
  }) {
    return summary(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
    TResult? Function(PoseClassifierSummary value)? summary,
  }) {
    return summary?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
    TResult Function(PoseClassifierSummary value)? summary,
    required TResult orElse(),
  }) {
    if (summary != null) {
      return summary(this);
    }
    return orElse();
  }
}

abstract class PoseClassifierSummary implements PoseClassifierState {
  const factory PoseClassifierSummary(final PoseMatchResult result) =
      _$PoseClassifierSummaryImpl;

  PoseMatchResult get result;

  /// Create a copy of PoseClassifierState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseClassifierSummaryImplCopyWith<_$PoseClassifierSummaryImpl>
  get copyWith => throw _privateConstructorUsedError;
}

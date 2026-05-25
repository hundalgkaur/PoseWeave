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
  PoseEntity get pose => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseEntity pose) poseReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseEntity pose)? poseReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseEntity pose)? poseReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ClassifierPoseReceived value) poseReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ClassifierPoseReceived value)? poseReceived,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ClassifierPoseReceived value)? poseReceived,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoseClassifierEventCopyWith<PoseClassifierEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseClassifierEventCopyWith<$Res> {
  factory $PoseClassifierEventCopyWith(
    PoseClassifierEvent value,
    $Res Function(PoseClassifierEvent) then,
  ) = _$PoseClassifierEventCopyWithImpl<$Res, PoseClassifierEvent>;
  @useResult
  $Res call({PoseEntity pose});
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
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pose = null}) {
    return _then(
      _value.copyWith(
            pose:
                null == pose
                    ? _value.pose
                    : pose // ignore: cast_nullable_to_non_nullable
                        as PoseEntity,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ClassifierPoseReceivedImplCopyWith<$Res>
    implements $PoseClassifierEventCopyWith<$Res> {
  factory _$$ClassifierPoseReceivedImplCopyWith(
    _$ClassifierPoseReceivedImpl value,
    $Res Function(_$ClassifierPoseReceivedImpl) then,
  ) = __$$ClassifierPoseReceivedImplCopyWithImpl<$Res>;
  @override
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
  }) {
    return poseReceived(pose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseEntity pose)? poseReceived,
  }) {
    return poseReceived?.call(pose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseEntity pose)? poseReceived,
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
  }) {
    return poseReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ClassifierPoseReceived value)? poseReceived,
  }) {
    return poseReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ClassifierPoseReceived value)? poseReceived,
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

  @override
  PoseEntity get pose;

  /// Create a copy of PoseClassifierEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClassifierPoseReceivedImplCopyWith<_$ClassifierPoseReceivedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PoseClassifierState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(PoseMatchResult result) matched,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseClassifierIdle value) idle,
    required TResult Function(PoseClassifierMatched value) matched,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
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
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
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
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
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
  }) {
    return matched(result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(PoseMatchResult result)? matched,
  }) {
    return matched?.call(result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(PoseMatchResult result)? matched,
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
  }) {
    return matched(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseClassifierIdle value)? idle,
    TResult? Function(PoseClassifierMatched value)? matched,
  }) {
    return matched?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseClassifierIdle value)? idle,
    TResult Function(PoseClassifierMatched value)? matched,
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

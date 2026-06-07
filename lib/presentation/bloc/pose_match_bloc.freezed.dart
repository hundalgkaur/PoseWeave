// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pose_match_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PoseMatchEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseTemplate template) selectTemplate,
    required TResult Function(PoseEntity reference) selectReferencePose,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function() reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseTemplate template)? selectTemplate,
    TResult? Function(PoseEntity reference)? selectReferencePose,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function()? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseTemplate template)? selectTemplate,
    TResult Function(PoseEntity reference)? selectReferencePose,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function()? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatchSelectTemplate value) selectTemplate,
    required TResult Function(MatchSelectReference value) selectReferencePose,
    required TResult Function(MatchPoseReceived value) poseReceived,
    required TResult Function(MatchReset value) reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatchSelectTemplate value)? selectTemplate,
    TResult? Function(MatchSelectReference value)? selectReferencePose,
    TResult? Function(MatchPoseReceived value)? poseReceived,
    TResult? Function(MatchReset value)? reset,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatchSelectTemplate value)? selectTemplate,
    TResult Function(MatchSelectReference value)? selectReferencePose,
    TResult Function(MatchPoseReceived value)? poseReceived,
    TResult Function(MatchReset value)? reset,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseMatchEventCopyWith<$Res> {
  factory $PoseMatchEventCopyWith(
    PoseMatchEvent value,
    $Res Function(PoseMatchEvent) then,
  ) = _$PoseMatchEventCopyWithImpl<$Res, PoseMatchEvent>;
}

/// @nodoc
class _$PoseMatchEventCopyWithImpl<$Res, $Val extends PoseMatchEvent>
    implements $PoseMatchEventCopyWith<$Res> {
  _$PoseMatchEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$MatchSelectTemplateImplCopyWith<$Res> {
  factory _$$MatchSelectTemplateImplCopyWith(
    _$MatchSelectTemplateImpl value,
    $Res Function(_$MatchSelectTemplateImpl) then,
  ) = __$$MatchSelectTemplateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseTemplate template});
}

/// @nodoc
class __$$MatchSelectTemplateImplCopyWithImpl<$Res>
    extends _$PoseMatchEventCopyWithImpl<$Res, _$MatchSelectTemplateImpl>
    implements _$$MatchSelectTemplateImplCopyWith<$Res> {
  __$$MatchSelectTemplateImplCopyWithImpl(
    _$MatchSelectTemplateImpl _value,
    $Res Function(_$MatchSelectTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? template = null}) {
    return _then(
      _$MatchSelectTemplateImpl(
        null == template
            ? _value.template
            : template // ignore: cast_nullable_to_non_nullable
                as PoseTemplate,
      ),
    );
  }
}

/// @nodoc

class _$MatchSelectTemplateImpl implements MatchSelectTemplate {
  const _$MatchSelectTemplateImpl(this.template);

  @override
  final PoseTemplate template;

  @override
  String toString() {
    return 'PoseMatchEvent.selectTemplate(template: $template)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchSelectTemplateImpl &&
            (identical(other.template, template) ||
                other.template == template));
  }

  @override
  int get hashCode => Object.hash(runtimeType, template);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchSelectTemplateImplCopyWith<_$MatchSelectTemplateImpl> get copyWith =>
      __$$MatchSelectTemplateImplCopyWithImpl<_$MatchSelectTemplateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseTemplate template) selectTemplate,
    required TResult Function(PoseEntity reference) selectReferencePose,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function() reset,
  }) {
    return selectTemplate(template);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseTemplate template)? selectTemplate,
    TResult? Function(PoseEntity reference)? selectReferencePose,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function()? reset,
  }) {
    return selectTemplate?.call(template);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseTemplate template)? selectTemplate,
    TResult Function(PoseEntity reference)? selectReferencePose,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (selectTemplate != null) {
      return selectTemplate(template);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatchSelectTemplate value) selectTemplate,
    required TResult Function(MatchSelectReference value) selectReferencePose,
    required TResult Function(MatchPoseReceived value) poseReceived,
    required TResult Function(MatchReset value) reset,
  }) {
    return selectTemplate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatchSelectTemplate value)? selectTemplate,
    TResult? Function(MatchSelectReference value)? selectReferencePose,
    TResult? Function(MatchPoseReceived value)? poseReceived,
    TResult? Function(MatchReset value)? reset,
  }) {
    return selectTemplate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatchSelectTemplate value)? selectTemplate,
    TResult Function(MatchSelectReference value)? selectReferencePose,
    TResult Function(MatchPoseReceived value)? poseReceived,
    TResult Function(MatchReset value)? reset,
    required TResult orElse(),
  }) {
    if (selectTemplate != null) {
      return selectTemplate(this);
    }
    return orElse();
  }
}

abstract class MatchSelectTemplate implements PoseMatchEvent {
  const factory MatchSelectTemplate(final PoseTemplate template) =
      _$MatchSelectTemplateImpl;

  PoseTemplate get template;

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchSelectTemplateImplCopyWith<_$MatchSelectTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MatchSelectReferenceImplCopyWith<$Res> {
  factory _$$MatchSelectReferenceImplCopyWith(
    _$MatchSelectReferenceImpl value,
    $Res Function(_$MatchSelectReferenceImpl) then,
  ) = __$$MatchSelectReferenceImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseEntity reference});
}

/// @nodoc
class __$$MatchSelectReferenceImplCopyWithImpl<$Res>
    extends _$PoseMatchEventCopyWithImpl<$Res, _$MatchSelectReferenceImpl>
    implements _$$MatchSelectReferenceImplCopyWith<$Res> {
  __$$MatchSelectReferenceImplCopyWithImpl(
    _$MatchSelectReferenceImpl _value,
    $Res Function(_$MatchSelectReferenceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reference = null}) {
    return _then(
      _$MatchSelectReferenceImpl(
        null == reference
            ? _value.reference
            : reference // ignore: cast_nullable_to_non_nullable
                as PoseEntity,
      ),
    );
  }
}

/// @nodoc

class _$MatchSelectReferenceImpl implements MatchSelectReference {
  const _$MatchSelectReferenceImpl(this.reference);

  @override
  final PoseEntity reference;

  @override
  String toString() {
    return 'PoseMatchEvent.selectReferencePose(reference: $reference)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchSelectReferenceImpl &&
            (identical(other.reference, reference) ||
                other.reference == reference));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchSelectReferenceImplCopyWith<_$MatchSelectReferenceImpl>
  get copyWith =>
      __$$MatchSelectReferenceImplCopyWithImpl<_$MatchSelectReferenceImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseTemplate template) selectTemplate,
    required TResult Function(PoseEntity reference) selectReferencePose,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function() reset,
  }) {
    return selectReferencePose(reference);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseTemplate template)? selectTemplate,
    TResult? Function(PoseEntity reference)? selectReferencePose,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function()? reset,
  }) {
    return selectReferencePose?.call(reference);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseTemplate template)? selectTemplate,
    TResult Function(PoseEntity reference)? selectReferencePose,
    TResult Function(PoseEntity pose)? poseReceived,
    TResult Function()? reset,
    required TResult orElse(),
  }) {
    if (selectReferencePose != null) {
      return selectReferencePose(reference);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(MatchSelectTemplate value) selectTemplate,
    required TResult Function(MatchSelectReference value) selectReferencePose,
    required TResult Function(MatchPoseReceived value) poseReceived,
    required TResult Function(MatchReset value) reset,
  }) {
    return selectReferencePose(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatchSelectTemplate value)? selectTemplate,
    TResult? Function(MatchSelectReference value)? selectReferencePose,
    TResult? Function(MatchPoseReceived value)? poseReceived,
    TResult? Function(MatchReset value)? reset,
  }) {
    return selectReferencePose?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatchSelectTemplate value)? selectTemplate,
    TResult Function(MatchSelectReference value)? selectReferencePose,
    TResult Function(MatchPoseReceived value)? poseReceived,
    TResult Function(MatchReset value)? reset,
    required TResult orElse(),
  }) {
    if (selectReferencePose != null) {
      return selectReferencePose(this);
    }
    return orElse();
  }
}

abstract class MatchSelectReference implements PoseMatchEvent {
  const factory MatchSelectReference(final PoseEntity reference) =
      _$MatchSelectReferenceImpl;

  PoseEntity get reference;

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchSelectReferenceImplCopyWith<_$MatchSelectReferenceImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MatchPoseReceivedImplCopyWith<$Res> {
  factory _$$MatchPoseReceivedImplCopyWith(
    _$MatchPoseReceivedImpl value,
    $Res Function(_$MatchPoseReceivedImpl) then,
  ) = __$$MatchPoseReceivedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PoseEntity pose});
}

/// @nodoc
class __$$MatchPoseReceivedImplCopyWithImpl<$Res>
    extends _$PoseMatchEventCopyWithImpl<$Res, _$MatchPoseReceivedImpl>
    implements _$$MatchPoseReceivedImplCopyWith<$Res> {
  __$$MatchPoseReceivedImplCopyWithImpl(
    _$MatchPoseReceivedImpl _value,
    $Res Function(_$MatchPoseReceivedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pose = null}) {
    return _then(
      _$MatchPoseReceivedImpl(
        null == pose
            ? _value.pose
            : pose // ignore: cast_nullable_to_non_nullable
                as PoseEntity,
      ),
    );
  }
}

/// @nodoc

class _$MatchPoseReceivedImpl implements MatchPoseReceived {
  const _$MatchPoseReceivedImpl(this.pose);

  @override
  final PoseEntity pose;

  @override
  String toString() {
    return 'PoseMatchEvent.poseReceived(pose: $pose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchPoseReceivedImpl &&
            (identical(other.pose, pose) || other.pose == pose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pose);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchPoseReceivedImplCopyWith<_$MatchPoseReceivedImpl> get copyWith =>
      __$$MatchPoseReceivedImplCopyWithImpl<_$MatchPoseReceivedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseTemplate template) selectTemplate,
    required TResult Function(PoseEntity reference) selectReferencePose,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function() reset,
  }) {
    return poseReceived(pose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseTemplate template)? selectTemplate,
    TResult? Function(PoseEntity reference)? selectReferencePose,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function()? reset,
  }) {
    return poseReceived?.call(pose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseTemplate template)? selectTemplate,
    TResult Function(PoseEntity reference)? selectReferencePose,
    TResult Function(PoseEntity pose)? poseReceived,
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
    required TResult Function(MatchSelectTemplate value) selectTemplate,
    required TResult Function(MatchSelectReference value) selectReferencePose,
    required TResult Function(MatchPoseReceived value) poseReceived,
    required TResult Function(MatchReset value) reset,
  }) {
    return poseReceived(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatchSelectTemplate value)? selectTemplate,
    TResult? Function(MatchSelectReference value)? selectReferencePose,
    TResult? Function(MatchPoseReceived value)? poseReceived,
    TResult? Function(MatchReset value)? reset,
  }) {
    return poseReceived?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatchSelectTemplate value)? selectTemplate,
    TResult Function(MatchSelectReference value)? selectReferencePose,
    TResult Function(MatchPoseReceived value)? poseReceived,
    TResult Function(MatchReset value)? reset,
    required TResult orElse(),
  }) {
    if (poseReceived != null) {
      return poseReceived(this);
    }
    return orElse();
  }
}

abstract class MatchPoseReceived implements PoseMatchEvent {
  const factory MatchPoseReceived(final PoseEntity pose) =
      _$MatchPoseReceivedImpl;

  PoseEntity get pose;

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchPoseReceivedImplCopyWith<_$MatchPoseReceivedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MatchResetImplCopyWith<$Res> {
  factory _$$MatchResetImplCopyWith(
    _$MatchResetImpl value,
    $Res Function(_$MatchResetImpl) then,
  ) = __$$MatchResetImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MatchResetImplCopyWithImpl<$Res>
    extends _$PoseMatchEventCopyWithImpl<$Res, _$MatchResetImpl>
    implements _$$MatchResetImplCopyWith<$Res> {
  __$$MatchResetImplCopyWithImpl(
    _$MatchResetImpl _value,
    $Res Function(_$MatchResetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$MatchResetImpl implements MatchReset {
  const _$MatchResetImpl();

  @override
  String toString() {
    return 'PoseMatchEvent.reset()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MatchResetImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(PoseTemplate template) selectTemplate,
    required TResult Function(PoseEntity reference) selectReferencePose,
    required TResult Function(PoseEntity pose) poseReceived,
    required TResult Function() reset,
  }) {
    return reset();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(PoseTemplate template)? selectTemplate,
    TResult? Function(PoseEntity reference)? selectReferencePose,
    TResult? Function(PoseEntity pose)? poseReceived,
    TResult? Function()? reset,
  }) {
    return reset?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(PoseTemplate template)? selectTemplate,
    TResult Function(PoseEntity reference)? selectReferencePose,
    TResult Function(PoseEntity pose)? poseReceived,
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
    required TResult Function(MatchSelectTemplate value) selectTemplate,
    required TResult Function(MatchSelectReference value) selectReferencePose,
    required TResult Function(MatchPoseReceived value) poseReceived,
    required TResult Function(MatchReset value) reset,
  }) {
    return reset(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(MatchSelectTemplate value)? selectTemplate,
    TResult? Function(MatchSelectReference value)? selectReferencePose,
    TResult? Function(MatchPoseReceived value)? poseReceived,
    TResult? Function(MatchReset value)? reset,
  }) {
    return reset?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(MatchSelectTemplate value)? selectTemplate,
    TResult Function(MatchSelectReference value)? selectReferencePose,
    TResult Function(MatchPoseReceived value)? poseReceived,
    TResult Function(MatchReset value)? reset,
    required TResult orElse(),
  }) {
    if (reset != null) {
      return reset(this);
    }
    return orElse();
  }
}

abstract class MatchReset implements PoseMatchEvent {
  const factory MatchReset() = _$MatchResetImpl;
}

/// @nodoc
mixin _$PoseMatchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )
    matching,
    required TResult Function(String label, PoseMatchResult result) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )?
    matching,
    TResult? Function(String label, PoseMatchResult result)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String label, PoseMatchResult result, double holdProgress)?
    matching,
    TResult Function(String label, PoseMatchResult result)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseMatchIdle value) idle,
    required TResult Function(PoseMatchMatching value) matching,
    required TResult Function(PoseMatchCompleted value) completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseMatchIdle value)? idle,
    TResult? Function(PoseMatchMatching value)? matching,
    TResult? Function(PoseMatchCompleted value)? completed,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseMatchIdle value)? idle,
    TResult Function(PoseMatchMatching value)? matching,
    TResult Function(PoseMatchCompleted value)? completed,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseMatchStateCopyWith<$Res> {
  factory $PoseMatchStateCopyWith(
    PoseMatchState value,
    $Res Function(PoseMatchState) then,
  ) = _$PoseMatchStateCopyWithImpl<$Res, PoseMatchState>;
}

/// @nodoc
class _$PoseMatchStateCopyWithImpl<$Res, $Val extends PoseMatchState>
    implements $PoseMatchStateCopyWith<$Res> {
  _$PoseMatchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PoseMatchIdleImplCopyWith<$Res> {
  factory _$$PoseMatchIdleImplCopyWith(
    _$PoseMatchIdleImpl value,
    $Res Function(_$PoseMatchIdleImpl) then,
  ) = __$$PoseMatchIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseMatchIdleImplCopyWithImpl<$Res>
    extends _$PoseMatchStateCopyWithImpl<$Res, _$PoseMatchIdleImpl>
    implements _$$PoseMatchIdleImplCopyWith<$Res> {
  __$$PoseMatchIdleImplCopyWithImpl(
    _$PoseMatchIdleImpl _value,
    $Res Function(_$PoseMatchIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseMatchIdleImpl implements PoseMatchIdle {
  const _$PoseMatchIdleImpl();

  @override
  String toString() {
    return 'PoseMatchState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseMatchIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )
    matching,
    required TResult Function(String label, PoseMatchResult result) completed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )?
    matching,
    TResult? Function(String label, PoseMatchResult result)? completed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String label, PoseMatchResult result, double holdProgress)?
    matching,
    TResult Function(String label, PoseMatchResult result)? completed,
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
    required TResult Function(PoseMatchIdle value) idle,
    required TResult Function(PoseMatchMatching value) matching,
    required TResult Function(PoseMatchCompleted value) completed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseMatchIdle value)? idle,
    TResult? Function(PoseMatchMatching value)? matching,
    TResult? Function(PoseMatchCompleted value)? completed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseMatchIdle value)? idle,
    TResult Function(PoseMatchMatching value)? matching,
    TResult Function(PoseMatchCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PoseMatchIdle implements PoseMatchState {
  const factory PoseMatchIdle() = _$PoseMatchIdleImpl;
}

/// @nodoc
abstract class _$$PoseMatchMatchingImplCopyWith<$Res> {
  factory _$$PoseMatchMatchingImplCopyWith(
    _$PoseMatchMatchingImpl value,
    $Res Function(_$PoseMatchMatchingImpl) then,
  ) = __$$PoseMatchMatchingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String label, PoseMatchResult result, double holdProgress});
}

/// @nodoc
class __$$PoseMatchMatchingImplCopyWithImpl<$Res>
    extends _$PoseMatchStateCopyWithImpl<$Res, _$PoseMatchMatchingImpl>
    implements _$$PoseMatchMatchingImplCopyWith<$Res> {
  __$$PoseMatchMatchingImplCopyWithImpl(
    _$PoseMatchMatchingImpl _value,
    $Res Function(_$PoseMatchMatchingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? result = null,
    Object? holdProgress = null,
  }) {
    return _then(
      _$PoseMatchMatchingImpl(
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        result:
            null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as PoseMatchResult,
        holdProgress:
            null == holdProgress
                ? _value.holdProgress
                : holdProgress // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc

class _$PoseMatchMatchingImpl implements PoseMatchMatching {
  const _$PoseMatchMatchingImpl({
    required this.label,
    required this.result,
    required this.holdProgress,
  });

  @override
  final String label;
  @override
  final PoseMatchResult result;
  @override
  final double holdProgress;

  @override
  String toString() {
    return 'PoseMatchState.matching(label: $label, result: $result, holdProgress: $holdProgress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseMatchMatchingImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.holdProgress, holdProgress) ||
                other.holdProgress == holdProgress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, result, holdProgress);

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseMatchMatchingImplCopyWith<_$PoseMatchMatchingImpl> get copyWith =>
      __$$PoseMatchMatchingImplCopyWithImpl<_$PoseMatchMatchingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )
    matching,
    required TResult Function(String label, PoseMatchResult result) completed,
  }) {
    return matching(label, result, holdProgress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )?
    matching,
    TResult? Function(String label, PoseMatchResult result)? completed,
  }) {
    return matching?.call(label, result, holdProgress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String label, PoseMatchResult result, double holdProgress)?
    matching,
    TResult Function(String label, PoseMatchResult result)? completed,
    required TResult orElse(),
  }) {
    if (matching != null) {
      return matching(label, result, holdProgress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseMatchIdle value) idle,
    required TResult Function(PoseMatchMatching value) matching,
    required TResult Function(PoseMatchCompleted value) completed,
  }) {
    return matching(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseMatchIdle value)? idle,
    TResult? Function(PoseMatchMatching value)? matching,
    TResult? Function(PoseMatchCompleted value)? completed,
  }) {
    return matching?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseMatchIdle value)? idle,
    TResult Function(PoseMatchMatching value)? matching,
    TResult Function(PoseMatchCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (matching != null) {
      return matching(this);
    }
    return orElse();
  }
}

abstract class PoseMatchMatching implements PoseMatchState {
  const factory PoseMatchMatching({
    required final String label,
    required final PoseMatchResult result,
    required final double holdProgress,
  }) = _$PoseMatchMatchingImpl;

  String get label;
  PoseMatchResult get result;
  double get holdProgress;

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseMatchMatchingImplCopyWith<_$PoseMatchMatchingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseMatchCompletedImplCopyWith<$Res> {
  factory _$$PoseMatchCompletedImplCopyWith(
    _$PoseMatchCompletedImpl value,
    $Res Function(_$PoseMatchCompletedImpl) then,
  ) = __$$PoseMatchCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String label, PoseMatchResult result});
}

/// @nodoc
class __$$PoseMatchCompletedImplCopyWithImpl<$Res>
    extends _$PoseMatchStateCopyWithImpl<$Res, _$PoseMatchCompletedImpl>
    implements _$$PoseMatchCompletedImplCopyWith<$Res> {
  __$$PoseMatchCompletedImplCopyWithImpl(
    _$PoseMatchCompletedImpl _value,
    $Res Function(_$PoseMatchCompletedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? result = null}) {
    return _then(
      _$PoseMatchCompletedImpl(
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        result:
            null == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                    as PoseMatchResult,
      ),
    );
  }
}

/// @nodoc

class _$PoseMatchCompletedImpl implements PoseMatchCompleted {
  const _$PoseMatchCompletedImpl({required this.label, required this.result});

  @override
  final String label;
  @override
  final PoseMatchResult result;

  @override
  String toString() {
    return 'PoseMatchState.completed(label: $label, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseMatchCompletedImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, result);

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseMatchCompletedImplCopyWith<_$PoseMatchCompletedImpl> get copyWith =>
      __$$PoseMatchCompletedImplCopyWithImpl<_$PoseMatchCompletedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )
    matching,
    required TResult Function(String label, PoseMatchResult result) completed,
  }) {
    return completed(label, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(
      String label,
      PoseMatchResult result,
      double holdProgress,
    )?
    matching,
    TResult? Function(String label, PoseMatchResult result)? completed,
  }) {
    return completed?.call(label, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String label, PoseMatchResult result, double holdProgress)?
    matching,
    TResult Function(String label, PoseMatchResult result)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(label, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseMatchIdle value) idle,
    required TResult Function(PoseMatchMatching value) matching,
    required TResult Function(PoseMatchCompleted value) completed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseMatchIdle value)? idle,
    TResult? Function(PoseMatchMatching value)? matching,
    TResult? Function(PoseMatchCompleted value)? completed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseMatchIdle value)? idle,
    TResult Function(PoseMatchMatching value)? matching,
    TResult Function(PoseMatchCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class PoseMatchCompleted implements PoseMatchState {
  const factory PoseMatchCompleted({
    required final String label,
    required final PoseMatchResult result,
  }) = _$PoseMatchCompletedImpl;

  String get label;
  PoseMatchResult get result;

  /// Create a copy of PoseMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseMatchCompletedImplCopyWith<_$PoseMatchCompletedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

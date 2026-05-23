// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendations_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RecommendationsEvent {
  GaitParameters get gait => throw _privateConstructorUsedError;
  Map<String, SegmentSummary> get segments =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      GaitParameters gait,
      Map<String, SegmentSummary> segments,
    )
    fetch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      GaitParameters gait,
      Map<String, SegmentSummary> segments,
    )?
    fetch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GaitParameters gait, Map<String, SegmentSummary> segments)?
    fetch,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchRecommendations value) fetch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchRecommendations value)? fetch,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchRecommendations value)? fetch,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationsEventCopyWith<RecommendationsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationsEventCopyWith<$Res> {
  factory $RecommendationsEventCopyWith(
    RecommendationsEvent value,
    $Res Function(RecommendationsEvent) then,
  ) = _$RecommendationsEventCopyWithImpl<$Res, RecommendationsEvent>;
  @useResult
  $Res call({GaitParameters gait, Map<String, SegmentSummary> segments});
}

/// @nodoc
class _$RecommendationsEventCopyWithImpl<
  $Res,
  $Val extends RecommendationsEvent
>
    implements $RecommendationsEventCopyWith<$Res> {
  _$RecommendationsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gait = null, Object? segments = null}) {
    return _then(
      _value.copyWith(
            gait:
                null == gait
                    ? _value.gait
                    : gait // ignore: cast_nullable_to_non_nullable
                        as GaitParameters,
            segments:
                null == segments
                    ? _value.segments
                    : segments // ignore: cast_nullable_to_non_nullable
                        as Map<String, SegmentSummary>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FetchRecommendationsImplCopyWith<$Res>
    implements $RecommendationsEventCopyWith<$Res> {
  factory _$$FetchRecommendationsImplCopyWith(
    _$FetchRecommendationsImpl value,
    $Res Function(_$FetchRecommendationsImpl) then,
  ) = __$$FetchRecommendationsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({GaitParameters gait, Map<String, SegmentSummary> segments});
}

/// @nodoc
class __$$FetchRecommendationsImplCopyWithImpl<$Res>
    extends _$RecommendationsEventCopyWithImpl<$Res, _$FetchRecommendationsImpl>
    implements _$$FetchRecommendationsImplCopyWith<$Res> {
  __$$FetchRecommendationsImplCopyWithImpl(
    _$FetchRecommendationsImpl _value,
    $Res Function(_$FetchRecommendationsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? gait = null, Object? segments = null}) {
    return _then(
      _$FetchRecommendationsImpl(
        gait:
            null == gait
                ? _value.gait
                : gait // ignore: cast_nullable_to_non_nullable
                    as GaitParameters,
        segments:
            null == segments
                ? _value._segments
                : segments // ignore: cast_nullable_to_non_nullable
                    as Map<String, SegmentSummary>,
      ),
    );
  }
}

/// @nodoc

class _$FetchRecommendationsImpl implements FetchRecommendations {
  const _$FetchRecommendationsImpl({
    required this.gait,
    required final Map<String, SegmentSummary> segments,
  }) : _segments = segments;

  @override
  final GaitParameters gait;
  final Map<String, SegmentSummary> _segments;
  @override
  Map<String, SegmentSummary> get segments {
    if (_segments is EqualUnmodifiableMapView) return _segments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_segments);
  }

  @override
  String toString() {
    return 'RecommendationsEvent.fetch(gait: $gait, segments: $segments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FetchRecommendationsImpl &&
            (identical(other.gait, gait) || other.gait == gait) &&
            const DeepCollectionEquality().equals(other._segments, _segments));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    gait,
    const DeepCollectionEquality().hash(_segments),
  );

  /// Create a copy of RecommendationsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FetchRecommendationsImplCopyWith<_$FetchRecommendationsImpl>
  get copyWith =>
      __$$FetchRecommendationsImplCopyWithImpl<_$FetchRecommendationsImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
      GaitParameters gait,
      Map<String, SegmentSummary> segments,
    )
    fetch,
  }) {
    return fetch(gait, segments);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
      GaitParameters gait,
      Map<String, SegmentSummary> segments,
    )?
    fetch,
  }) {
    return fetch?.call(gait, segments);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(GaitParameters gait, Map<String, SegmentSummary> segments)?
    fetch,
    required TResult orElse(),
  }) {
    if (fetch != null) {
      return fetch(gait, segments);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(FetchRecommendations value) fetch,
  }) {
    return fetch(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(FetchRecommendations value)? fetch,
  }) {
    return fetch?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(FetchRecommendations value)? fetch,
    required TResult orElse(),
  }) {
    if (fetch != null) {
      return fetch(this);
    }
    return orElse();
  }
}

abstract class FetchRecommendations implements RecommendationsEvent {
  const factory FetchRecommendations({
    required final GaitParameters gait,
    required final Map<String, SegmentSummary> segments,
  }) = _$FetchRecommendationsImpl;

  @override
  GaitParameters get gait;
  @override
  Map<String, SegmentSummary> get segments;

  /// Create a copy of RecommendationsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FetchRecommendationsImplCopyWith<_$FetchRecommendationsImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RecommendationsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RecommendationEntity> items) loaded,
    required TResult Function(String message, bool needsKey) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RecommendationEntity> items)? loaded,
    TResult? Function(String message, bool needsKey)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RecommendationEntity> items)? loaded,
    TResult Function(String message, bool needsKey)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendationsInitial value) initial,
    required TResult Function(RecommendationsLoading value) loading,
    required TResult Function(RecommendationsLoaded value) loaded,
    required TResult Function(RecommendationsError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecommendationsInitial value)? initial,
    TResult? Function(RecommendationsLoading value)? loading,
    TResult? Function(RecommendationsLoaded value)? loaded,
    TResult? Function(RecommendationsError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecommendationsInitial value)? initial,
    TResult Function(RecommendationsLoading value)? loading,
    TResult Function(RecommendationsLoaded value)? loaded,
    TResult Function(RecommendationsError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationsStateCopyWith<$Res> {
  factory $RecommendationsStateCopyWith(
    RecommendationsState value,
    $Res Function(RecommendationsState) then,
  ) = _$RecommendationsStateCopyWithImpl<$Res, RecommendationsState>;
}

/// @nodoc
class _$RecommendationsStateCopyWithImpl<
  $Res,
  $Val extends RecommendationsState
>
    implements $RecommendationsStateCopyWith<$Res> {
  _$RecommendationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$RecommendationsInitialImplCopyWith<$Res> {
  factory _$$RecommendationsInitialImplCopyWith(
    _$RecommendationsInitialImpl value,
    $Res Function(_$RecommendationsInitialImpl) then,
  ) = __$$RecommendationsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RecommendationsInitialImplCopyWithImpl<$Res>
    extends
        _$RecommendationsStateCopyWithImpl<$Res, _$RecommendationsInitialImpl>
    implements _$$RecommendationsInitialImplCopyWith<$Res> {
  __$$RecommendationsInitialImplCopyWithImpl(
    _$RecommendationsInitialImpl _value,
    $Res Function(_$RecommendationsInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RecommendationsInitialImpl implements RecommendationsInitial {
  const _$RecommendationsInitialImpl();

  @override
  String toString() {
    return 'RecommendationsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RecommendationEntity> items) loaded,
    required TResult Function(String message, bool needsKey) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RecommendationEntity> items)? loaded,
    TResult? Function(String message, bool needsKey)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RecommendationEntity> items)? loaded,
    TResult Function(String message, bool needsKey)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendationsInitial value) initial,
    required TResult Function(RecommendationsLoading value) loading,
    required TResult Function(RecommendationsLoaded value) loaded,
    required TResult Function(RecommendationsError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecommendationsInitial value)? initial,
    TResult? Function(RecommendationsLoading value)? loading,
    TResult? Function(RecommendationsLoaded value)? loaded,
    TResult? Function(RecommendationsError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecommendationsInitial value)? initial,
    TResult Function(RecommendationsLoading value)? loading,
    TResult Function(RecommendationsLoaded value)? loaded,
    TResult Function(RecommendationsError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class RecommendationsInitial implements RecommendationsState {
  const factory RecommendationsInitial() = _$RecommendationsInitialImpl;
}

/// @nodoc
abstract class _$$RecommendationsLoadingImplCopyWith<$Res> {
  factory _$$RecommendationsLoadingImplCopyWith(
    _$RecommendationsLoadingImpl value,
    $Res Function(_$RecommendationsLoadingImpl) then,
  ) = __$$RecommendationsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RecommendationsLoadingImplCopyWithImpl<$Res>
    extends
        _$RecommendationsStateCopyWithImpl<$Res, _$RecommendationsLoadingImpl>
    implements _$$RecommendationsLoadingImplCopyWith<$Res> {
  __$$RecommendationsLoadingImplCopyWithImpl(
    _$RecommendationsLoadingImpl _value,
    $Res Function(_$RecommendationsLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RecommendationsLoadingImpl implements RecommendationsLoading {
  const _$RecommendationsLoadingImpl();

  @override
  String toString() {
    return 'RecommendationsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RecommendationEntity> items) loaded,
    required TResult Function(String message, bool needsKey) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RecommendationEntity> items)? loaded,
    TResult? Function(String message, bool needsKey)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RecommendationEntity> items)? loaded,
    TResult Function(String message, bool needsKey)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendationsInitial value) initial,
    required TResult Function(RecommendationsLoading value) loading,
    required TResult Function(RecommendationsLoaded value) loaded,
    required TResult Function(RecommendationsError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecommendationsInitial value)? initial,
    TResult? Function(RecommendationsLoading value)? loading,
    TResult? Function(RecommendationsLoaded value)? loaded,
    TResult? Function(RecommendationsError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecommendationsInitial value)? initial,
    TResult Function(RecommendationsLoading value)? loading,
    TResult Function(RecommendationsLoaded value)? loaded,
    TResult Function(RecommendationsError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class RecommendationsLoading implements RecommendationsState {
  const factory RecommendationsLoading() = _$RecommendationsLoadingImpl;
}

/// @nodoc
abstract class _$$RecommendationsLoadedImplCopyWith<$Res> {
  factory _$$RecommendationsLoadedImplCopyWith(
    _$RecommendationsLoadedImpl value,
    $Res Function(_$RecommendationsLoadedImpl) then,
  ) = __$$RecommendationsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<RecommendationEntity> items});
}

/// @nodoc
class __$$RecommendationsLoadedImplCopyWithImpl<$Res>
    extends
        _$RecommendationsStateCopyWithImpl<$Res, _$RecommendationsLoadedImpl>
    implements _$$RecommendationsLoadedImplCopyWith<$Res> {
  __$$RecommendationsLoadedImplCopyWithImpl(
    _$RecommendationsLoadedImpl _value,
    $Res Function(_$RecommendationsLoadedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? items = null}) {
    return _then(
      _$RecommendationsLoadedImpl(
        null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                as List<RecommendationEntity>,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationsLoadedImpl implements RecommendationsLoaded {
  const _$RecommendationsLoadedImpl(final List<RecommendationEntity> items)
    : _items = items;

  final List<RecommendationEntity> _items;
  @override
  List<RecommendationEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'RecommendationsState.loaded(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationsLoadedImplCopyWith<_$RecommendationsLoadedImpl>
  get copyWith =>
      __$$RecommendationsLoadedImplCopyWithImpl<_$RecommendationsLoadedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RecommendationEntity> items) loaded,
    required TResult Function(String message, bool needsKey) error,
  }) {
    return loaded(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RecommendationEntity> items)? loaded,
    TResult? Function(String message, bool needsKey)? error,
  }) {
    return loaded?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RecommendationEntity> items)? loaded,
    TResult Function(String message, bool needsKey)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendationsInitial value) initial,
    required TResult Function(RecommendationsLoading value) loading,
    required TResult Function(RecommendationsLoaded value) loaded,
    required TResult Function(RecommendationsError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecommendationsInitial value)? initial,
    TResult? Function(RecommendationsLoading value)? loading,
    TResult? Function(RecommendationsLoaded value)? loaded,
    TResult? Function(RecommendationsError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecommendationsInitial value)? initial,
    TResult Function(RecommendationsLoading value)? loading,
    TResult Function(RecommendationsLoaded value)? loaded,
    TResult Function(RecommendationsError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class RecommendationsLoaded implements RecommendationsState {
  const factory RecommendationsLoaded(final List<RecommendationEntity> items) =
      _$RecommendationsLoadedImpl;

  List<RecommendationEntity> get items;

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationsLoadedImplCopyWith<_$RecommendationsLoadedImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RecommendationsErrorImplCopyWith<$Res> {
  factory _$$RecommendationsErrorImplCopyWith(
    _$RecommendationsErrorImpl value,
    $Res Function(_$RecommendationsErrorImpl) then,
  ) = __$$RecommendationsErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool needsKey});
}

/// @nodoc
class __$$RecommendationsErrorImplCopyWithImpl<$Res>
    extends _$RecommendationsStateCopyWithImpl<$Res, _$RecommendationsErrorImpl>
    implements _$$RecommendationsErrorImplCopyWith<$Res> {
  __$$RecommendationsErrorImplCopyWithImpl(
    _$RecommendationsErrorImpl _value,
    $Res Function(_$RecommendationsErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? needsKey = null}) {
    return _then(
      _$RecommendationsErrorImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        needsKey:
            null == needsKey
                ? _value.needsKey
                : needsKey // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$RecommendationsErrorImpl implements RecommendationsError {
  const _$RecommendationsErrorImpl({
    required this.message,
    this.needsKey = false,
  });

  @override
  final String message;
  @override
  @JsonKey()
  final bool needsKey;

  @override
  String toString() {
    return 'RecommendationsState.error(message: $message, needsKey: $needsKey)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationsErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.needsKey, needsKey) ||
                other.needsKey == needsKey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, needsKey);

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationsErrorImplCopyWith<_$RecommendationsErrorImpl>
  get copyWith =>
      __$$RecommendationsErrorImplCopyWithImpl<_$RecommendationsErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<RecommendationEntity> items) loaded,
    required TResult Function(String message, bool needsKey) error,
  }) {
    return error(message, needsKey);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<RecommendationEntity> items)? loaded,
    TResult? Function(String message, bool needsKey)? error,
  }) {
    return error?.call(message, needsKey);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<RecommendationEntity> items)? loaded,
    TResult Function(String message, bool needsKey)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, needsKey);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendationsInitial value) initial,
    required TResult Function(RecommendationsLoading value) loading,
    required TResult Function(RecommendationsLoaded value) loaded,
    required TResult Function(RecommendationsError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(RecommendationsInitial value)? initial,
    TResult? Function(RecommendationsLoading value)? loading,
    TResult? Function(RecommendationsLoaded value)? loaded,
    TResult? Function(RecommendationsError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(RecommendationsInitial value)? initial,
    TResult Function(RecommendationsLoading value)? loading,
    TResult Function(RecommendationsLoaded value)? loaded,
    TResult Function(RecommendationsError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class RecommendationsError implements RecommendationsState {
  const factory RecommendationsError({
    required final String message,
    final bool needsKey,
  }) = _$RecommendationsErrorImpl;

  String get message;
  bool get needsKey;

  /// Create a copy of RecommendationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationsErrorImplCopyWith<_$RecommendationsErrorImpl>
  get copyWith => throw _privateConstructorUsedError;
}

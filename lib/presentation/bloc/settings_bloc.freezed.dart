// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SettingsEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(String key) saveKey,
    required TResult Function() clearKey,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(String key)? saveKey,
    TResult? Function()? clearKey,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(String key)? saveKey,
    TResult Function()? clearKey,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) load,
    required TResult Function(SaveKey value) saveKey,
    required TResult Function(ClearKey value) clearKey,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? load,
    TResult? Function(SaveKey value)? saveKey,
    TResult? Function(ClearKey value)? clearKey,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? load,
    TResult Function(SaveKey value)? saveKey,
    TResult Function(ClearKey value)? clearKey,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsEventCopyWith<$Res> {
  factory $SettingsEventCopyWith(
    SettingsEvent value,
    $Res Function(SettingsEvent) then,
  ) = _$SettingsEventCopyWithImpl<$Res, SettingsEvent>;
}

/// @nodoc
class _$SettingsEventCopyWithImpl<$Res, $Val extends SettingsEvent>
    implements $SettingsEventCopyWith<$Res> {
  _$SettingsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LoadSettingsImplCopyWith<$Res> {
  factory _$$LoadSettingsImplCopyWith(
    _$LoadSettingsImpl value,
    $Res Function(_$LoadSettingsImpl) then,
  ) = __$$LoadSettingsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadSettingsImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$LoadSettingsImpl>
    implements _$$LoadSettingsImplCopyWith<$Res> {
  __$$LoadSettingsImplCopyWithImpl(
    _$LoadSettingsImpl _value,
    $Res Function(_$LoadSettingsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadSettingsImpl implements LoadSettings {
  const _$LoadSettingsImpl();

  @override
  String toString() {
    return 'SettingsEvent.load()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadSettingsImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(String key) saveKey,
    required TResult Function() clearKey,
  }) {
    return load();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(String key)? saveKey,
    TResult? Function()? clearKey,
  }) {
    return load?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(String key)? saveKey,
    TResult Function()? clearKey,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) load,
    required TResult Function(SaveKey value) saveKey,
    required TResult Function(ClearKey value) clearKey,
  }) {
    return load(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? load,
    TResult? Function(SaveKey value)? saveKey,
    TResult? Function(ClearKey value)? clearKey,
  }) {
    return load?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? load,
    TResult Function(SaveKey value)? saveKey,
    TResult Function(ClearKey value)? clearKey,
    required TResult orElse(),
  }) {
    if (load != null) {
      return load(this);
    }
    return orElse();
  }
}

abstract class LoadSettings implements SettingsEvent {
  const factory LoadSettings() = _$LoadSettingsImpl;
}

/// @nodoc
abstract class _$$SaveKeyImplCopyWith<$Res> {
  factory _$$SaveKeyImplCopyWith(
    _$SaveKeyImpl value,
    $Res Function(_$SaveKeyImpl) then,
  ) = __$$SaveKeyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String key});
}

/// @nodoc
class __$$SaveKeyImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$SaveKeyImpl>
    implements _$$SaveKeyImplCopyWith<$Res> {
  __$$SaveKeyImplCopyWithImpl(
    _$SaveKeyImpl _value,
    $Res Function(_$SaveKeyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? key = null}) {
    return _then(
      _$SaveKeyImpl(
        null == key
            ? _value.key
            : key // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$SaveKeyImpl implements SaveKey {
  const _$SaveKeyImpl(this.key);

  @override
  final String key;

  @override
  String toString() {
    return 'SettingsEvent.saveKey(key: $key)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SaveKeyImpl &&
            (identical(other.key, key) || other.key == key));
  }

  @override
  int get hashCode => Object.hash(runtimeType, key);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SaveKeyImplCopyWith<_$SaveKeyImpl> get copyWith =>
      __$$SaveKeyImplCopyWithImpl<_$SaveKeyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(String key) saveKey,
    required TResult Function() clearKey,
  }) {
    return saveKey(key);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(String key)? saveKey,
    TResult? Function()? clearKey,
  }) {
    return saveKey?.call(key);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(String key)? saveKey,
    TResult Function()? clearKey,
    required TResult orElse(),
  }) {
    if (saveKey != null) {
      return saveKey(key);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) load,
    required TResult Function(SaveKey value) saveKey,
    required TResult Function(ClearKey value) clearKey,
  }) {
    return saveKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? load,
    TResult? Function(SaveKey value)? saveKey,
    TResult? Function(ClearKey value)? clearKey,
  }) {
    return saveKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? load,
    TResult Function(SaveKey value)? saveKey,
    TResult Function(ClearKey value)? clearKey,
    required TResult orElse(),
  }) {
    if (saveKey != null) {
      return saveKey(this);
    }
    return orElse();
  }
}

abstract class SaveKey implements SettingsEvent {
  const factory SaveKey(final String key) = _$SaveKeyImpl;

  String get key;

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SaveKeyImplCopyWith<_$SaveKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearKeyImplCopyWith<$Res> {
  factory _$$ClearKeyImplCopyWith(
    _$ClearKeyImpl value,
    $Res Function(_$ClearKeyImpl) then,
  ) = __$$ClearKeyImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearKeyImplCopyWithImpl<$Res>
    extends _$SettingsEventCopyWithImpl<$Res, _$ClearKeyImpl>
    implements _$$ClearKeyImplCopyWith<$Res> {
  __$$ClearKeyImplCopyWithImpl(
    _$ClearKeyImpl _value,
    $Res Function(_$ClearKeyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ClearKeyImpl implements ClearKey {
  const _$ClearKeyImpl();

  @override
  String toString() {
    return 'SettingsEvent.clearKey()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearKeyImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() load,
    required TResult Function(String key) saveKey,
    required TResult Function() clearKey,
  }) {
    return clearKey();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? load,
    TResult? Function(String key)? saveKey,
    TResult? Function()? clearKey,
  }) {
    return clearKey?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? load,
    TResult Function(String key)? saveKey,
    TResult Function()? clearKey,
    required TResult orElse(),
  }) {
    if (clearKey != null) {
      return clearKey();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoadSettings value) load,
    required TResult Function(SaveKey value) saveKey,
    required TResult Function(ClearKey value) clearKey,
  }) {
    return clearKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoadSettings value)? load,
    TResult? Function(SaveKey value)? saveKey,
    TResult? Function(ClearKey value)? clearKey,
  }) {
    return clearKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoadSettings value)? load,
    TResult Function(SaveKey value)? saveKey,
    TResult Function(ClearKey value)? clearKey,
    required TResult orElse(),
  }) {
    if (clearKey != null) {
      return clearKey(this);
    }
    return orElse();
  }
}

abstract class ClearKey implements SettingsEvent {
  const factory ClearKey() = _$ClearKeyImpl;
}

/// @nodoc
mixin _$SettingsState {
  bool get hasKey => throw _privateConstructorUsedError;
  bool get busy => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateCopyWith<SettingsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateCopyWith<$Res> {
  factory $SettingsStateCopyWith(
    SettingsState value,
    $Res Function(SettingsState) then,
  ) = _$SettingsStateCopyWithImpl<$Res, SettingsState>;
  @useResult
  $Res call({bool hasKey, bool busy, String? message});
}

/// @nodoc
class _$SettingsStateCopyWithImpl<$Res, $Val extends SettingsState>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasKey = null,
    Object? busy = null,
    Object? message = freezed,
  }) {
    return _then(
      _value.copyWith(
            hasKey:
                null == hasKey
                    ? _value.hasKey
                    : hasKey // ignore: cast_nullable_to_non_nullable
                        as bool,
            busy:
                null == busy
                    ? _value.busy
                    : busy // ignore: cast_nullable_to_non_nullable
                        as bool,
            message:
                freezed == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SettingsStateImplCopyWith<$Res>
    implements $SettingsStateCopyWith<$Res> {
  factory _$$SettingsStateImplCopyWith(
    _$SettingsStateImpl value,
    $Res Function(_$SettingsStateImpl) then,
  ) = __$$SettingsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasKey, bool busy, String? message});
}

/// @nodoc
class __$$SettingsStateImplCopyWithImpl<$Res>
    extends _$SettingsStateCopyWithImpl<$Res, _$SettingsStateImpl>
    implements _$$SettingsStateImplCopyWith<$Res> {
  __$$SettingsStateImplCopyWithImpl(
    _$SettingsStateImpl _value,
    $Res Function(_$SettingsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasKey = null,
    Object? busy = null,
    Object? message = freezed,
  }) {
    return _then(
      _$SettingsStateImpl(
        hasKey:
            null == hasKey
                ? _value.hasKey
                : hasKey // ignore: cast_nullable_to_non_nullable
                    as bool,
        busy:
            null == busy
                ? _value.busy
                : busy // ignore: cast_nullable_to_non_nullable
                    as bool,
        message:
            freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$SettingsStateImpl implements _SettingsState {
  const _$SettingsStateImpl({
    this.hasKey = false,
    this.busy = false,
    this.message,
  });

  @override
  @JsonKey()
  final bool hasKey;
  @override
  @JsonKey()
  final bool busy;
  @override
  final String? message;

  @override
  String toString() {
    return 'SettingsState(hasKey: $hasKey, busy: $busy, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateImpl &&
            (identical(other.hasKey, hasKey) || other.hasKey == hasKey) &&
            (identical(other.busy, busy) || other.busy == busy) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasKey, busy, message);

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      __$$SettingsStateImplCopyWithImpl<_$SettingsStateImpl>(this, _$identity);
}

abstract class _SettingsState implements SettingsState {
  const factory _SettingsState({
    final bool hasKey,
    final bool busy,
    final String? message,
  }) = _$SettingsStateImpl;

  @override
  bool get hasKey;
  @override
  bool get busy;
  @override
  String? get message;

  /// Create a copy of SettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateImplCopyWith<_$SettingsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

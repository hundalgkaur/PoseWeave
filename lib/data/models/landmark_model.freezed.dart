// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'landmark_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

LandmarkModel _$LandmarkModelFromJson(Map<String, dynamic> json) {
  return _LandmarkModel.fromJson(json);
}

/// @nodoc
mixin _$LandmarkModel {
  PoseLandmarkType get type => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  double? get z => throw _privateConstructorUsedError;

  /// Serializes this LandmarkModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LandmarkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LandmarkModelCopyWith<LandmarkModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LandmarkModelCopyWith<$Res> {
  factory $LandmarkModelCopyWith(
    LandmarkModel value,
    $Res Function(LandmarkModel) then,
  ) = _$LandmarkModelCopyWithImpl<$Res, LandmarkModel>;
  @useResult
  $Res call({
    PoseLandmarkType type,
    double x,
    double y,
    double confidence,
    double? z,
  });
}

/// @nodoc
class _$LandmarkModelCopyWithImpl<$Res, $Val extends LandmarkModel>
    implements $LandmarkModelCopyWith<$Res> {
  _$LandmarkModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LandmarkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? confidence = null,
    Object? z = freezed,
  }) {
    return _then(
      _value.copyWith(
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as PoseLandmarkType,
            x:
                null == x
                    ? _value.x
                    : x // ignore: cast_nullable_to_non_nullable
                        as double,
            y:
                null == y
                    ? _value.y
                    : y // ignore: cast_nullable_to_non_nullable
                        as double,
            confidence:
                null == confidence
                    ? _value.confidence
                    : confidence // ignore: cast_nullable_to_non_nullable
                        as double,
            z:
                freezed == z
                    ? _value.z
                    : z // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LandmarkModelImplCopyWith<$Res>
    implements $LandmarkModelCopyWith<$Res> {
  factory _$$LandmarkModelImplCopyWith(
    _$LandmarkModelImpl value,
    $Res Function(_$LandmarkModelImpl) then,
  ) = __$$LandmarkModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    PoseLandmarkType type,
    double x,
    double y,
    double confidence,
    double? z,
  });
}

/// @nodoc
class __$$LandmarkModelImplCopyWithImpl<$Res>
    extends _$LandmarkModelCopyWithImpl<$Res, _$LandmarkModelImpl>
    implements _$$LandmarkModelImplCopyWith<$Res> {
  __$$LandmarkModelImplCopyWithImpl(
    _$LandmarkModelImpl _value,
    $Res Function(_$LandmarkModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LandmarkModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? x = null,
    Object? y = null,
    Object? confidence = null,
    Object? z = freezed,
  }) {
    return _then(
      _$LandmarkModelImpl(
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as PoseLandmarkType,
        x:
            null == x
                ? _value.x
                : x // ignore: cast_nullable_to_non_nullable
                    as double,
        y:
            null == y
                ? _value.y
                : y // ignore: cast_nullable_to_non_nullable
                    as double,
        confidence:
            null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                    as double,
        z:
            freezed == z
                ? _value.z
                : z // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LandmarkModelImpl extends _LandmarkModel {
  const _$LandmarkModelImpl({
    required this.type,
    required this.x,
    required this.y,
    required this.confidence,
    this.z,
  }) : super._();

  factory _$LandmarkModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LandmarkModelImplFromJson(json);

  @override
  final PoseLandmarkType type;
  @override
  final double x;
  @override
  final double y;
  @override
  final double confidence;
  @override
  final double? z;

  @override
  String toString() {
    return 'LandmarkModel(type: $type, x: $x, y: $y, confidence: $confidence, z: $z)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LandmarkModelImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.z, z) || other.z == z));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, x, y, confidence, z);

  /// Create a copy of LandmarkModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LandmarkModelImplCopyWith<_$LandmarkModelImpl> get copyWith =>
      __$$LandmarkModelImplCopyWithImpl<_$LandmarkModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LandmarkModelImplToJson(this);
  }
}

abstract class _LandmarkModel extends LandmarkModel {
  const factory _LandmarkModel({
    required final PoseLandmarkType type,
    required final double x,
    required final double y,
    required final double confidence,
    final double? z,
  }) = _$LandmarkModelImpl;
  const _LandmarkModel._() : super._();

  factory _LandmarkModel.fromJson(Map<String, dynamic> json) =
      _$LandmarkModelImpl.fromJson;

  @override
  PoseLandmarkType get type;
  @override
  double get x;
  @override
  double get y;
  @override
  double get confidence;
  @override
  double? get z;

  /// Create a copy of LandmarkModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LandmarkModelImplCopyWith<_$LandmarkModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

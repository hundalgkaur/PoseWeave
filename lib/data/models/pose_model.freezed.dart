// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pose_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PoseModel _$PoseModelFromJson(Map<String, dynamic> json) {
  return _PoseModel.fromJson(json);
}

/// @nodoc
mixin _$PoseModel {
  List<LandmarkModel> get landmarks => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  PoseSource get source => throw _privateConstructorUsedError;
  double? get imageWidth => throw _privateConstructorUsedError;
  double? get imageHeight => throw _privateConstructorUsedError;

  /// Serializes this PoseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoseModelCopyWith<PoseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseModelCopyWith<$Res> {
  factory $PoseModelCopyWith(PoseModel value, $Res Function(PoseModel) then) =
      _$PoseModelCopyWithImpl<$Res, PoseModel>;
  @useResult
  $Res call({
    List<LandmarkModel> landmarks,
    DateTime timestamp,
    PoseSource source,
    double? imageWidth,
    double? imageHeight,
  });
}

/// @nodoc
class _$PoseModelCopyWithImpl<$Res, $Val extends PoseModel>
    implements $PoseModelCopyWith<$Res> {
  _$PoseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? landmarks = null,
    Object? timestamp = null,
    Object? source = null,
    Object? imageWidth = freezed,
    Object? imageHeight = freezed,
  }) {
    return _then(
      _value.copyWith(
            landmarks:
                null == landmarks
                    ? _value.landmarks
                    : landmarks // ignore: cast_nullable_to_non_nullable
                        as List<LandmarkModel>,
            timestamp:
                null == timestamp
                    ? _value.timestamp
                    : timestamp // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            source:
                null == source
                    ? _value.source
                    : source // ignore: cast_nullable_to_non_nullable
                        as PoseSource,
            imageWidth:
                freezed == imageWidth
                    ? _value.imageWidth
                    : imageWidth // ignore: cast_nullable_to_non_nullable
                        as double?,
            imageHeight:
                freezed == imageHeight
                    ? _value.imageHeight
                    : imageHeight // ignore: cast_nullable_to_non_nullable
                        as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoseModelImplCopyWith<$Res>
    implements $PoseModelCopyWith<$Res> {
  factory _$$PoseModelImplCopyWith(
    _$PoseModelImpl value,
    $Res Function(_$PoseModelImpl) then,
  ) = __$$PoseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<LandmarkModel> landmarks,
    DateTime timestamp,
    PoseSource source,
    double? imageWidth,
    double? imageHeight,
  });
}

/// @nodoc
class __$$PoseModelImplCopyWithImpl<$Res>
    extends _$PoseModelCopyWithImpl<$Res, _$PoseModelImpl>
    implements _$$PoseModelImplCopyWith<$Res> {
  __$$PoseModelImplCopyWithImpl(
    _$PoseModelImpl _value,
    $Res Function(_$PoseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? landmarks = null,
    Object? timestamp = null,
    Object? source = null,
    Object? imageWidth = freezed,
    Object? imageHeight = freezed,
  }) {
    return _then(
      _$PoseModelImpl(
        landmarks:
            null == landmarks
                ? _value._landmarks
                : landmarks // ignore: cast_nullable_to_non_nullable
                    as List<LandmarkModel>,
        timestamp:
            null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        source:
            null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                    as PoseSource,
        imageWidth:
            freezed == imageWidth
                ? _value.imageWidth
                : imageWidth // ignore: cast_nullable_to_non_nullable
                    as double?,
        imageHeight:
            freezed == imageHeight
                ? _value.imageHeight
                : imageHeight // ignore: cast_nullable_to_non_nullable
                    as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoseModelImpl extends _PoseModel {
  const _$PoseModelImpl({
    required final List<LandmarkModel> landmarks,
    required this.timestamp,
    required this.source,
    this.imageWidth,
    this.imageHeight,
  }) : _landmarks = landmarks,
       super._();

  factory _$PoseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoseModelImplFromJson(json);

  final List<LandmarkModel> _landmarks;
  @override
  List<LandmarkModel> get landmarks {
    if (_landmarks is EqualUnmodifiableListView) return _landmarks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_landmarks);
  }

  @override
  final DateTime timestamp;
  @override
  final PoseSource source;
  @override
  final double? imageWidth;
  @override
  final double? imageHeight;

  @override
  String toString() {
    return 'PoseModel(landmarks: $landmarks, timestamp: $timestamp, source: $source, imageWidth: $imageWidth, imageHeight: $imageHeight)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseModelImpl &&
            const DeepCollectionEquality().equals(
              other._landmarks,
              _landmarks,
            ) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.imageWidth, imageWidth) ||
                other.imageWidth == imageWidth) &&
            (identical(other.imageHeight, imageHeight) ||
                other.imageHeight == imageHeight));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_landmarks),
    timestamp,
    source,
    imageWidth,
    imageHeight,
  );

  /// Create a copy of PoseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseModelImplCopyWith<_$PoseModelImpl> get copyWith =>
      __$$PoseModelImplCopyWithImpl<_$PoseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoseModelImplToJson(this);
  }
}

abstract class _PoseModel extends PoseModel {
  const factory _PoseModel({
    required final List<LandmarkModel> landmarks,
    required final DateTime timestamp,
    required final PoseSource source,
    final double? imageWidth,
    final double? imageHeight,
  }) = _$PoseModelImpl;
  const _PoseModel._() : super._();

  factory _PoseModel.fromJson(Map<String, dynamic> json) =
      _$PoseModelImpl.fromJson;

  @override
  List<LandmarkModel> get landmarks;
  @override
  DateTime get timestamp;
  @override
  PoseSource get source;
  @override
  double? get imageWidth;
  @override
  double? get imageHeight;

  /// Create a copy of PoseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseModelImplCopyWith<_$PoseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

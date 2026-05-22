// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoseModelImpl _$$PoseModelImplFromJson(Map<String, dynamic> json) =>
    _$PoseModelImpl(
      landmarks:
          (json['landmarks'] as List<dynamic>)
              .map((e) => LandmarkModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: $enumDecode(_$PoseSourceEnumMap, json['source']),
      imageWidth: (json['imageWidth'] as num?)?.toDouble(),
      imageHeight: (json['imageHeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$PoseModelImplToJson(_$PoseModelImpl instance) =>
    <String, dynamic>{
      'landmarks': instance.landmarks.map((e) => e.toJson()).toList(),
      'timestamp': instance.timestamp.toIso8601String(),
      'source': _$PoseSourceEnumMap[instance.source]!,
      'imageWidth': instance.imageWidth,
      'imageHeight': instance.imageHeight,
    };

const _$PoseSourceEnumMap = {
  PoseSource.camera: 'camera',
  PoseSource.videoFile: 'videoFile',
  PoseSource.mock: 'mock',
};

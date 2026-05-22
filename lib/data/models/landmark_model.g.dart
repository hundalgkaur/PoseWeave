// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'landmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LandmarkModelImpl _$$LandmarkModelImplFromJson(Map<String, dynamic> json) =>
    _$LandmarkModelImpl(
      type: $enumDecode(_$PoseLandmarkTypeEnumMap, json['type']),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      z: (json['z'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$LandmarkModelImplToJson(_$LandmarkModelImpl instance) =>
    <String, dynamic>{
      'type': _$PoseLandmarkTypeEnumMap[instance.type]!,
      'x': instance.x,
      'y': instance.y,
      'confidence': instance.confidence,
      'z': instance.z,
    };

const _$PoseLandmarkTypeEnumMap = {
  PoseLandmarkType.nose: 'nose',
  PoseLandmarkType.leftEyeInner: 'leftEyeInner',
  PoseLandmarkType.leftEye: 'leftEye',
  PoseLandmarkType.leftEyeOuter: 'leftEyeOuter',
  PoseLandmarkType.rightEyeInner: 'rightEyeInner',
  PoseLandmarkType.rightEye: 'rightEye',
  PoseLandmarkType.rightEyeOuter: 'rightEyeOuter',
  PoseLandmarkType.leftEar: 'leftEar',
  PoseLandmarkType.rightEar: 'rightEar',
  PoseLandmarkType.leftMouth: 'leftMouth',
  PoseLandmarkType.rightMouth: 'rightMouth',
  PoseLandmarkType.leftShoulder: 'leftShoulder',
  PoseLandmarkType.rightShoulder: 'rightShoulder',
  PoseLandmarkType.leftElbow: 'leftElbow',
  PoseLandmarkType.rightElbow: 'rightElbow',
  PoseLandmarkType.leftWrist: 'leftWrist',
  PoseLandmarkType.rightWrist: 'rightWrist',
  PoseLandmarkType.leftPinky: 'leftPinky',
  PoseLandmarkType.rightPinky: 'rightPinky',
  PoseLandmarkType.leftIndex: 'leftIndex',
  PoseLandmarkType.rightIndex: 'rightIndex',
  PoseLandmarkType.leftThumb: 'leftThumb',
  PoseLandmarkType.rightThumb: 'rightThumb',
  PoseLandmarkType.leftHip: 'leftHip',
  PoseLandmarkType.rightHip: 'rightHip',
  PoseLandmarkType.leftKnee: 'leftKnee',
  PoseLandmarkType.rightKnee: 'rightKnee',
  PoseLandmarkType.leftAnkle: 'leftAnkle',
  PoseLandmarkType.rightAnkle: 'rightAnkle',
  PoseLandmarkType.leftHeel: 'leftHeel',
  PoseLandmarkType.rightHeel: 'rightHeel',
  PoseLandmarkType.leftFootIndex: 'leftFootIndex',
  PoseLandmarkType.rightFootIndex: 'rightFootIndex',
};

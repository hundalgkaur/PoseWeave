// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PoseState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseStateCopyWith<$Res> {
  factory $PoseStateCopyWith(PoseState value, $Res Function(PoseState) then) =
      _$PoseStateCopyWithImpl<$Res, PoseState>;
}

/// @nodoc
class _$PoseStateCopyWithImpl<$Res, $Val extends PoseState>
    implements $PoseStateCopyWith<$Res> {
  _$PoseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PoseInitialImplCopyWith<$Res> {
  factory _$$PoseInitialImplCopyWith(
    _$PoseInitialImpl value,
    $Res Function(_$PoseInitialImpl) then,
  ) = __$$PoseInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseInitialImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseInitialImpl>
    implements _$$PoseInitialImplCopyWith<$Res> {
  __$$PoseInitialImplCopyWithImpl(
    _$PoseInitialImpl _value,
    $Res Function(_$PoseInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseInitialImpl implements PoseInitial {
  const _$PoseInitialImpl();

  @override
  String toString() {
    return 'PoseState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
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
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PoseInitial implements PoseState {
  const factory PoseInitial() = _$PoseInitialImpl;
}

/// @nodoc
abstract class _$$PoseLoadingImplCopyWith<$Res> {
  factory _$$PoseLoadingImplCopyWith(
    _$PoseLoadingImpl value,
    $Res Function(_$PoseLoadingImpl) then,
  ) = __$$PoseLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseLoadingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseLoadingImpl>
    implements _$$PoseLoadingImplCopyWith<$Res> {
  __$$PoseLoadingImplCopyWithImpl(
    _$PoseLoadingImpl _value,
    $Res Function(_$PoseLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseLoadingImpl implements PoseLoading {
  const _$PoseLoadingImpl();

  @override
  String toString() {
    return 'PoseState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
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
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PoseLoading implements PoseState {
  const factory PoseLoading() = _$PoseLoadingImpl;
}

/// @nodoc
abstract class _$$PoseNoPermissionImplCopyWith<$Res> {
  factory _$$PoseNoPermissionImplCopyWith(
    _$PoseNoPermissionImpl value,
    $Res Function(_$PoseNoPermissionImpl) then,
  ) = __$$PoseNoPermissionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseNoPermissionImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseNoPermissionImpl>
    implements _$$PoseNoPermissionImplCopyWith<$Res> {
  __$$PoseNoPermissionImplCopyWithImpl(
    _$PoseNoPermissionImpl _value,
    $Res Function(_$PoseNoPermissionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseNoPermissionImpl implements PoseNoPermission {
  const _$PoseNoPermissionImpl();

  @override
  String toString() {
    return 'PoseState.noPermission()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseNoPermissionImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return noPermission();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return noPermission?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (noPermission != null) {
      return noPermission();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return noPermission(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return noPermission?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (noPermission != null) {
      return noPermission(this);
    }
    return orElse();
  }
}

abstract class PoseNoPermission implements PoseState {
  const factory PoseNoPermission() = _$PoseNoPermissionImpl;
}

/// @nodoc
abstract class _$$PoseStreamingImplCopyWith<$Res> {
  factory _$$PoseStreamingImplCopyWith(
    _$PoseStreamingImpl value,
    $Res Function(_$PoseStreamingImpl) then,
  ) = __$$PoseStreamingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseStreamingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseStreamingImpl>
    implements _$$PoseStreamingImplCopyWith<$Res> {
  __$$PoseStreamingImplCopyWithImpl(
    _$PoseStreamingImpl _value,
    $Res Function(_$PoseStreamingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseStreamingImpl implements PoseStreaming {
  const _$PoseStreamingImpl();

  @override
  String toString() {
    return 'PoseState.streaming()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseStreamingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return streaming();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return streaming?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (streaming != null) {
      return streaming();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return streaming(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return streaming?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (streaming != null) {
      return streaming(this);
    }
    return orElse();
  }
}

abstract class PoseStreaming implements PoseState {
  const factory PoseStreaming() = _$PoseStreamingImpl;
}

/// @nodoc
abstract class _$$PoseSearchingImplCopyWith<$Res> {
  factory _$$PoseSearchingImplCopyWith(
    _$PoseSearchingImpl value,
    $Res Function(_$PoseSearchingImpl) then,
  ) = __$$PoseSearchingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseSearchingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseSearchingImpl>
    implements _$$PoseSearchingImplCopyWith<$Res> {
  __$$PoseSearchingImplCopyWithImpl(
    _$PoseSearchingImpl _value,
    $Res Function(_$PoseSearchingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseSearchingImpl implements PoseSearching {
  const _$PoseSearchingImpl();

  @override
  String toString() {
    return 'PoseState.searching()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseSearchingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return searching();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return searching?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (searching != null) {
      return searching();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return searching(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return searching?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (searching != null) {
      return searching(this);
    }
    return orElse();
  }
}

abstract class PoseSearching implements PoseState {
  const factory PoseSearching() = _$PoseSearchingImpl;
}

/// @nodoc
abstract class _$$PoseActiveImplCopyWith<$Res> {
  factory _$$PoseActiveImplCopyWith(
    _$PoseActiveImpl value,
    $Res Function(_$PoseActiveImpl) then,
  ) = __$$PoseActiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    PoseEntity pose,
    double averageConfidence,
    double fps,
    List<PoseEntity> allPoses,
  });
}

/// @nodoc
class __$$PoseActiveImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseActiveImpl>
    implements _$$PoseActiveImplCopyWith<$Res> {
  __$$PoseActiveImplCopyWithImpl(
    _$PoseActiveImpl _value,
    $Res Function(_$PoseActiveImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pose = null,
    Object? averageConfidence = null,
    Object? fps = null,
    Object? allPoses = null,
  }) {
    return _then(
      _$PoseActiveImpl(
        pose:
            null == pose
                ? _value.pose
                : pose // ignore: cast_nullable_to_non_nullable
                    as PoseEntity,
        averageConfidence:
            null == averageConfidence
                ? _value.averageConfidence
                : averageConfidence // ignore: cast_nullable_to_non_nullable
                    as double,
        fps:
            null == fps
                ? _value.fps
                : fps // ignore: cast_nullable_to_non_nullable
                    as double,
        allPoses:
            null == allPoses
                ? _value._allPoses
                : allPoses // ignore: cast_nullable_to_non_nullable
                    as List<PoseEntity>,
      ),
    );
  }
}

/// @nodoc

class _$PoseActiveImpl implements PoseActive {
  const _$PoseActiveImpl({
    required this.pose,
    required this.averageConfidence,
    required this.fps,
    final List<PoseEntity> allPoses = const <PoseEntity>[],
  }) : _allPoses = allPoses;

  @override
  final PoseEntity pose;
  @override
  final double averageConfidence;
  @override
  final double fps;
  // Everyone detected this frame (primary first) for drawing all skeletons +
  // a person count. [pose] remains the primary for single-person features.
  final List<PoseEntity> _allPoses;
  // Everyone detected this frame (primary first) for drawing all skeletons +
  // a person count. [pose] remains the primary for single-person features.
  @override
  @JsonKey()
  List<PoseEntity> get allPoses {
    if (_allPoses is EqualUnmodifiableListView) return _allPoses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allPoses);
  }

  @override
  String toString() {
    return 'PoseState.active(pose: $pose, averageConfidence: $averageConfidence, fps: $fps, allPoses: $allPoses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseActiveImpl &&
            (identical(other.pose, pose) || other.pose == pose) &&
            (identical(other.averageConfidence, averageConfidence) ||
                other.averageConfidence == averageConfidence) &&
            (identical(other.fps, fps) || other.fps == fps) &&
            const DeepCollectionEquality().equals(other._allPoses, _allPoses));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    pose,
    averageConfidence,
    fps,
    const DeepCollectionEquality().hash(_allPoses),
  );

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseActiveImplCopyWith<_$PoseActiveImpl> get copyWith =>
      __$$PoseActiveImplCopyWithImpl<_$PoseActiveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return active(pose, averageConfidence, fps, allPoses);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return active?.call(pose, averageConfidence, fps, allPoses);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(pose, averageConfidence, fps, allPoses);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class PoseActive implements PoseState {
  const factory PoseActive({
    required final PoseEntity pose,
    required final double averageConfidence,
    required final double fps,
    final List<PoseEntity> allPoses,
  }) = _$PoseActiveImpl;

  PoseEntity get pose;
  double get averageConfidence;
  double
  get fps; // Everyone detected this frame (primary first) for drawing all skeletons +
  // a person count. [pose] remains the primary for single-person features.
  List<PoseEntity> get allPoses;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseActiveImplCopyWith<_$PoseActiveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseRecordingVideoImplCopyWith<$Res> {
  factory _$$PoseRecordingVideoImplCopyWith(
    _$PoseRecordingVideoImpl value,
    $Res Function(_$PoseRecordingVideoImpl) then,
  ) = __$$PoseRecordingVideoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseRecordingVideoImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseRecordingVideoImpl>
    implements _$$PoseRecordingVideoImplCopyWith<$Res> {
  __$$PoseRecordingVideoImplCopyWithImpl(
    _$PoseRecordingVideoImpl _value,
    $Res Function(_$PoseRecordingVideoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseRecordingVideoImpl implements PoseRecordingVideo {
  const _$PoseRecordingVideoImpl();

  @override
  String toString() {
    return 'PoseState.recordingVideo()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PoseRecordingVideoImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return recordingVideo();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return recordingVideo?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (recordingVideo != null) {
      return recordingVideo();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return recordingVideo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return recordingVideo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (recordingVideo != null) {
      return recordingVideo(this);
    }
    return orElse();
  }
}

abstract class PoseRecordingVideo implements PoseState {
  const factory PoseRecordingVideo() = _$PoseRecordingVideoImpl;
}

/// @nodoc
abstract class _$$PoseVideoPickedImplCopyWith<$Res> {
  factory _$$PoseVideoPickedImplCopyWith(
    _$PoseVideoPickedImpl value,
    $Res Function(_$PoseVideoPickedImpl) then,
  ) = __$$PoseVideoPickedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String path});
}

/// @nodoc
class __$$PoseVideoPickedImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseVideoPickedImpl>
    implements _$$PoseVideoPickedImplCopyWith<$Res> {
  __$$PoseVideoPickedImplCopyWithImpl(
    _$PoseVideoPickedImpl _value,
    $Res Function(_$PoseVideoPickedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? path = null}) {
    return _then(
      _$PoseVideoPickedImpl(
        null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$PoseVideoPickedImpl implements PoseVideoPicked {
  const _$PoseVideoPickedImpl(this.path);

  @override
  final String path;

  @override
  String toString() {
    return 'PoseState.videoPicked(path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseVideoPickedImpl &&
            (identical(other.path, path) || other.path == path));
  }

  @override
  int get hashCode => Object.hash(runtimeType, path);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseVideoPickedImplCopyWith<_$PoseVideoPickedImpl> get copyWith =>
      __$$PoseVideoPickedImplCopyWithImpl<_$PoseVideoPickedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return videoPicked(path);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return videoPicked?.call(path);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (videoPicked != null) {
      return videoPicked(path);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return videoPicked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return videoPicked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (videoPicked != null) {
      return videoPicked(this);
    }
    return orElse();
  }
}

abstract class PoseVideoPicked implements PoseState {
  const factory PoseVideoPicked(final String path) = _$PoseVideoPickedImpl;

  String get path;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseVideoPickedImplCopyWith<_$PoseVideoPickedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseVideoProcessingImplCopyWith<$Res> {
  factory _$$PoseVideoProcessingImplCopyWith(
    _$PoseVideoProcessingImpl value,
    $Res Function(_$PoseVideoProcessingImpl) then,
  ) = __$$PoseVideoProcessingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double progress, int framesProcessed, PoseEntity? currentPose});
}

/// @nodoc
class __$$PoseVideoProcessingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseVideoProcessingImpl>
    implements _$$PoseVideoProcessingImplCopyWith<$Res> {
  __$$PoseVideoProcessingImplCopyWithImpl(
    _$PoseVideoProcessingImpl _value,
    $Res Function(_$PoseVideoProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? progress = null,
    Object? framesProcessed = null,
    Object? currentPose = freezed,
  }) {
    return _then(
      _$PoseVideoProcessingImpl(
        progress:
            null == progress
                ? _value.progress
                : progress // ignore: cast_nullable_to_non_nullable
                    as double,
        framesProcessed:
            null == framesProcessed
                ? _value.framesProcessed
                : framesProcessed // ignore: cast_nullable_to_non_nullable
                    as int,
        currentPose:
            freezed == currentPose
                ? _value.currentPose
                : currentPose // ignore: cast_nullable_to_non_nullable
                    as PoseEntity?,
      ),
    );
  }
}

/// @nodoc

class _$PoseVideoProcessingImpl implements PoseVideoProcessing {
  const _$PoseVideoProcessingImpl({
    required this.progress,
    required this.framesProcessed,
    this.currentPose,
  });

  @override
  final double progress;
  @override
  final int framesProcessed;
  @override
  final PoseEntity? currentPose;

  @override
  String toString() {
    return 'PoseState.videoProcessing(progress: $progress, framesProcessed: $framesProcessed, currentPose: $currentPose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseVideoProcessingImpl &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.framesProcessed, framesProcessed) ||
                other.framesProcessed == framesProcessed) &&
            (identical(other.currentPose, currentPose) ||
                other.currentPose == currentPose));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, progress, framesProcessed, currentPose);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseVideoProcessingImplCopyWith<_$PoseVideoProcessingImpl> get copyWith =>
      __$$PoseVideoProcessingImplCopyWithImpl<_$PoseVideoProcessingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return videoProcessing(progress, framesProcessed, currentPose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return videoProcessing?.call(progress, framesProcessed, currentPose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (videoProcessing != null) {
      return videoProcessing(progress, framesProcessed, currentPose);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return videoProcessing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return videoProcessing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (videoProcessing != null) {
      return videoProcessing(this);
    }
    return orElse();
  }
}

abstract class PoseVideoProcessing implements PoseState {
  const factory PoseVideoProcessing({
    required final double progress,
    required final int framesProcessed,
    final PoseEntity? currentPose,
  }) = _$PoseVideoProcessingImpl;

  double get progress;
  int get framesProcessed;
  PoseEntity? get currentPose;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseVideoProcessingImplCopyWith<_$PoseVideoProcessingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseVideoCompleteImplCopyWith<$Res> {
  factory _$$PoseVideoCompleteImplCopyWith(
    _$PoseVideoCompleteImpl value,
    $Res Function(_$PoseVideoCompleteImpl) then,
  ) = __$$PoseVideoCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({
    List<PoseEntity> poses,
    int frameCount,
    String? videoPath,
    List<String> framePaths,
  });
}

/// @nodoc
class __$$PoseVideoCompleteImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseVideoCompleteImpl>
    implements _$$PoseVideoCompleteImplCopyWith<$Res> {
  __$$PoseVideoCompleteImplCopyWithImpl(
    _$PoseVideoCompleteImpl _value,
    $Res Function(_$PoseVideoCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? poses = null,
    Object? frameCount = null,
    Object? videoPath = freezed,
    Object? framePaths = null,
  }) {
    return _then(
      _$PoseVideoCompleteImpl(
        poses:
            null == poses
                ? _value._poses
                : poses // ignore: cast_nullable_to_non_nullable
                    as List<PoseEntity>,
        frameCount:
            null == frameCount
                ? _value.frameCount
                : frameCount // ignore: cast_nullable_to_non_nullable
                    as int,
        videoPath:
            freezed == videoPath
                ? _value.videoPath
                : videoPath // ignore: cast_nullable_to_non_nullable
                    as String?,
        framePaths:
            null == framePaths
                ? _value._framePaths
                : framePaths // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc

class _$PoseVideoCompleteImpl implements PoseVideoComplete {
  const _$PoseVideoCompleteImpl({
    required final List<PoseEntity> poses,
    required this.frameCount,
    this.videoPath,
    final List<String> framePaths = const <String>[],
  }) : _poses = poses,
       _framePaths = framePaths;

  final List<PoseEntity> _poses;
  @override
  List<PoseEntity> get poses {
    if (_poses is EqualUnmodifiableListView) return _poses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_poses);
  }

  @override
  final int frameCount;
  @override
  final String? videoPath;
  final List<String> _framePaths;
  @override
  @JsonKey()
  List<String> get framePaths {
    if (_framePaths is EqualUnmodifiableListView) return _framePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_framePaths);
  }

  @override
  String toString() {
    return 'PoseState.videoComplete(poses: $poses, frameCount: $frameCount, videoPath: $videoPath, framePaths: $framePaths)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseVideoCompleteImpl &&
            const DeepCollectionEquality().equals(other._poses, _poses) &&
            (identical(other.frameCount, frameCount) ||
                other.frameCount == frameCount) &&
            (identical(other.videoPath, videoPath) ||
                other.videoPath == videoPath) &&
            const DeepCollectionEquality().equals(
              other._framePaths,
              _framePaths,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_poses),
    frameCount,
    videoPath,
    const DeepCollectionEquality().hash(_framePaths),
  );

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseVideoCompleteImplCopyWith<_$PoseVideoCompleteImpl> get copyWith =>
      __$$PoseVideoCompleteImplCopyWithImpl<_$PoseVideoCompleteImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return videoComplete(poses, frameCount, videoPath, framePaths);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return videoComplete?.call(poses, frameCount, videoPath, framePaths);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (videoComplete != null) {
      return videoComplete(poses, frameCount, videoPath, framePaths);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return videoComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return videoComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (videoComplete != null) {
      return videoComplete(this);
    }
    return orElse();
  }
}

abstract class PoseVideoComplete implements PoseState {
  const factory PoseVideoComplete({
    required final List<PoseEntity> poses,
    required final int frameCount,
    final String? videoPath,
    final List<String> framePaths,
  }) = _$PoseVideoCompleteImpl;

  List<PoseEntity> get poses;
  int get frameCount;
  String? get videoPath;
  List<String> get framePaths;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseVideoCompleteImplCopyWith<_$PoseVideoCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseImageProcessingImplCopyWith<$Res> {
  factory _$$PoseImageProcessingImplCopyWith(
    _$PoseImageProcessingImpl value,
    $Res Function(_$PoseImageProcessingImpl) then,
  ) = __$$PoseImageProcessingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseImageProcessingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseImageProcessingImpl>
    implements _$$PoseImageProcessingImplCopyWith<$Res> {
  __$$PoseImageProcessingImplCopyWithImpl(
    _$PoseImageProcessingImpl _value,
    $Res Function(_$PoseImageProcessingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseImageProcessingImpl implements PoseImageProcessing {
  const _$PoseImageProcessingImpl();

  @override
  String toString() {
    return 'PoseState.imageProcessing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseImageProcessingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return imageProcessing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return imageProcessing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (imageProcessing != null) {
      return imageProcessing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return imageProcessing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return imageProcessing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (imageProcessing != null) {
      return imageProcessing(this);
    }
    return orElse();
  }
}

abstract class PoseImageProcessing implements PoseState {
  const factory PoseImageProcessing() = _$PoseImageProcessingImpl;
}

/// @nodoc
abstract class _$$PoseImageCompleteImplCopyWith<$Res> {
  factory _$$PoseImageCompleteImplCopyWith(
    _$PoseImageCompleteImpl value,
    $Res Function(_$PoseImageCompleteImpl) then,
  ) = __$$PoseImageCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String imagePath, PoseEntity? pose});
}

/// @nodoc
class __$$PoseImageCompleteImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseImageCompleteImpl>
    implements _$$PoseImageCompleteImplCopyWith<$Res> {
  __$$PoseImageCompleteImplCopyWithImpl(
    _$PoseImageCompleteImpl _value,
    $Res Function(_$PoseImageCompleteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? imagePath = null, Object? pose = freezed}) {
    return _then(
      _$PoseImageCompleteImpl(
        imagePath:
            null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                    as String,
        pose:
            freezed == pose
                ? _value.pose
                : pose // ignore: cast_nullable_to_non_nullable
                    as PoseEntity?,
      ),
    );
  }
}

/// @nodoc

class _$PoseImageCompleteImpl implements PoseImageComplete {
  const _$PoseImageCompleteImpl({required this.imagePath, this.pose});

  @override
  final String imagePath;
  @override
  final PoseEntity? pose;

  @override
  String toString() {
    return 'PoseState.imageComplete(imagePath: $imagePath, pose: $pose)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseImageCompleteImpl &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.pose, pose) || other.pose == pose));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imagePath, pose);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseImageCompleteImplCopyWith<_$PoseImageCompleteImpl> get copyWith =>
      __$$PoseImageCompleteImplCopyWithImpl<_$PoseImageCompleteImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return imageComplete(imagePath, pose);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return imageComplete?.call(imagePath, pose);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (imageComplete != null) {
      return imageComplete(imagePath, pose);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return imageComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return imageComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (imageComplete != null) {
      return imageComplete(this);
    }
    return orElse();
  }
}

abstract class PoseImageComplete implements PoseState {
  const factory PoseImageComplete({
    required final String imagePath,
    final PoseEntity? pose,
  }) = _$PoseImageCompleteImpl;

  String get imagePath;
  PoseEntity? get pose;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseImageCompleteImplCopyWith<_$PoseImageCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseReportGeneratingImplCopyWith<$Res> {
  factory _$$PoseReportGeneratingImplCopyWith(
    _$PoseReportGeneratingImpl value,
    $Res Function(_$PoseReportGeneratingImpl) then,
  ) = __$$PoseReportGeneratingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PoseReportGeneratingImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseReportGeneratingImpl>
    implements _$$PoseReportGeneratingImplCopyWith<$Res> {
  __$$PoseReportGeneratingImplCopyWithImpl(
    _$PoseReportGeneratingImpl _value,
    $Res Function(_$PoseReportGeneratingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PoseReportGeneratingImpl implements PoseReportGenerating {
  const _$PoseReportGeneratingImpl();

  @override
  String toString() {
    return 'PoseState.reportGenerating()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseReportGeneratingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return reportGenerating();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return reportGenerating?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (reportGenerating != null) {
      return reportGenerating();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return reportGenerating(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return reportGenerating?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (reportGenerating != null) {
      return reportGenerating(this);
    }
    return orElse();
  }
}

abstract class PoseReportGenerating implements PoseState {
  const factory PoseReportGenerating() = _$PoseReportGeneratingImpl;
}

/// @nodoc
abstract class _$$PoseReportReadyImplCopyWith<$Res> {
  factory _$$PoseReportReadyImplCopyWith(
    _$PoseReportReadyImpl value,
    $Res Function(_$PoseReportReadyImpl) then,
  ) = __$$PoseReportReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filePath});
}

/// @nodoc
class __$$PoseReportReadyImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseReportReadyImpl>
    implements _$$PoseReportReadyImplCopyWith<$Res> {
  __$$PoseReportReadyImplCopyWithImpl(
    _$PoseReportReadyImpl _value,
    $Res Function(_$PoseReportReadyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filePath = null}) {
    return _then(
      _$PoseReportReadyImpl(
        filePath:
            null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$PoseReportReadyImpl implements PoseReportReady {
  const _$PoseReportReadyImpl({required this.filePath});

  @override
  final String filePath;

  @override
  String toString() {
    return 'PoseState.reportReady(filePath: $filePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseReportReadyImpl &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filePath);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseReportReadyImplCopyWith<_$PoseReportReadyImpl> get copyWith =>
      __$$PoseReportReadyImplCopyWithImpl<_$PoseReportReadyImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return reportReady(filePath);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return reportReady?.call(filePath);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (reportReady != null) {
      return reportReady(filePath);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return reportReady(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return reportReady?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (reportReady != null) {
      return reportReady(this);
    }
    return orElse();
  }
}

abstract class PoseReportReady implements PoseState {
  const factory PoseReportReady({required final String filePath}) =
      _$PoseReportReadyImpl;

  String get filePath;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseReportReadyImplCopyWith<_$PoseReportReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseReportFailedImplCopyWith<$Res> {
  factory _$$PoseReportFailedImplCopyWith(
    _$PoseReportFailedImpl value,
    $Res Function(_$PoseReportFailedImpl) then,
  ) = __$$PoseReportFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PoseReportFailedImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseReportFailedImpl>
    implements _$$PoseReportFailedImplCopyWith<$Res> {
  __$$PoseReportFailedImplCopyWithImpl(
    _$PoseReportFailedImpl _value,
    $Res Function(_$PoseReportFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PoseReportFailedImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc

class _$PoseReportFailedImpl implements PoseReportFailed {
  const _$PoseReportFailedImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'PoseState.reportFailed(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseReportFailedImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseReportFailedImplCopyWith<_$PoseReportFailedImpl> get copyWith =>
      __$$PoseReportFailedImplCopyWithImpl<_$PoseReportFailedImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return reportFailed(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return reportFailed?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (reportFailed != null) {
      return reportFailed(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return reportFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return reportFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (reportFailed != null) {
      return reportFailed(this);
    }
    return orElse();
  }
}

abstract class PoseReportFailed implements PoseState {
  const factory PoseReportFailed({required final String message}) =
      _$PoseReportFailedImpl;

  String get message;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseReportFailedImplCopyWith<_$PoseReportFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PoseErrorImplCopyWith<$Res> {
  factory _$$PoseErrorImplCopyWith(
    _$PoseErrorImpl value,
    $Res Function(_$PoseErrorImpl) then,
  ) = __$$PoseErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool isRecoverable});
}

/// @nodoc
class __$$PoseErrorImplCopyWithImpl<$Res>
    extends _$PoseStateCopyWithImpl<$Res, _$PoseErrorImpl>
    implements _$$PoseErrorImplCopyWith<$Res> {
  __$$PoseErrorImplCopyWithImpl(
    _$PoseErrorImpl _value,
    $Res Function(_$PoseErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null, Object? isRecoverable = null}) {
    return _then(
      _$PoseErrorImpl(
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
        isRecoverable:
            null == isRecoverable
                ? _value.isRecoverable
                : isRecoverable // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$PoseErrorImpl implements PoseError {
  const _$PoseErrorImpl({required this.message, required this.isRecoverable});

  @override
  final String message;
  @override
  final bool isRecoverable;

  @override
  String toString() {
    return 'PoseState.error(message: $message, isRecoverable: $isRecoverable)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.isRecoverable, isRecoverable) ||
                other.isRecoverable == isRecoverable));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, isRecoverable);

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseErrorImplCopyWith<_$PoseErrorImpl> get copyWith =>
      __$$PoseErrorImplCopyWithImpl<_$PoseErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function() noPermission,
    required TResult Function() streaming,
    required TResult Function() searching,
    required TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )
    active,
    required TResult Function() recordingVideo,
    required TResult Function(String path) videoPicked,
    required TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )
    videoProcessing,
    required TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )
    videoComplete,
    required TResult Function() imageProcessing,
    required TResult Function(String imagePath, PoseEntity? pose) imageComplete,
    required TResult Function() reportGenerating,
    required TResult Function(String filePath) reportReady,
    required TResult Function(String message) reportFailed,
    required TResult Function(String message, bool isRecoverable) error,
  }) {
    return error(message, isRecoverable);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function()? noPermission,
    TResult? Function()? streaming,
    TResult? Function()? searching,
    TResult? Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult? Function()? recordingVideo,
    TResult? Function(String path)? videoPicked,
    TResult? Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult? Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult? Function()? imageProcessing,
    TResult? Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult? Function()? reportGenerating,
    TResult? Function(String filePath)? reportReady,
    TResult? Function(String message)? reportFailed,
    TResult? Function(String message, bool isRecoverable)? error,
  }) {
    return error?.call(message, isRecoverable);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function()? noPermission,
    TResult Function()? streaming,
    TResult Function()? searching,
    TResult Function(
      PoseEntity pose,
      double averageConfidence,
      double fps,
      List<PoseEntity> allPoses,
    )?
    active,
    TResult Function()? recordingVideo,
    TResult Function(String path)? videoPicked,
    TResult Function(
      double progress,
      int framesProcessed,
      PoseEntity? currentPose,
    )?
    videoProcessing,
    TResult Function(
      List<PoseEntity> poses,
      int frameCount,
      String? videoPath,
      List<String> framePaths,
    )?
    videoComplete,
    TResult Function()? imageProcessing,
    TResult Function(String imagePath, PoseEntity? pose)? imageComplete,
    TResult Function()? reportGenerating,
    TResult Function(String filePath)? reportReady,
    TResult Function(String message)? reportFailed,
    TResult Function(String message, bool isRecoverable)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, isRecoverable);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PoseInitial value) initial,
    required TResult Function(PoseLoading value) loading,
    required TResult Function(PoseNoPermission value) noPermission,
    required TResult Function(PoseStreaming value) streaming,
    required TResult Function(PoseSearching value) searching,
    required TResult Function(PoseActive value) active,
    required TResult Function(PoseRecordingVideo value) recordingVideo,
    required TResult Function(PoseVideoPicked value) videoPicked,
    required TResult Function(PoseVideoProcessing value) videoProcessing,
    required TResult Function(PoseVideoComplete value) videoComplete,
    required TResult Function(PoseImageProcessing value) imageProcessing,
    required TResult Function(PoseImageComplete value) imageComplete,
    required TResult Function(PoseReportGenerating value) reportGenerating,
    required TResult Function(PoseReportReady value) reportReady,
    required TResult Function(PoseReportFailed value) reportFailed,
    required TResult Function(PoseError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PoseInitial value)? initial,
    TResult? Function(PoseLoading value)? loading,
    TResult? Function(PoseNoPermission value)? noPermission,
    TResult? Function(PoseStreaming value)? streaming,
    TResult? Function(PoseSearching value)? searching,
    TResult? Function(PoseActive value)? active,
    TResult? Function(PoseRecordingVideo value)? recordingVideo,
    TResult? Function(PoseVideoPicked value)? videoPicked,
    TResult? Function(PoseVideoProcessing value)? videoProcessing,
    TResult? Function(PoseVideoComplete value)? videoComplete,
    TResult? Function(PoseImageProcessing value)? imageProcessing,
    TResult? Function(PoseImageComplete value)? imageComplete,
    TResult? Function(PoseReportGenerating value)? reportGenerating,
    TResult? Function(PoseReportReady value)? reportReady,
    TResult? Function(PoseReportFailed value)? reportFailed,
    TResult? Function(PoseError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PoseInitial value)? initial,
    TResult Function(PoseLoading value)? loading,
    TResult Function(PoseNoPermission value)? noPermission,
    TResult Function(PoseStreaming value)? streaming,
    TResult Function(PoseSearching value)? searching,
    TResult Function(PoseActive value)? active,
    TResult Function(PoseRecordingVideo value)? recordingVideo,
    TResult Function(PoseVideoPicked value)? videoPicked,
    TResult Function(PoseVideoProcessing value)? videoProcessing,
    TResult Function(PoseVideoComplete value)? videoComplete,
    TResult Function(PoseImageProcessing value)? imageProcessing,
    TResult Function(PoseImageComplete value)? imageComplete,
    TResult Function(PoseReportGenerating value)? reportGenerating,
    TResult Function(PoseReportReady value)? reportReady,
    TResult Function(PoseReportFailed value)? reportFailed,
    TResult Function(PoseError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PoseError implements PoseState {
  const factory PoseError({
    required final String message,
    required final bool isRecoverable,
  }) = _$PoseErrorImpl;

  String get message;
  bool get isRecoverable;

  /// Create a copy of PoseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoseErrorImplCopyWith<_$PoseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

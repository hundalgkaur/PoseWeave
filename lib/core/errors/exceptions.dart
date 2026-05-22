/// Low-level exceptions thrown inside the data layer.
///
/// These are caught by `PoseRepositoryImpl` and converted into the matching
/// [Failure] types before crossing into the domain. Nothing above the data
/// layer should catch these directly.
library;

class CameraException implements Exception {
  const CameraException(this.message);
  final String message;
  @override
  String toString() => 'CameraException: $message';
}

class MLException implements Exception {
  const MLException(this.message);
  final String message;
  @override
  String toString() => 'MLException: $message';
}

class PermissionException implements Exception {
  const PermissionException(this.message);
  final String message;
  @override
  String toString() => 'PermissionException: $message';
}

class VideoException implements Exception {
  const VideoException(this.message);
  final String message;
  @override
  String toString() => 'VideoException: $message';
}

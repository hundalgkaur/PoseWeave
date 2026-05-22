import 'package:equatable/equatable.dart';

/// Base type for everything that can go wrong in a way the UI must handle.
///
/// Failures are the domain-facing counterpart of [Exception]s: datasources
/// throw exceptions, the repository catches them and returns a [Failure] via
/// `Either`, and the BLoC maps failures to error states. `isRecoverable`
/// lets the UI decide whether to offer a retry.
abstract class Failure extends Equatable {
  const Failure(this.message, {this.isRecoverable = true});

  final String message;
  final bool isRecoverable;

  @override
  List<Object?> get props => <Object?>[message, isRecoverable];
}

/// Camera hardware/initialization problems (unavailable, in use, etc.).
class CameraFailure extends Failure {
  const CameraFailure(super.message, {super.isRecoverable = true});
}

/// On-device ML Kit inference problems (model load, frame processing).
class MLFailure extends Failure {
  const MLFailure(super.message, {super.isRecoverable = true});
}

/// The user denied a required runtime permission.
class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.isRecoverable = true});
}

/// Video selection/decoding/frame-extraction problems.
class VideoFailure extends Failure {
  const VideoFailure(super.message, {super.isRecoverable = true});
}

/// Writing/serializing pose data for export failed.
class ExportFailure extends Failure {
  const ExportFailure(super.message, {super.isRecoverable = true});
}

/// Live diagnostics for the camera → ML Kit pipeline, surfaced on-device so we
/// can see why detection is (or isn't) producing poses without relying on USB
/// logcat. Plain value object — no camera/ML Kit types — so any layer can use it.
class CameraDiagnostics {
  const CameraDiagnostics({
    this.framesReceived = 0,
    this.framesSentToDetector = 0,
    this.posesFound = 0,
    this.lastFormatRaw,
    this.lastPlaneCount = 0,
    this.lastError,
  });

  /// Frames delivered by the camera image stream.
  final int framesReceived;

  /// Frames that converted to a valid [InputImage] and were sent to ML Kit.
  final int framesSentToDetector;

  /// Frames in which ML Kit found at least one pose.
  final int posesFound;

  /// Raw `image.format.raw` of the last frame (e.g. 35 = YUV_420_888, 17 = NV21).
  final int? lastFormatRaw;

  /// Plane count of the last frame (1 = packed NV21, 3 = YUV_420_888).
  final int lastPlaneCount;

  /// Last error from conversion/detection, if any.
  final String? lastError;

  /// Compact one-line summary for the debug HUD.
  String get summary =>
      'fmt:${lastFormatRaw ?? '-'} planes:$lastPlaneCount · '
      'recv:$framesReceived sent:$framesSentToDetector found:$posesFound · '
      'err:${lastError ?? '-'}';

  CameraDiagnostics copyWith({
    int? framesReceived,
    int? framesSentToDetector,
    int? posesFound,
    int? lastFormatRaw,
    int? lastPlaneCount,
    String? lastError,
  }) {
    return CameraDiagnostics(
      framesReceived: framesReceived ?? this.framesReceived,
      framesSentToDetector: framesSentToDetector ?? this.framesSentToDetector,
      posesFound: posesFound ?? this.posesFound,
      lastFormatRaw: lastFormatRaw ?? this.lastFormatRaw,
      lastPlaneCount: lastPlaneCount ?? this.lastPlaneCount,
      lastError: lastError ?? this.lastError,
    );
  }
}

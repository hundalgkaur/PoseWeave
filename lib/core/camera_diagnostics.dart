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
    this.lastConversionMs = 0,
    this.lastDetectorMs = 0,
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

  /// Wall-clock cost of the last YUV→NV21 conversion (ms). 0 until measured.
  final double lastConversionMs;

  /// Wall-clock cost of the last ML Kit `processImage` call (ms). 0 until
  /// measured. Together with [lastConversionMs] this is the per-frame budget on
  /// the UI isolate — the lever for deciding whether the throttle has headroom.
  final double lastDetectorMs;

  /// Compact one-line summary for the debug HUD.
  String get summary =>
      'fmt:${lastFormatRaw ?? '-'} planes:$lastPlaneCount · '
      'recv:$framesReceived sent:$framesSentToDetector found:$posesFound · '
      'conv:${lastConversionMs.toStringAsFixed(1)}ms '
      'det:${lastDetectorMs.toStringAsFixed(1)}ms · '
      'err:${lastError ?? '-'}';

  CameraDiagnostics copyWith({
    int? framesReceived,
    int? framesSentToDetector,
    int? posesFound,
    int? lastFormatRaw,
    int? lastPlaneCount,
    String? lastError,
    double? lastConversionMs,
    double? lastDetectorMs,
  }) {
    return CameraDiagnostics(
      framesReceived: framesReceived ?? this.framesReceived,
      framesSentToDetector: framesSentToDetector ?? this.framesSentToDetector,
      posesFound: posesFound ?? this.posesFound,
      lastFormatRaw: lastFormatRaw ?? this.lastFormatRaw,
      lastPlaneCount: lastPlaneCount ?? this.lastPlaneCount,
      lastError: lastError ?? this.lastError,
      lastConversionMs: lastConversionMs ?? this.lastConversionMs,
      lastDetectorMs: lastDetectorMs ?? this.lastDetectorMs,
    );
  }
}

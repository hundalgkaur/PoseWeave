import 'dart:async';
import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui';

import 'package:camera/camera.dart' hide CameraException;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show DeviceOrientation;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    hide PoseLandmarkType;
import 'package:injectable/injectable.dart';
import 'package:poseweave/core/camera_diagnostics.dart';
import 'package:poseweave/core/errors/exceptions.dart';
import 'package:poseweave/core/utils/one_euro_filter.dart';
import 'package:poseweave/core/utils/person_tracker.dart';
import 'package:poseweave/data/datasources/mlkit_camera_datasource.dart';
import 'package:poseweave/data/models/landmark_model.dart';
import 'package:poseweave/data/models/pose_model.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Minimum gap between processed frames (~33 FPS). `_isBusy` still drops any
/// frame the detector hasn't finished, so faster never queues up backpressure —
/// on a device that can't sustain 30 ms per frame, the effective rate just caps
/// at what the device can do.
const Duration _kFrameInterval = Duration(milliseconds: 30);

@LazySingleton(as: MLKitCameraDataSource)
class MLKitCameraDataSourceImpl implements MLKitCameraDataSource {
  CameraController? _controller;
  PoseDetector? _detector;
  List<CameraDescription> _cameras = <CameraDescription>[];
  CameraLensDirection _lensDirection = CameraLensDirection.back;

  // Not final: this datasource is a singleton reused across camera screens, so
  // after dispose() closes the controller it must be replaced with a fresh one
  // (a broadcast stream can't be reopened) or detection emits nothing on the
  // next screen.
  StreamController<PoseModel> _poseController =
      StreamController<PoseModel>.broadcast();

  bool _isBusy = false;
  bool _detecting = false;
  bool _mockMode = false;

  /// All people detected in the most recent frame (primary first). Used to draw
  /// every skeleton + show a person count, while the [poseStream] still carries
  /// only the primary for single-person features.
  List<PoseModel> _latestPoses = const <PoseModel>[];
  DateTime _lastProcessed = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _mockTimer;

  // On-device diagnostics for the debug HUD (see CameraDiagnostics).
  StreamController<CameraDiagnostics> _diagController =
      StreamController<CameraDiagnostics>.broadcast();
  CameraDiagnostics _diag = const CameraDiagnostics();
  DateTime _lastDiagEmit = DateTime.fromMillisecondsSinceEpoch(0);

  /// Adaptive (1€) smoothing per landmark axis. `beta` is high relative to the
  /// reference defaults because coordinates are **normalized** (0..1): per-frame
  /// speeds are tiny, so a small beta would never raise the cutoff and the
  /// filter would behave like a fixed low-pass (laggy on fast reps). A larger
  /// beta lets quick motion open the cutoff (low lag) while keeping heavy
  /// smoothing at rest (low jitter).
  final LandmarkOneEuro _euro = LandmarkOneEuro(minCutoff: 1.0, beta: 1.5);

  /// Smoothed per-landmark confidence (EMA). Smoothing the confidence stops
  /// single-frame likelihood noise from flickering a joint across the draw
  /// threshold — giving show/hide hysteresis without per-frame state in the
  /// (stateless) painter.
  final Map<int, double> _confEma = <int, double>{};
  static const double _kConfAlpha = 0.5;

  /// Landmarks below this (smoothed) confidence aren't fed into the filter (they
  /// 'd snap the point toward (0,0) and rubber-band the skeleton); we hold the
  /// last good geometry instead. Aligned with the painter draw threshold so we
  /// smooth exactly what we draw.
  static const double _kSmoothConfFloor = 0.3;

  /// Centroid of the previous frame's primary person, for stable tracking — so
  /// the "primary" pose doesn't swap between people across frames (ML Kit's
  /// pose-list order isn't guaranteed). Null until the first detection.
  PoseCentroid? _prevPrimaryCentroid;

  /// How far (normalized) the primary may move between frames and still be
  /// treated as the same person; beyond this we re-acquire.
  static const double _kTrackMaxDistance = 0.25;

  /// Android device-orientation -> degrees, for rotation compensation.
  static const Map<DeviceOrientation, int> _orientations =
      <DeviceOrientation, int>{
        DeviceOrientation.portraitUp: 0,
        DeviceOrientation.landscapeLeft: 90,
        DeviceOrientation.portraitDown: 180,
        DeviceOrientation.landscapeRight: 270,
      };

  @override
  CameraController? get controller => _controller;

  @override
  CameraLensDirection get lensDirection => _lensDirection;

  @override
  Stream<PoseModel> get poseStream => _poseController.stream;

  @override
  List<PoseModel> get latestPoses => _latestPoses;

  @override
  Stream<CameraDiagnostics> get diagnostics => _diagController.stream;

  void _emitDiag() {
    final DateTime now = DateTime.now();
    if (now.difference(_lastDiagEmit) < const Duration(milliseconds: 400)) {
      return;
    }
    _lastDiagEmit = now;
    if (!_diagController.isClosed) _diagController.add(_diag);
  }

  @override
  Future<void> initialize({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    if (_mockMode) return; // No hardware needed in mock mode.
    try {
      _lensDirection = direction;
      // Release any lingering controller first. This datasource is a singleton
      // shared across camera screens, so returning to one can leave an old
      // controller holding the camera — two live controllers contend and the
      // second acquire hangs (the "stuck on loading" symptom).
      final CameraController? existing = _controller;
      if (existing != null) {
        _controller = null;
        if (existing.value.isStreamingImages) {
          await existing.stopImageStream();
        }
        await existing.dispose();
      }
      _cameras = await availableCameras().timeout(const Duration(seconds: 8));
      if (_cameras.isEmpty) {
        throw const CameraException('No cameras available on this device.');
      }
      // Accurate model: higher-confidence landmarks (more of the skeleton
      // clears the draw threshold) at the cost of a bit more compute per frame.
      _detector ??= PoseDetector(
        options: PoseDetectorOptions(
          model: PoseDetectionModel.accurate,
          mode: PoseDetectionMode.stream,
        ),
      );
      await _startController(_pickCamera(direction));
    } on TimeoutException {
      throw const CameraException('Camera initialization timed out.');
    } on CameraException {
      rethrow;
    } catch (e) {
      throw CameraException('Failed to initialize camera: $e');
    }
  }

  CameraDescription _pickCamera(CameraLensDirection direction) {
    return _cameras.firstWhere(
      (CameraDescription c) => c.lensDirection == direction,
      orElse: () => _cameras.first,
    );
  }

  Future<void> _startController(CameraDescription camera) async {
    final CameraController controller = CameraController(
      camera,
      // Medium (~480p): the proven-stable resolution on this device. High (720p)
      // adds conversion/detector load that can stall detection on mid-range GPUs.
      ResolutionPreset.medium,
      enableAudio: false,
      // Request YUV_420_888 on Android: CameraX delivers it reliably as 3
      // planes that we convert to NV21 ourselves (yuv420ToNv21). CameraX's own
      // NV21 output is inconsistent across devices and was the likely reason
      // ML Kit saw nothing on this Redmi.
      imageFormatGroup:
          Platform.isAndroid
              ? ImageFormatGroup.yuv420
              : ImageFormatGroup.bgra8888,
    );
    try {
      await controller.initialize().timeout(const Duration(seconds: 12));
    } catch (_) {
      await controller.dispose(); // don't leak a half-initialized controller
      rethrow;
    }
    _controller = controller;
  }

  @override
  Future<void> startDetection() async {
    if (_detecting) return;
    _detecting = true;
    _diag = const CameraDiagnostics(); // reset counters for this run

    if (_mockMode) {
      _startMockStream();
      return;
    }

    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const CameraException('Camera not initialized.');
    }
    await controller.startImageStream(_processCameraImage);
  }

  @override
  Future<void> stopDetection() async {
    _detecting = false;
    _euro.reset();
    _confEma.clear();
    _prevPrimaryCentroid = null;
    _latestPoses = const <PoseModel>[];
    _mockTimer?.cancel();
    _mockTimer = null;
    final CameraController? controller = _controller;
    if (controller != null && controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
  }

  @override
  Future<void> switchCamera() async {
    if (_mockMode || _cameras.length < 2) return;
    final bool wasDetecting = _detecting;
    await stopDetection();
    _lensDirection =
        _lensDirection == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back;
    await _controller?.dispose();
    _controller = null;
    await _startController(_pickCamera(_lensDirection));
    if (wasDetecting) await startDetection();
  }

  @override
  bool get isRecordingVideo => _controller?.value.isRecordingVideo ?? false;

  @override
  Future<void> startVideoRecording() async {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw const CameraException('Camera not initialized for recording.');
    }
    if (controller.value.isStreamingImages) {
      _detecting = false;
      await controller.stopImageStream();
    }
    await controller.startVideoRecording();
  }

  @override
  Future<String> stopVideoRecording() async {
    final CameraController? controller = _controller;
    if (controller == null || !controller.value.isRecordingVideo) {
      throw const CameraException('Not currently recording.');
    }
    final XFile file = await controller.stopVideoRecording();
    return file.path;
  }

  @override
  void setMockMode({required bool enabled}) => _mockMode = enabled;

  @override
  Future<void> dispose() async {
    _detecting = false;
    _mockTimer?.cancel();
    final CameraController? controller = _controller;
    if (controller != null) {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      await controller.dispose();
    }
    _controller = null;
    _euro.reset();
    _confEma.clear();
    _prevPrimaryCentroid = null;
    await _detector?.close();
    _detector = null;
    // Close and replace so the next screen gets an open stream (see field note).
    await _poseController.close();
    _poseController = StreamController<PoseModel>.broadcast();
    await _diagController.close();
    _diagController = StreamController<CameraDiagnostics>.broadcast();
    _diag = const CameraDiagnostics();
  }

  /// Applies adaptive (1€) smoothing per landmark to reduce frame-to-frame
  /// jitter without lagging on fast motion. Confidence-gated: weak/absent
  /// landmarks (which ML Kit reports as `(0,0,conf≈0)`) are not fed into the
  /// filter — instead we hold the last good geometry but keep the *measured*
  /// low confidence, so the painter still hides them and the rep counter still
  /// skips them. These are still the raw (un-mirrored) detector coordinates;
  /// the front-camera mirror is a display-only concern applied in the painter,
  /// so mirrored coordinates must never be fed back into this math.
  PoseModel _smooth(PoseModel model) {
    final double t = model.timestamp.millisecondsSinceEpoch / 1000.0;
    final List<LandmarkModel> smoothed =
        model.landmarks.map((LandmarkModel lm) {
          final int i = lm.type.index;
          final double z = lm.z ?? 0;
          // Smooth the confidence first; the gate + emission use the smoothed
          // value so a one-frame likelihood dip/spike can't flicker the joint.
          final double sc = _kConfAlpha * lm.confidence +
              (1 - _kConfAlpha) * (_confEma[i] ?? lm.confidence);
          _confEma[i] = sc;
          if (sc >= _kSmoothConfFloor) {
            final ({double x, double y, double z}) s =
                _euro.filter(i, lm.x, lm.y, z, t);
            return lm.copyWith(x: s.x, y: s.y, z: s.z, confidence: sc);
          }
          // Low confidence: hold last good point if we have one (don't advance
          // the filter), otherwise pass the raw value through.
          if (_euro.hasState(i)) {
            final ({double x, double y, double z}) last = _euro.lastValue(i);
            return lm.copyWith(x: last.x, y: last.y, z: last.z, confidence: sc);
          }
          return lm.copyWith(confidence: sc);
        }).toList();
    return model.copyWith(landmarks: smoothed);
  }

  /// Confidence-weighted centre of the torso quad (shoulders + hips) with a
  /// shoulder-to-hip span, used to keep the primary person stable across frames.
  PoseCentroid _centroidOf(PoseModel model) {
    final LandmarkModel ls = model.landmarks[PoseLandmarkType.leftShoulder.index];
    final LandmarkModel rs =
        model.landmarks[PoseLandmarkType.rightShoulder.index];
    final LandmarkModel lh = model.landmarks[PoseLandmarkType.leftHip.index];
    final LandmarkModel rh = model.landmarks[PoseLandmarkType.rightHip.index];
    final List<LandmarkModel> quad = <LandmarkModel>[ls, rs, lh, rh];

    double wsum = 0;
    double cx = 0;
    double cy = 0;
    for (final LandmarkModel m in quad) {
      final double w = m.confidence;
      wsum += w;
      cx += m.x * w;
      cy += m.y * w;
    }
    if (wsum <= 0) {
      // No confident torso points — fall back to the unweighted mean.
      cx = quad.map((LandmarkModel m) => m.x).reduce((a, b) => a + b) / 4;
      cy = quad.map((LandmarkModel m) => m.y).reduce((a, b) => a + b) / 4;
    } else {
      cx /= wsum;
      cy /= wsum;
    }
    final double shoulderMidY = (ls.y + rs.y) / 2;
    final double hipMidY = (lh.y + rh.y) / 2;
    final double span = (hipMidY - shoulderMidY).abs();
    return PoseCentroid(cx, cy, span);
  }

  // --- Real detection -------------------------------------------------------

  Future<void> _processCameraImage(CameraImage image) async {
    // Count every delivered frame + record its format (even when throttled).
    _diag = _diag.copyWith(
      framesReceived: _diag.framesReceived + 1,
      lastFormatRaw: image.format.raw as int,
      lastPlaneCount: image.planes.length,
    );
    _emitDiag();

    final DateTime now = DateTime.now();
    if (_isBusy || now.difference(_lastProcessed) < _kFrameInterval) {
      return; // Throttle + drop frames while the detector is still running.
    }
    _isBusy = true;
    _lastProcessed = now;

    try {
      final InputImageRotation? rotation = _rotationFor();
      if (rotation == null) return;
      // Time the YUV→NV21 conversion + the detector separately so the debug HUD
      // shows the per-frame UI-isolate budget (the lever for throttle tuning).
      final Stopwatch convSw = Stopwatch()..start();
      final InputImage? inputImage = _toInputImage(image, rotation);
      convSw.stop();
      if (inputImage == null) return;
      _diag = _diag.copyWith(
        framesSentToDetector: _diag.framesSentToDetector + 1,
        lastConversionMs: convSw.elapsedMicroseconds / 1000.0,
      );
      final Stopwatch detSw = Stopwatch()..start();
      final List<Pose> poses = await _detector!.processImage(inputImage);
      detSw.stop();
      _diag = _diag.copyWith(lastDetectorMs: detSw.elapsedMicroseconds / 1000.0);
      if (poses.isEmpty) return;
      _diag = _diag.copyWith(posesFound: _diag.posesFound + 1);
      // ML Kit returns landmark coordinates in the *upright* (rotated) image
      // space, so for 90°/270° the effective frame width/height are swapped.
      // Normalize against — and store — that rotated size; otherwise every
      // coordinate is aspect-distorted, which both drifts the overlay off the
      // body and corrupts the joint angles the rep counter relies on.
      final bool swap = rotation == InputImageRotation.rotation90deg ||
          rotation == InputImageRotation.rotation270deg;
      final Size frameSize = swap
          ? Size(image.height.toDouble(), image.width.toDouble())
          : Size(image.width.toDouble(), image.height.toDouble());
      // Map every detected person (raw, un-mirrored detector coordinates).
      final List<PoseModel> models = poses
          .map((Pose p) => PoseModel.fromMLKitPose(
                p,
                imageSize: frameSize,
                source: PoseSource.camera,
                timestamp: now,
              ))
          .toList();
      // Keep the SAME human as "primary" across frames — ML Kit's list order is
      // not stable, so plain `models.first` can swap people mid-rep. Match the
      // current centroids to the previous primary's; on re-acquisition reset the
      // smoother so two people's trajectories never blend.
      final List<PoseCentroid> centroids =
          models.map(_centroidOf).toList(growable: false);
      final ({int index, bool reacquired}) pick = PersonTracker.indexOfClosest(
        candidates: centroids,
        previous: _prevPrimaryCentroid,
        maxDistance: _kTrackMaxDistance,
      );
      final PoseModel candidate = models[pick.index];
      if (pick.reacquired) {
        _euro.reset();
        _confEma.clear();
      }
      _prevPrimaryCentroid = centroids[pick.index];
      // The primary is smoothed and drives the single-person features (rep
      // counter, segments, gait); the rest stay raw for drawing all skeletons.
      final PoseModel primary = _smooth(candidate);
      final List<PoseModel> rest = <PoseModel>[
        for (int i = 0; i < models.length; i++)
          if (i != pick.index) models[i],
      ];
      _latestPoses = <PoseModel>[primary, ...rest];
      if (!_poseController.isClosed) _poseController.add(primary);
    } catch (e) {
      // Never crash the stream on a bad frame — log and continue (PRD §7.3).
      _diag = _diag.copyWith(lastError: '$e');
      debugPrint('Pose frame skipped: $e');
    } finally {
      _isBusy = false;
    }
  }

  /// The ML Kit input rotation for the active camera, compensating for sensor +
  /// device orientation and lens direction. Null if no controller yet.
  InputImageRotation? _rotationFor() {
    final CameraController? controller = _controller;
    if (controller == null) return null;
    final CameraDescription camera = controller.description;
    final int sensorOrientation = camera.sensorOrientation;

    if (Platform.isIOS) {
      return InputImageRotationValue.fromRawValue(sensorOrientation);
    }
    // Default to 0 (portrait) rather than dropping the frame if the device
    // reports an orientation we don't have mapped — dropping every frame is
    // what makes detection silently produce nothing.
    final int compensation =
        _orientations[controller.value.deviceOrientation] ?? 0;
    final int rotationCompensation =
        camera.lensDirection == CameraLensDirection.front
            ? (sensorOrientation + compensation) % 360
            : (sensorOrientation - compensation + 360) % 360;
    return InputImageRotationValue.fromRawValue(rotationCompensation);
  }

  /// Converts a [CameraImage] to an ML Kit [InputImage] using the given
  /// [rotation]. Returns null for frames whose format/layout ML Kit can't
  /// accept (those are simply skipped).
  InputImage? _toInputImage(CameraImage image, InputImageRotation rotation) {
    final InputImageFormat? rawFormat = InputImageFormatValue.fromRawValue(
      image.format.raw as int,
    );
    final Size size = Size(image.width.toDouble(), image.height.toDouble());

    // iOS delivers a single BGRA plane; pass it straight through.
    if (Platform.isIOS) {
      if (rawFormat != InputImageFormat.bgra8888 || image.planes.length != 1) {
        return null;
      }
      final Plane plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: size,
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }

    // Android: ML Kit wants NV21. Some devices honor the requested NV21 group
    // (single packed plane); many — incl. this Redmi — hand back multi-plane
    // YUV_420_888, which we must repack to NV21 or the detector sees nothing.
    if (rawFormat == InputImageFormat.nv21 && image.planes.length == 1) {
      final Plane plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: size,
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }
    if (image.planes.length == 3) {
      final Plane y = image.planes[0];
      final Plane u = image.planes[1];
      final Plane v = image.planes[2];
      final Uint8List nv21 = yuv420ToNv21(
        width: image.width,
        height: image.height,
        y: y.bytes,
        yRowStride: y.bytesPerRow,
        u: u.bytes,
        uRowStride: u.bytesPerRow,
        uPixelStride: u.bytesPerPixel ?? 1,
        v: v.bytes,
        vRowStride: v.bytesPerRow,
        vPixelStride: v.bytesPerPixel ?? 1,
      );
      return InputImage.fromBytes(
        bytes: nv21,
        metadata: InputImageMetadata(
          size: size,
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.width, // packed NV21: one Y byte per pixel
        ),
      );
    }
    return null;
  }

  // --- Mock mode ------------------------------------------------------------

  void _startMockStream() {
    _mockTimer?.cancel();
    final DateTime start = DateTime.now();
    _mockTimer = Timer.periodic(_kFrameInterval, (_) {
      if (_poseController.isClosed) return;
      final double t = DateTime.now().difference(start).inMilliseconds / 1000.0;
      final PoseModel mock = _mockPose(t);
      _latestPoses = <PoseModel>[mock];
      _poseController.add(mock);
    });
  }

  /// Synthetic standing figure whose arms swing with a sine wave, so the full
  /// overlay (33 dots + 32 bones, region colors) can be exercised without a
  /// physical device or ML Kit.
  PoseModel _mockPose(double t) {
    final double swing = math.sin(t * 2) * 0.06;
    final Map<int, List<double>> base = <int, List<double>>{
      0: <double>[0.50, 0.12],
      1: <double>[0.52, 0.10],
      2: <double>[0.53, 0.10],
      3: <double>[0.54, 0.10],
      4: <double>[0.48, 0.10],
      5: <double>[0.47, 0.10],
      6: <double>[0.46, 0.10],
      7: <double>[0.55, 0.11],
      8: <double>[0.45, 0.11],
      9: <double>[0.52, 0.14],
      10: <double>[0.48, 0.14],
      11: <double>[0.60, 0.25],
      12: <double>[0.40, 0.25],
      13: <double>[0.65, 0.38 + swing],
      14: <double>[0.35, 0.38 - swing],
      15: <double>[0.68, 0.50 + swing],
      16: <double>[0.32, 0.50 - swing],
      17: <double>[0.69, 0.53 + swing],
      18: <double>[0.31, 0.53 - swing],
      19: <double>[0.70, 0.53 + swing],
      20: <double>[0.30, 0.53 - swing],
      21: <double>[0.67, 0.52 + swing],
      22: <double>[0.33, 0.52 - swing],
      23: <double>[0.56, 0.55],
      24: <double>[0.44, 0.55],
      25: <double>[0.57, 0.72],
      26: <double>[0.43, 0.72],
      27: <double>[0.58, 0.90],
      28: <double>[0.42, 0.90],
      29: <double>[0.57, 0.92],
      30: <double>[0.43, 0.92],
      31: <double>[0.60, 0.93],
      32: <double>[0.40, 0.93],
    };
    final List<LandmarkModel> landmarks =
        PoseLandmarkType.values.map((PoseLandmarkType type) {
          final List<double> p = base[type.index]!;
          return LandmarkModel(
            type: type,
            x: p[0],
            y: p[1],
            confidence: 0.92,
            z: 0,
          );
        }).toList();

    return PoseModel(
      landmarks: landmarks,
      timestamp: DateTime.now(),
      source: PoseSource.mock,
      imageWidth: 1,
      imageHeight: 1,
    );
  }
}

/// Repacks an Android `YUV_420_888` camera frame into a contiguous **NV21**
/// buffer (full Y plane, then interleaved V,U), which is what ML Kit accepts.
///
/// Strides matter: planes can be padded (`rowStride > width`) and chroma can be
/// interleaved (`pixelStride == 2`), so every sample is read by its stride
/// rather than assuming packed data. Pure and side-effect-free for testing.
Uint8List yuv420ToNv21({
  required int width,
  required int height,
  required Uint8List y,
  required int yRowStride,
  required Uint8List u,
  required int uRowStride,
  required int uPixelStride,
  required Uint8List v,
  required int vRowStride,
  required int vPixelStride,
}) {
  final Uint8List out = Uint8List(width * height + 2 * ((width + 1) ~/ 2) * ((height + 1) ~/ 2));
  int dst = 0;

  // Y plane, row by row (drop any right-edge padding).
  for (int row = 0; row < height; row++) {
    final int srcStart = row * yRowStride;
    out.setRange(dst, dst + width, y, srcStart);
    dst += width;
  }

  // Interleaved V,U at quarter resolution.
  final int chromaWidth = (width + 1) ~/ 2;
  final int chromaHeight = (height + 1) ~/ 2;
  for (int row = 0; row < chromaHeight; row++) {
    int uIndex = row * uRowStride;
    int vIndex = row * vRowStride;
    for (int col = 0; col < chromaWidth; col++) {
      out[dst++] = v[vIndex];
      out[dst++] = u[uIndex];
      uIndex += uPixelStride;
      vIndex += vPixelStride;
    }
  }
  return out;
}

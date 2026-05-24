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
import 'package:poseweave/data/datasources/mlkit_camera_datasource.dart';
import 'package:poseweave/data/models/landmark_model.dart';
import 'package:poseweave/data/models/pose_model.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';

/// Minimum gap between processed frames (~15 FPS). Anything faster starves the
/// UI thread and the battery without improving the visible result.
const Duration _kFrameInterval = Duration(milliseconds: 66);

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
  DateTime _lastProcessed = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _mockTimer;

  // On-device diagnostics for the debug HUD (see CameraDiagnostics).
  StreamController<CameraDiagnostics> _diagController =
      StreamController<CameraDiagnostics>.broadcast();
  CameraDiagnostics _diag = const CameraDiagnostics();
  DateTime _lastDiagEmit = DateTime.fromMillisecondsSinceEpoch(0);

  /// Exponential-moving-average state per landmark index, to smooth jitter.
  /// Higher [_alpha] = more responsive, less smoothing.
  final Map<int, _Smoothed> _ema = <int, _Smoothed>{};
  static const double _alpha = 0.4;

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
      _detector ??= PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
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
    _ema.clear();
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
    _ema.clear();
    await _detector?.close();
    _detector = null;
    // Close and replace so the next screen gets an open stream (see field note).
    await _poseController.close();
    _poseController = StreamController<PoseModel>.broadcast();
    await _diagController.close();
    _diagController = StreamController<CameraDiagnostics>.broadcast();
    _diag = const CameraDiagnostics();
  }

  /// Applies per-landmark EMA smoothing to reduce frame-to-frame jitter.
  PoseModel _smooth(PoseModel model) {
    final List<LandmarkModel> smoothed =
        model.landmarks.map((LandmarkModel lm) {
          final int i = lm.type.index;
          final double z = lm.z ?? 0;
          final _Smoothed? prev = _ema[i];
          if (prev == null) {
            _ema[i] = _Smoothed(lm.x, lm.y, z, lm.confidence);
            return lm;
          }
          final double sx = _alpha * lm.x + (1 - _alpha) * prev.x;
          final double sy = _alpha * lm.y + (1 - _alpha) * prev.y;
          final double sz = _alpha * z + (1 - _alpha) * prev.z;
          final double sc =
              _alpha * lm.confidence + (1 - _alpha) * prev.confidence;
          _ema[i] = _Smoothed(sx, sy, sz, sc);
          return lm.copyWith(x: sx, y: sy, z: sz, confidence: sc);
        }).toList();
    return model.copyWith(landmarks: smoothed);
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
      final InputImage? inputImage = _toInputImage(image);
      if (inputImage == null) return;
      _diag = _diag.copyWith(
        framesSentToDetector: _diag.framesSentToDetector + 1,
      );
      final List<Pose> poses = await _detector!.processImage(inputImage);
      if (poses.isEmpty) return;
      _diag = _diag.copyWith(posesFound: _diag.posesFound + 1);
      final PoseModel model = PoseModel.fromMLKitPose(
        poses.first,
        imageSize: Size(image.width.toDouble(), image.height.toDouble()),
        source: PoseSource.camera,
        timestamp: now,
      );
      if (!_poseController.isClosed) _poseController.add(_smooth(model));
    } catch (e) {
      // Never crash the stream on a bad frame — log and continue (PRD §7.3).
      _diag = _diag.copyWith(lastError: '$e');
      debugPrint('Pose frame skipped: $e');
    } finally {
      _isBusy = false;
    }
  }

  /// Converts a [CameraImage] to an ML Kit [InputImage], compensating for
  /// sensor + device orientation and lens direction. Returns null for frames
  /// whose format/layout ML Kit can't accept (those are simply skipped).
  InputImage? _toInputImage(CameraImage image) {
    final CameraController? controller = _controller;
    if (controller == null) return null;
    final CameraDescription camera = controller.description;
    final int sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else {
      // Default to 0 (portrait) rather than dropping the frame if the device
      // reports an orientation we don't have mapped — dropping every frame is
      // what makes detection silently produce nothing.
      final int compensation =
          _orientations[controller.value.deviceOrientation] ?? 0;
      final int rotationCompensation =
          camera.lensDirection == CameraLensDirection.front
              ? (sensorOrientation + compensation) % 360
              : (sensorOrientation - compensation + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

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
      _poseController.add(_mockPose(t));
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

/// One landmark's smoothed EMA state.
class _Smoothed {
  const _Smoothed(this.x, this.y, this.z, this.confidence);
  final double x;
  final double y;
  final double z;
  final double confidence;
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

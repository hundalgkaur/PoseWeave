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

  final StreamController<PoseModel> _poseController =
      StreamController<PoseModel>.broadcast();

  bool _isBusy = false;
  bool _detecting = false;
  bool _mockMode = false;
  DateTime _lastProcessed = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _mockTimer;

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
  Future<void> initialize({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    if (_mockMode) return; // No hardware needed in mock mode.
    try {
      _lensDirection = direction;
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw const CameraException('No cameras available on this device.');
      }
      _detector ??= PoseDetector(
        options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
      );
      await _startController(_pickCamera(direction));
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
      imageFormatGroup:
          Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    await controller.initialize();
    _controller = controller;
  }

  @override
  Future<void> startDetection() async {
    if (_detecting) return;
    _detecting = true;

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
    _lensDirection = _lensDirection == CameraLensDirection.back
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
    await _detector?.close();
    _detector = null;
    await _poseController.close();
  }

  // --- Real detection -------------------------------------------------------

  Future<void> _processCameraImage(CameraImage image) async {
    final DateTime now = DateTime.now();
    if (_isBusy || now.difference(_lastProcessed) < _kFrameInterval) {
      return; // Throttle + drop frames while the detector is still running.
    }
    _isBusy = true;
    _lastProcessed = now;

    try {
      final InputImage? inputImage = _toInputImage(image);
      if (inputImage == null) return;
      final List<Pose> poses = await _detector!.processImage(inputImage);
      if (poses.isEmpty) return;
      final PoseModel model = PoseModel.fromMLKitPose(
        poses.first,
        imageSize: Size(image.width.toDouble(), image.height.toDouble()),
        source: PoseSource.camera,
        timestamp: now,
      );
      if (!_poseController.isClosed) _poseController.add(model);
    } catch (e) {
      // Never crash the stream on a bad frame — log and continue (PRD §7.3).
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
      final int? compensation = _orientations[controller.value.deviceOrientation];
      if (compensation == null) return null;
      final int rotationCompensation =
          camera.lensDirection == CameraLensDirection.front
              ? (sensorOrientation + compensation) % 360
              : (sensorOrientation - compensation + 360) % 360;
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final InputImageFormat? format =
        InputImageFormatValue.fromRawValue(image.format.raw as int);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }
    if (image.planes.length != 1) return null;
    final Plane plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  // --- Mock mode ------------------------------------------------------------

  void _startMockStream() {
    _mockTimer?.cancel();
    final DateTime start = DateTime.now();
    _mockTimer = Timer.periodic(_kFrameInterval, (_) {
      if (_poseController.isClosed) return;
      final double t =
          DateTime.now().difference(start).inMilliseconds / 1000.0;
      _poseController.add(_mockPose(t));
    });
  }

  /// Synthetic standing figure whose arms swing with a sine wave, so the full
  /// overlay (33 dots + 32 bones, region colors) can be exercised without a
  /// physical device or ML Kit.
  PoseModel _mockPose(double t) {
    final double swing = math.sin(t * 2) * 0.06;
    final Map<int, List<double>> base = <int, List<double>>{
      0: <double>[0.50, 0.12], 1: <double>[0.52, 0.10],
      2: <double>[0.53, 0.10], 3: <double>[0.54, 0.10],
      4: <double>[0.48, 0.10], 5: <double>[0.47, 0.10],
      6: <double>[0.46, 0.10], 7: <double>[0.55, 0.11],
      8: <double>[0.45, 0.11], 9: <double>[0.52, 0.14],
      10: <double>[0.48, 0.14], 11: <double>[0.60, 0.25],
      12: <double>[0.40, 0.25], 13: <double>[0.65, 0.38 + swing],
      14: <double>[0.35, 0.38 - swing], 15: <double>[0.68, 0.50 + swing],
      16: <double>[0.32, 0.50 - swing], 17: <double>[0.69, 0.53 + swing],
      18: <double>[0.31, 0.53 - swing], 19: <double>[0.70, 0.53 + swing],
      20: <double>[0.30, 0.53 - swing], 21: <double>[0.67, 0.52 + swing],
      22: <double>[0.33, 0.52 - swing], 23: <double>[0.56, 0.55],
      24: <double>[0.44, 0.55], 25: <double>[0.57, 0.72],
      26: <double>[0.43, 0.72], 27: <double>[0.58, 0.90],
      28: <double>[0.42, 0.90], 29: <double>[0.57, 0.92],
      30: <double>[0.43, 0.92], 31: <double>[0.60, 0.93],
      32: <double>[0.40, 0.93],
    };
    final List<LandmarkModel> landmarks =
        PoseLandmarkType.values.map((PoseLandmarkType type) {
      final List<double> p = base[type.index]!;
      return LandmarkModel(type: type, x: p[0], y: p[1], confidence: 0.92, z: 0);
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

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:poseweave/core/app_settings.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/video_analysis_progress.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';

/// Drives the entire camera/video pose lifecycle. The UI only dispatches
/// events and renders [PoseState]; all orchestration lives here, all I/O lives
/// behind [PoseRepository].
@injectable
class PoseBloc extends Bloc<PoseEvent, PoseState> {
  PoseBloc(this._repository) : super(const PoseState.initial()) {
    // Honor the dev mock-mode setting chosen before this screen opened, so
    // initialization reads a stable flag (no event-ordering race).
    _mockMode = AppSettings.mockMode;
    _repository.setMockMode(enabled: _mockMode);
    on<InitializeCamera>(_onInitialize);
    on<StartDetection>(_onStartDetection);
    on<StopDetection>(_onStopDetection);
    on<SwitchCamera>(_onSwitchCamera);
    on<ToggleMockMode>(_onToggleMockMode);
    on<StartVideoRecording>(_onStartVideoRecording);
    on<StopVideoRecording>(_onStopVideoRecording);
    on<PoseReceived>(_onPoseReceived);
    on<PickAndAnalyzeVideo>(_onPickAndAnalyzeVideo);
    on<AnalyzeVideoFile>(_onAnalyzeVideoFile);
    on<PickAndAnalyzeImage>(_onPickAndAnalyzeImage);
  }

  final PoseRepository _repository;

  StreamSubscription<PoseEntity>? _poseSubscription;
  bool _mockMode = false;
  DateTime? _lastPoseTime;
  double _fps = 0;

  /// Exposed for the preview widget only (display). Null in mock mode.
  CameraController? get cameraController => _repository.cameraController;
  CameraLensDirection get lensDirection => _repository.lensDirection;
  bool get isMockMode => _mockMode;

  Future<void> _onInitialize(
    InitializeCamera event,
    Emitter<PoseState> emit,
  ) async {
    emit(const PoseState.loading());

    // Mock mode needs no hardware or permission.
    if (!_mockMode) {
      final PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted) {
        emit(const PoseState.noPermission());
        return;
      }
    }

    final Either<Failure, Unit> result = await _repository.initializeCamera();
    result.fold(
      (Failure f) => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      (_) => emit(const PoseState.streaming()),
    );
  }

  Future<void> _onStartDetection(
    StartDetection event,
    Emitter<PoseState> emit,
  ) async {
    final Either<Failure, Stream<PoseEntity>> streamResult =
        _repository.getPoseStream();
    final Stream<PoseEntity>? stream = streamResult.fold((Failure f) {
      emit(PoseState.error(message: f.message, isRecoverable: f.isRecoverable));
      return null;
    }, (Stream<PoseEntity> s) => s);
    if (stream == null) return;

    await _poseSubscription?.cancel();
    _poseSubscription = stream.listen(
      (PoseEntity pose) => add(PoseEvent.poseReceived(pose)),
      onError:
          (Object e) => add(
            const PoseEvent.stopDetection(),
          ), // bad stream -> stop cleanly
    );

    final Either<Failure, Unit> started = await _repository.startDetection();
    started.fold(
      (Failure f) => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      (_) => emit(const PoseState.streaming()),
    );
  }

  Future<void> _onStopDetection(
    StopDetection event,
    Emitter<PoseState> emit,
  ) async {
    await _poseSubscription?.cancel();
    _poseSubscription = null;
    _lastPoseTime = null;
    await _repository.stopDetection();
    emit(const PoseState.streaming());
  }

  Future<void> _onSwitchCamera(
    SwitchCamera event,
    Emitter<PoseState> emit,
  ) async {
    final Either<Failure, Unit> result = await _repository.switchCamera();
    result.fold(
      (Failure f) => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      (_) {},
    );
  }

  Future<void> _onToggleMockMode(
    ToggleMockMode event,
    Emitter<PoseState> emit,
  ) async {
    _mockMode = !_mockMode;
    _repository.setMockMode(enabled: _mockMode);
  }

  Future<void> _onStartVideoRecording(
    StartVideoRecording event,
    Emitter<PoseState> emit,
  ) async {
    // Recording uses the camera plugin's video path, which can't coexist with
    // the ML Kit image stream — cancel detection first.
    await _poseSubscription?.cancel();
    _poseSubscription = null;
    final Either<Failure, Unit> result =
        await _repository.startVideoRecording();
    result.fold(
      (Failure f) => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      (_) => emit(const PoseState.recordingVideo()),
    );
  }

  Future<void> _onStopVideoRecording(
    StopVideoRecording event,
    Emitter<PoseState> emit,
  ) async {
    final Either<Failure, String> result =
        await _repository.stopVideoRecording();
    await result.fold(
      (Failure f) async => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      // Same two-pass pipeline as gallery analysis, on the just-recorded clip.
      (String path) => _analyze(path, emit),
    );
  }

  void _onPoseReceived(PoseReceived event, Emitter<PoseState> emit) {
    _updateFps();
    emit(
      PoseState.active(
        // A new pose every frame keeps the skeleton animating; the 15 FPS
        // throttle in the datasource already bounds the rebuild rate, so no
        // extra change-gate is needed here.
        pose: event.pose,
        averageConfidence: event.pose.averageConfidence,
        fps: _fps,
      ),
    );
  }

  Future<void> _onPickAndAnalyzeVideo(
    PickAndAnalyzeVideo event,
    Emitter<PoseState> emit,
  ) async {
    final Either<Failure, String?> picked = await _repository.pickVideo();
    final String? path = picked.fold((Failure f) {
      emit(PoseState.error(message: f.message, isRecoverable: f.isRecoverable));
      return null;
    }, (String? p) => p);
    if (path == null) return; // cancelled or failed
    await _analyze(path, emit);
  }

  Future<void> _onAnalyzeVideoFile(
    AnalyzeVideoFile event,
    Emitter<PoseState> emit,
  ) => _analyze(event.filePath, emit);

  Future<void> _onPickAndAnalyzeImage(
    PickAndAnalyzeImage event,
    Emitter<PoseState> emit,
  ) async {
    final Either<Failure, String?> picked = await _repository.pickImage();
    final String? path = picked.fold((Failure f) {
      emit(PoseState.error(message: f.message, isRecoverable: f.isRecoverable));
      return null;
    }, (String? p) => p);
    if (path == null) return; // cancelled or failed
    emit(const PoseState.imageProcessing());
    final Either<Failure, PoseEntity?> result = await _repository.analyzeImage(
      path,
    );
    result.fold(
      (Failure f) => emit(
        PoseState.error(message: f.message, isRecoverable: f.isRecoverable),
      ),
      (PoseEntity? pose) =>
          emit(PoseState.imageComplete(imagePath: path, pose: pose)),
    );
  }

  Future<void> _analyze(String path, Emitter<PoseState> emit) async {
    emit(const PoseState.videoProcessing(progress: 0, framesProcessed: 0));
    final List<PoseEntity> poses = <PoseEntity>[];
    final List<String> framePaths = <String>[];
    try {
      await for (final VideoAnalysisProgress p in _repository.analyzeVideo(
        path,
      )) {
        if (p.pose != null) {
          poses.add(p.pose!);
          framePaths.add(p.framePath ?? ''); // stays index-aligned with poses
        }
        emit(
          PoseState.videoProcessing(
            progress: p.progress,
            framesProcessed: p.currentFrame,
            currentPose: p.pose,
          ),
        );
      }
      emit(
        PoseState.videoComplete(
          poses: poses,
          frameCount: poses.length,
          videoPath: path,
          framePaths: framePaths,
        ),
      );
    } catch (e) {
      emit(
        PoseState.error(
          message: 'Video analysis failed: $e',
          isRecoverable: true,
        ),
      );
    }
  }

  void _updateFps() {
    final DateTime now = DateTime.now();
    if (_lastPoseTime != null) {
      final int deltaMs = now.difference(_lastPoseTime!).inMilliseconds;
      if (deltaMs > 0) {
        final double instant = 1000 / deltaMs;
        // Exponential smoothing so the displayed number doesn't jump.
        _fps = _fps == 0 ? instant : _fps * 0.8 + instant * 0.2;
      }
    }
    _lastPoseTime = now;
  }

  @override
  Future<void> close() async {
    await _poseSubscription?.cancel();
    await _repository.disposeCamera();
    return super.close();
  }
}

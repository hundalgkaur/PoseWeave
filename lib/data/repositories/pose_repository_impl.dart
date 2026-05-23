import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart' hide CameraException;
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poseweave/core/errors/exceptions.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/data/datasources/mlkit_camera_datasource.dart';
import 'package:poseweave/data/datasources/video_frame_datasource.dart';
import 'package:poseweave/data/models/pose_model.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/video_analysis_progress.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';

/// How many recent poses to keep in memory for review/replay.
const int _kPoseCacheSize = 100;

@LazySingleton(as: PoseRepository)
class PoseRepositoryImpl implements PoseRepository {
  PoseRepositoryImpl(this._cameraDataSource, this._videoDataSource);

  final MLKitCameraDataSource _cameraDataSource;
  final VideoFrameDataSource _videoDataSource;

  final Queue<PoseEntity> _recentPoses = Queue<PoseEntity>();

  @override
  CameraController? get cameraController => _cameraDataSource.controller;

  @override
  CameraLensDirection get lensDirection => _cameraDataSource.lensDirection;

  @override
  List<PoseEntity> get recentPoses =>
      List<PoseEntity>.unmodifiable(_recentPoses);

  @override
  Future<Either<Failure, Unit>> initializeCamera({
    CameraLensDirection direction = CameraLensDirection.back,
  }) async {
    try {
      await _cameraDataSource.initialize(direction: direction);
      return const Right<Failure, Unit>(unit);
    } on CameraException catch (e) {
      return Left<Failure, Unit>(CameraFailure(e.message));
    } on PermissionException catch (e) {
      return Left<Failure, Unit>(PermissionFailure(e.message));
    } catch (e) {
      return Left<Failure, Unit>(CameraFailure('$e'));
    }
  }

  @override
  Either<Failure, Stream<PoseEntity>> getPoseStream() {
    try {
      final Stream<PoseEntity> stream = _cameraDataSource.poseStream.map((
        PoseModel model,
      ) {
        final PoseEntity entity = model.toEntity();
        _cache(entity);
        return entity;
      });
      return Right<Failure, Stream<PoseEntity>>(stream);
    } catch (e) {
      return Left<Failure, Stream<PoseEntity>>(MLFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> startDetection() async {
    try {
      await _cameraDataSource.startDetection();
      return const Right<Failure, Unit>(unit);
    } on CameraException catch (e) {
      return Left<Failure, Unit>(CameraFailure(e.message));
    } catch (e) {
      return Left<Failure, Unit>(MLFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> stopDetection() async {
    try {
      await _cameraDataSource.stopDetection();
      return const Right<Failure, Unit>(unit);
    } catch (e) {
      return Left<Failure, Unit>(CameraFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, Unit>> switchCamera() async {
    try {
      await _cameraDataSource.switchCamera();
      return const Right<Failure, Unit>(unit);
    } catch (e) {
      return Left<Failure, Unit>(CameraFailure('$e'));
    }
  }

  @override
  bool get isRecordingVideo => _cameraDataSource.isRecordingVideo;

  @override
  Future<Either<Failure, Unit>> startVideoRecording() async {
    try {
      await _cameraDataSource.startVideoRecording();
      return const Right<Failure, Unit>(unit);
    } on CameraException catch (e) {
      return Left<Failure, Unit>(CameraFailure(e.message));
    } catch (e) {
      return Left<Failure, Unit>(CameraFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, String>> stopVideoRecording() async {
    try {
      return Right<Failure, String>(
        await _cameraDataSource.stopVideoRecording(),
      );
    } on CameraException catch (e) {
      return Left<Failure, String>(CameraFailure(e.message));
    } catch (e) {
      return Left<Failure, String>(CameraFailure('$e'));
    }
  }

  @override
  void setMockMode({required bool enabled}) =>
      _cameraDataSource.setMockMode(enabled: enabled);

  @override
  Future<void> disposeCamera() => _cameraDataSource.dispose();

  @override
  Future<Either<Failure, String?>> pickVideo() async {
    try {
      return Right<Failure, String?>(await _videoDataSource.pickVideo());
    } on VideoException catch (e) {
      return Left<Failure, String?>(VideoFailure(e.message));
    } catch (e) {
      return Left<Failure, String?>(VideoFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, String?>> pickImage() async {
    try {
      return Right<Failure, String?>(await _videoDataSource.pickImage());
    } on VideoException catch (e) {
      return Left<Failure, String?>(VideoFailure(e.message));
    } catch (e) {
      return Left<Failure, String?>(VideoFailure('$e'));
    }
  }

  @override
  Future<Either<Failure, PoseEntity?>> analyzeImage(String filePath) async {
    try {
      final PoseModel? model = await _videoDataSource.analyzeImage(filePath);
      final PoseEntity? entity = model?.toEntity();
      if (entity != null) _cache(entity);
      return Right<Failure, PoseEntity?>(entity);
    } on VideoException catch (e) {
      return Left<Failure, PoseEntity?>(VideoFailure(e.message));
    } catch (e) {
      return Left<Failure, PoseEntity?>(VideoFailure('$e'));
    }
  }

  @override
  Stream<VideoAnalysisProgress> analyzeVideo(String filePath) {
    return _videoDataSource.processVideo(filePath).map((
      VideoProcessingProgress p,
    ) {
      final PoseEntity? entity = p.pose?.toEntity();
      if (entity != null) _cache(entity);
      return VideoAnalysisProgress(
        currentFrame: p.currentFrame,
        totalFrames: p.totalFrames,
        pose: entity,
        framePath: p.framePath,
      );
    });
  }

  @override
  Future<Either<Failure, String>> exportPosesToJson(
    List<PoseEntity> poses,
  ) async {
    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'app': 'PoseWeave',
        'version': '1.0.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'poseCount': poses.length,
        'poses':
            poses
                .map((PoseEntity p) => PoseModel.fromEntity(p).toJson())
                .toList(),
      };
      final Directory dir = await getTemporaryDirectory();
      final File file = File(
        '${dir.path}/poseweave_export_'
        '${DateTime.now().millisecondsSinceEpoch}.json',
      );
      await file.writeAsString(jsonEncode(payload));
      return Right<Failure, String>(file.path);
    } catch (e) {
      return Left<Failure, String>(ExportFailure('Export failed: $e'));
    }
  }

  void _cache(PoseEntity pose) {
    _recentPoses.addLast(pose);
    while (_recentPoses.length > _kPoseCacheSize) {
      _recentPoses.removeFirst();
    }
  }
}

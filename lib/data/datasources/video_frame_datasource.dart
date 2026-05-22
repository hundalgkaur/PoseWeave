import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    hide PoseLandmarkType;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poseweave/core/errors/exceptions.dart';
import 'package:poseweave/data/models/pose_model.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

/// One step of video processing: a detected pose at a frame, plus progress.
class VideoProcessingProgress {
  const VideoProcessingProgress({
    required this.currentFrame,
    required this.totalFrames,
    this.pose,
  });

  final int currentFrame;
  final int totalFrames;
  final PoseModel? pose;

  double get progress => totalFrames == 0 ? 0 : currentFrame / totalFrames;
  bool get isComplete => currentFrame >= totalFrames;
}

/// Extracts frames from a video file and runs pose detection on each.
abstract class VideoFrameDataSource {
  /// Opens the gallery picker; returns the chosen file path or null.
  Future<String?> pickVideo();

  /// Emits progress (and the pose for each sampled frame) until complete.
  Stream<VideoProcessingProgress> processVideo(String filePath);
}

/// Samples one frame every [_kSampleInterval] (~5 FPS) — enough to show motion
/// in the timeline without the per-frame thumbnail extraction making a short
/// clip take too long.
const Duration _kSampleInterval = Duration(milliseconds: 200);

/// Cap so a long clip can't spawn thousands of extractions in the demo.
const int _kMaxFrames = 150;

@LazySingleton(as: VideoFrameDataSource)
class VideoFrameDataSourceImpl implements VideoFrameDataSource {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<String?> pickVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      return file?.path;
    } catch (e) {
      throw VideoException('Failed to pick video: $e');
    }
  }

  @override
  Stream<VideoProcessingProgress> processVideo(String filePath) async* {
    final PoseDetector detector = PoseDetector(
      options: PoseDetectorOptions(),
    );
    Directory? tempDir;
    try {
      final Duration duration = await _videoDuration(filePath);
      tempDir = await getTemporaryDirectory();

      final int totalFrames = (duration.inMilliseconds ~/
              _kSampleInterval.inMilliseconds)
          .clamp(1, _kMaxFrames);

      for (int i = 0; i < totalFrames; i++) {
        final int timeMs = i * _kSampleInterval.inMilliseconds;
        final PoseModel? pose =
            await _detectAtTime(detector, filePath, timeMs, tempDir.path, i);
        yield VideoProcessingProgress(
          currentFrame: i + 1,
          totalFrames: totalFrames,
          pose: pose,
        );
      }
    } catch (e) {
      throw VideoException('Failed to process video: $e');
    } finally {
      await detector.close();
    }
  }

  Future<Duration> _videoDuration(String filePath) async {
    final VideoPlayerController controller =
        VideoPlayerController.file(File(filePath));
    try {
      await controller.initialize();
      return controller.value.duration;
    } finally {
      await controller.dispose();
    }
  }

  /// Extracts a JPEG at [timeMs], decodes its size, and detects a pose.
  /// Returns null if extraction or detection yields nothing (frame skipped).
  Future<PoseModel?> _detectAtTime(
    PoseDetector detector,
    String videoPath,
    int timeMs,
    String tempPath,
    int index,
  ) async {
    final String? framePath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: '$tempPath/frame_$index.jpg',
      imageFormat: ImageFormat.JPEG,
      maxHeight: 480,
      timeMs: timeMs,
      quality: 75,
    );
    if (framePath == null) return null;

    final File frameFile = File(framePath);
    final ui.Size size = await _decodeSize(await frameFile.readAsBytes());
    final List<Pose> poses =
        await detector.processImage(InputImage.fromFilePath(framePath));
    if (poses.isEmpty) return null;

    return PoseModel.fromMLKitPose(
      poses.first,
      imageSize: size,
      source: PoseSource.videoFile,
    );
  }

  Future<ui.Size> _decodeSize(Uint8List bytes) async {
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Size size = ui.Size(
      frame.image.width.toDouble(),
      frame.image.height.toDouble(),
    );
    frame.image.dispose();
    codec.dispose();
    return size;
  }
}

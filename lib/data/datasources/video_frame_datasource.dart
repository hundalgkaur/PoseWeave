import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    hide PoseLandmarkType;
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poseweave/core/constants/analysis_constants.dart';
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
    this.framePath,
  });

  final int currentFrame;
  final int totalFrames;
  final PoseModel? pose;

  /// Path to the extracted JPEG for this frame (for overlaying the skeleton on
  /// the real image in results).
  final String? framePath;

  double get progress => totalFrames == 0 ? 0 : currentFrame / totalFrames;
  bool get isComplete => currentFrame >= totalFrames;
}

/// Extracts frames from a video file and runs pose detection on each.
abstract class VideoFrameDataSource {
  /// Opens the gallery picker; returns the chosen file path or null.
  Future<String?> pickVideo();

  /// Emits progress (and the pose for each sampled frame) until complete.
  Stream<VideoProcessingProgress> processVideo(String filePath);

  /// Opens the gallery image picker; returns the chosen image path or null.
  Future<String?> pickImage();

  /// Runs single-shot pose detection on an image file. Null if no pose found.
  Future<PoseModel?> analyzeImage(String filePath);
}

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
  Future<String?> pickImage() async {
    try {
      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
      return file?.path;
    } catch (e) {
      throw VideoException('Failed to pick image: $e');
    }
  }

  @override
  Future<PoseModel?> analyzeImage(String filePath) async {
    final PoseDetector detector = PoseDetector(options: PoseDetectorOptions());
    try {
      final ui.Size size = await _decodeSize(
        await File(filePath).readAsBytes(),
      );
      final List<Pose> poses = await detector.processImage(
        InputImage.fromFilePath(filePath),
      );
      if (poses.isEmpty) return null;
      return PoseModel.fromMLKitPose(
        poses.first,
        imageSize: size,
        source: PoseSource.videoFile,
      );
    } catch (e) {
      throw VideoException('Failed to analyze image: $e');
    } finally {
      await detector.close();
    }
  }

  @override
  Stream<VideoProcessingProgress> processVideo(String filePath) async* {
    final PoseDetector detector = PoseDetector(options: PoseDetectorOptions());
    Directory? tempDir;
    try {
      tempDir = await getTemporaryDirectory();
      final int sampleMs = kVideoSampleInterval.inMilliseconds;

      // Duration can hang or be unreported on some devices/codecs, so it's
      // best-effort. If unknown (0), sweep up to the cap and stop once frames
      // stop extracting (i.e. we've walked past the end of the clip).
      final Duration duration = await _videoDuration(filePath);
      final int byDuration = duration.inMilliseconds ~/ sampleMs;
      final bool durationKnown = byDuration > 0;
      final int totalFrames =
          (durationKnown ? byDuration : _kMaxFrames).clamp(1, _kMaxFrames);

      int consecutiveMisses = 0;
      for (int i = 0; i < totalFrames; i++) {
        final int timeMs = i * sampleMs;
        final ({PoseModel? pose, String? framePath}) frame =
            await _detectAtTime(detector, filePath, timeMs, tempDir.path, i);

        // When we don't know the length, treat a run of failed extractions as
        // end-of-video so we don't spin to the cap on a short clip.
        if (frame.framePath == null) {
          consecutiveMisses++;
          if (!durationKnown && i > 0 && consecutiveMisses >= 3) {
            yield VideoProcessingProgress(
              currentFrame: totalFrames,
              totalFrames: totalFrames,
            );
            break;
          }
        } else {
          consecutiveMisses = 0;
        }

        yield VideoProcessingProgress(
          currentFrame: i + 1,
          totalFrames: totalFrames,
          pose: frame.pose,
          framePath: frame.framePath,
        );
      }
    } catch (e) {
      throw VideoException('Failed to process video: $e');
    } finally {
      await detector.close();
    }
  }

  /// Best-effort clip duration. Returns [Duration.zero] if the player can't open
  /// the file in time (the caller then falls back to a bounded sweep) rather
  /// than blocking the whole pipeline on a stuck `initialize()`.
  Future<Duration> _videoDuration(String filePath) async {
    final VideoPlayerController controller = VideoPlayerController.file(
      File(filePath),
    );
    try {
      await controller.initialize().timeout(const Duration(seconds: 12));
      return controller.value.duration;
    } catch (_) {
      return Duration.zero;
    } finally {
      await controller.dispose();
    }
  }

  /// Extracts a JPEG at [timeMs], decodes its size, and detects a pose.
  /// Returns the (nullable) pose and the frame's image path so the UI can draw
  /// the skeleton over the real frame.
  Future<({PoseModel? pose, String? framePath})> _detectAtTime(
    PoseDetector detector,
    String videoPath,
    int timeMs,
    String tempPath,
    int index,
  ) async {
    // Frame extraction is per-frame fail-soft: a stuck or failed extraction
    // returns null for this frame instead of hanging or aborting the clip.
    String? framePath;
    try {
      framePath = await VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: '$tempPath/frame_$index.jpg',
        imageFormat: ImageFormat.JPEG,
        maxHeight: 480,
        timeMs: timeMs,
        quality: 75,
      ).timeout(const Duration(seconds: 10));
    } catch (_) {
      return (pose: null, framePath: null);
    }
    if (framePath == null) return (pose: null, framePath: null);

    try {
      final File frameFile = File(framePath);
      final ui.Size size = await _decodeSize(await frameFile.readAsBytes());
      final List<Pose> poses = await detector.processImage(
        InputImage.fromFilePath(framePath),
      );
      if (poses.isEmpty) return (pose: null, framePath: framePath);

      return (
        pose: PoseModel.fromMLKitPose(
          poses.first,
          imageSize: size,
          source: PoseSource.videoFile,
        ),
        framePath: framePath,
      );
    } catch (_) {
      // Frame extracted but decode/detection failed — keep the image, no pose.
      return (pose: null, framePath: framePath);
    }
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

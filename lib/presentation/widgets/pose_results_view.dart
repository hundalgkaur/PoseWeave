import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/domain/entities/landmark_entity.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/pose_overlay_painter.dart';
import 'package:share_plus/share_plus.dart';

/// Results of a pose analysis run: scrub the detected frames, see the skeleton
/// and per-landmark coordinates, and export the data (plus the source video, if
/// this came from a recorded clip). Shared by the gallery and camera-recording
/// flows.
class PoseResultsView extends StatefulWidget {
  const PoseResultsView({
    required this.poses,
    required this.frameCount,
    super.key,
    this.videoPath,
    this.framePaths = const <String>[],
    this.onRestart,
    this.restartLabel = 'Try again',
  });

  final List<PoseEntity> poses;
  final int frameCount;

  /// Source video, bundled into the export when present.
  final String? videoPath;

  /// Extracted frame images, index-aligned with [poses]. When present, the
  /// skeleton is drawn over the real frame instead of a black panel.
  final List<String> framePaths;
  final VoidCallback? onRestart;
  final String restartLabel;

  @override
  State<PoseResultsView> createState() => _PoseResultsViewState();
}

class _PoseResultsViewState extends State<PoseResultsView> {
  int _index = 0;
  Timer? _player;

  bool get _playing => _player != null;

  /// Steps through the analyzed frames at the sample rate — the extracted
  /// frames are the video at ~5 FPS, so this "plays" it with the overlay.
  void _togglePlay() {
    if (_playing) {
      setState(() {
        _player!.cancel();
        _player = null;
      });
      return;
    }
    setState(() {
      _player = Timer.periodic(const Duration(milliseconds: 200), (_) {
        setState(() => _index = (_index + 1) % widget.poses.length);
      });
    });
  }

  void _seek(int i) {
    if (_playing) _togglePlay(); // pause when the user scrubs
    setState(() => _index = i);
  }

  @override
  void dispose() {
    _player?.cancel();
    super.dispose();
  }

  String? _frameFor(int i) {
    if (i >= widget.framePaths.length) return null;
    final String p = widget.framePaths[i];
    return p.isNotEmpty && File(p).existsSync() ? p : null;
  }

  Future<void> _export() async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final Either<Failure, String> result =
        await getIt<PoseRepository>().exportPosesToJson(widget.poses);
    if (!mounted) return;
    result.fold(
      (Failure f) => messenger.showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
      (String jsonPath) {
        final List<XFile> files = <XFile>[
          XFile(jsonPath),
          // Bundle the recorded clip so video + data stay together.
          if (widget.videoPath != null && File(widget.videoPath!).existsSync())
            XFile(widget.videoPath!),
        ];
        Share.shareXFiles(files, subject: 'PoseWeave export');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.poses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.person_off,
              color: AppColors.onSurfaceVariant,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              'No poses detected in ${widget.frameCount} frames',
              style: AppTheme.mono(color: AppColors.onSurfaceVariant),
            ),
            if (widget.onRestart != null) ...<Widget>[
              const SizedBox(height: 16),
              _restartButton(),
            ],
          ],
        ),
      );
    }

    final PoseEntity pose = widget.poses[_index];
    final String? framePath = _frameFor(_index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3 / 4,
          child: GlassPanel(
            padding: EdgeInsets.zero,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                // The real video frame this pose was detected from. BoxFit
                // .contain matches the painter's aspect-preserving letterbox,
                // so the skeleton lands on the body.
                if (framePath != null)
                  Image.file(File(framePath), fit: BoxFit.contain),
                CustomPaint(
                  painter: PoseOverlayPainter(
                    landmarks: pose.landmarks,
                    imageSize: pose.imageSize ?? const Size(1, 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
              color: AppColors.primary,
              onPressed: widget.poses.length > 1 ? _togglePlay : null,
            ),
            Text(
              'FRM ${_index + 1}/${widget.poses.length}',
              style: AppTheme.mono(color: AppColors.primary, fontSize: 12),
            ),
            Expanded(
              child: Slider(
                value: _index.toDouble(),
                max: (widget.poses.length - 1).toDouble(),
                divisions:
                    widget.poses.length > 1 ? widget.poses.length - 1 : null,
                activeColor: AppColors.primaryContainer,
                onChanged: (double v) => _seek(v.round()),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Text('LANDMARK COORDINATES', style: AppTheme.labelCaps()),
            const Spacer(),
            if (widget.videoPath != null)
              Text('+ VIDEO', style: AppTheme.labelCaps(fontSize: 10)),
            IconButton(
              tooltip: 'Export ${widget.poses.length} poses as JSON'
                  '${widget.videoPath != null ? ' + video' : ''}',
              icon:
                  const Icon(Icons.download, color: AppColors.primary, size: 20),
              onPressed: _export,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: GlassPanel(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.builder(
              itemCount: pose.landmarks.length,
              itemBuilder: (BuildContext context, int i) =>
                  _LandmarkRow(landmark: pose.landmarks[i]),
            ),
          ),
        ),
        if (widget.onRestart != null) ...<Widget>[
          const SizedBox(height: 8),
          _restartButton(),
        ],
      ],
    );
  }

  Widget _restartButton() => FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
        onPressed: widget.onRestart,
        child: Text(widget.restartLabel),
      );
}

class _LandmarkRow extends StatelessWidget {
  const _LandmarkRow({required this.landmark});
  final LandmarkEntity landmark;

  @override
  Widget build(BuildContext context) {
    final bool low = landmark.confidence < 0.5;
    final Color dotColor = low ? AppColors.error : AppColors.primaryContainer;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: <Widget>[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              landmark.type.name,
              style: AppTheme.mono(fontSize: 12, color: AppColors.onSurface),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              'X ${landmark.x.toStringAsFixed(3)}  '
              'Y ${landmark.y.toStringAsFixed(3)}  '
              'Z ${(landmark.z ?? 0).toStringAsFixed(3)}',
              textAlign: TextAlign.right,
              style: AppTheme.mono(
                fontSize: 11,
                color: low ? AppColors.error : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

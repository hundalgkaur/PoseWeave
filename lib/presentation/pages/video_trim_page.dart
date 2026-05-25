import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:video_trimmer/video_trimmer.dart';

/// Trims a picked video down to a start/end range before analysis. Pops the
/// trimmed file path back to the caller (or null if cancelled). Uses
/// `video_trimmer`'s native (no-ffmpeg) trimming.
class VideoTrimPage extends StatefulWidget {
  const VideoTrimPage({required this.sourcePath, super.key});

  final String sourcePath;

  @override
  State<VideoTrimPage> createState() => _VideoTrimPageState();
}

class _VideoTrimPageState extends State<VideoTrimPage> {
  final Trimmer _trimmer = Trimmer();
  double _start = 0;
  double _end = 0;
  bool _playing = false;
  bool _loaded = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _trimmer.loadVideo(videoFile: File(widget.sourcePath));
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    // Fall back to the full clip if the range wasn't dragged.
    final double durMs = (_trimmer.videoPlayerController?.value.duration
                .inMilliseconds ??
            0)
        .toDouble();
    final double end = _end > _start ? _end : (durMs > 0 ? durMs : _start + 1);
    try {
      await _trimmer.saveTrimmedVideo(
        startValue: _start,
        endValue: end,
        // The package's default filename embeds a timestamp with ":" which is
        // an illegal char on Android and makes the save throw — pass a clean
        // name to avoid it.
        videoFileName: 'poseweave_trim_${DateTime.now().millisecondsSinceEpoch}',
        onSave: (String? outputPath) {
          if (!mounted) return;
          Navigator.of(context).pop(outputPath ?? widget.sourcePath);
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Trim failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: const AppTopBar(title: 'Trim Video'),
      body: SafeArea(
        child: !_loaded
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final bool playing =
                            await _trimmer.videoPlaybackControl(
                          startValue: _start,
                          endValue: _end,
                        );
                        if (mounted) setState(() => _playing = playing);
                      },
                      child: VideoViewer(trimmer: _trimmer),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TrimViewer(
                      trimmer: _trimmer,
                      viewerHeight: 50,
                      viewerWidth: MediaQuery.of(context).size.width,
                      maxVideoLength: const Duration(seconds: 30),
                      onChangeStart: (double v) => _start = v,
                      onChangeEnd: (double v) => _end = v,
                      onChangePlaybackState: (bool p) {
                        if (mounted) setState(() => _playing = p);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    _playing ? Icons.pause : Icons.play_arrow,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryContainer,
                        foregroundColor: AppColors.onPrimary,
                      ),
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.content_cut),
                      label: Text(
                        _saving ? 'Trimming…' : 'TRIM & ANALYZE',
                        style: AppTheme.labelCaps(color: AppColors.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

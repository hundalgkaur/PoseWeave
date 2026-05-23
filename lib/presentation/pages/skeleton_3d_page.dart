import 'dart:math' as math;

import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/core/sample_pose.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/repositories/pose_repository.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/joint_angles_panel.dart';
import 'package:poseweave/presentation/widgets/skeleton_3d_painter.dart';
import 'package:share_plus/share_plus.dart';

/// Gesture-controlled 3D view of a pose with a live joint-angle panel.
/// Pass a [PoseEntity] (e.g. the most recent detection); falls back to a
/// built-in sample pose so the screen is never empty.
class Skeleton3DPage extends StatefulWidget {
  const Skeleton3DPage({super.key, this.pose});

  final PoseEntity? pose;

  @override
  State<Skeleton3DPage> createState() => _Skeleton3DPageState();
}

class _Skeleton3DPageState extends State<Skeleton3DPage>
    with SingleTickerProviderStateMixin {
  late final PoseEntity _pose = widget.pose ?? sampleStandingPose();
  late final Ticker _ticker;

  double _rotationY = 0.4;
  double _rotationX = 0;
  double _zoom = 1;
  double _zoomAtGestureStart = 1;
  bool _autoRotate = false;
  Duration _lastTick = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  void _onTick(Duration elapsed) {
    final double dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    setState(() => _rotationY += 0.6 * dt); // ~34°/sec
  }

  void _toggleAutoRotate() {
    setState(() => _autoRotate = !_autoRotate);
    if (_autoRotate) {
      _lastTick = Duration.zero;
      _ticker.start();
    } else {
      _ticker.stop();
    }
  }

  void _reset() {
    if (_autoRotate) _toggleAutoRotate();
    setState(() {
      _rotationY = 0.4;
      _rotationX = 0;
      _zoom = 1;
    });
  }

  Future<void> _export() async {
    final Either<Failure, String> result = await getIt<PoseRepository>()
        .exportPosesToJson(<PoseEntity>[_pose]);
    if (!mounted) return;
    result.fold(
      (Failure f) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(f.message), backgroundColor: AppColors.error),
      ),
      (String path) => Share.shareXFiles(<XFile>[
        XFile(path),
      ], subject: 'PoseWeave pose export'),
    );
  }

  void _onScaleStart(ScaleStartDetails d) => _zoomAtGestureStart = _zoom;

  void _onScaleUpdate(ScaleUpdateDetails d) {
    setState(() {
      _rotationY += d.focalPointDelta.dx * 0.01;
      _rotationX = (_rotationX + d.focalPointDelta.dy * 0.01).clamp(
        -math.pi / 4,
        math.pi / 4,
      );
      if (d.scale != 1.0) {
        _zoom = (_zoomAtGestureStart * d.scale).clamp(0.5, 2.0);
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('3D Skeleton'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const _PerspectiveGrid(),
            CustomPaint(
              painter: Skeleton3DPainter(
                landmarks: _pose.landmarks,
                rotationY: _rotationY,
                rotationX: _rotationX,
                zoom: _zoom,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: JointAnglesPanel(pose: _pose),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 96),
                child: _GestureHint(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _Dock(
                  autoRotate: _autoRotate,
                  onReset: _reset,
                  onToggleAutoRotate: _toggleAutoRotate,
                  onExport: _export,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GestureHint extends StatelessWidget {
  const _GestureHint();

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.swipe, size: 16, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            'Drag to rotate • pinch to zoom',
            style: AppTheme.mono(
              fontSize: 12,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dock extends StatelessWidget {
  const _Dock({
    required this.autoRotate,
    required this.onReset,
    required this.onToggleAutoRotate,
    required this.onExport,
  });

  final bool autoRotate;
  final VoidCallback onReset;
  final VoidCallback onToggleAutoRotate;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      borderRadius: 999,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _DockButton(icon: Icons.restart_alt, label: 'RESET', onTap: onReset),
          _DockButton(
            icon: Icons.threesixty,
            label: 'AUTO',
            active: autoRotate,
            onTap: onToggleAutoRotate,
          ),
          _DockButton(icon: Icons.download, label: 'EXPORT', onTap: onExport),
        ],
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color color = active ? AppColors.primary : AppColors.onSurfaceVariant;
    return TextButton(
      onPressed: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.labelCaps(color: color, fontSize: 9)),
        ],
      ),
    );
  }
}

/// Faint receding floor grid for atmosphere (purely decorative).
class _PerspectiveGrid extends StatelessWidget {
  const _PerspectiveGrid();

  @override
  Widget build(BuildContext context) {
    return const IgnorePointer(
      child: CustomPaint(painter: _GridPainter(), size: Size.infinite),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint =
        Paint()
          ..color = AppColors.primaryContainer.withValues(alpha: 0.08)
          ..strokeWidth = 1;
    const int lines = 10;
    final double horizon = size.height * 0.55;
    for (int i = 1; i <= lines; i++) {
      final double t = i / lines;
      final double y = horizon + (size.height - horizon) * t * t;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (int i = 0; i <= lines; i++) {
      final double x = size.width * i / lines;
      canvas.drawLine(Offset(x, horizon), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) => false;
}

import 'package:flutter/material.dart';
import 'package:poseweave/core/app_settings.dart';
import 'package:poseweave/core/camera_diagnostics.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// Tiny on-device readout of the camera→ML Kit pipeline (frames/poses/format)
/// so we can diagnose detection without USB logcat. Gated by
/// [AppSettings.debugHud]; reads the diagnostics stream directly (a deliberate
/// debug-only carve-out of the "state via bloc" rule).
class DetectionDebugHud extends StatelessWidget {
  const DetectionDebugHud({required this.diagnostics, super.key});

  final Stream<CameraDiagnostics> diagnostics;

  @override
  Widget build(BuildContext context) {
    if (!AppSettings.debugHud) return const SizedBox.shrink();
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 56),
          child: StreamBuilder<CameraDiagnostics>(
            stream: diagnostics,
            builder: (BuildContext context, AsyncSnapshot<CameraDiagnostics> s) {
              final CameraDiagnostics d = s.data ?? const CameraDiagnostics();
              // found>0 = detection works; sent>0 found:0 = bad conversion/rotation;
              // recv>0 sent:0 = frames rejected; err set = ML Kit threw.
              final bool ok = d.posesFound > 0;
              return IgnorePointer(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: ok ? AppColors.primary : AppColors.warning,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('DETECT DEBUG',
                          style: AppTheme.labelCaps(
                              fontSize: 8,
                              color: ok
                                  ? AppColors.primary
                                  : AppColors.warning)),
                      const SizedBox(height: 2),
                      Text('fmt:${d.lastFormatRaw ?? '-'} planes:${d.lastPlaneCount}',
                          style: AppTheme.mono(
                              fontSize: 10, color: AppColors.onSurface)),
                      Text(
                          'recv:${d.framesReceived} sent:${d.framesSentToDetector} found:${d.posesFound}',
                          style: AppTheme.mono(
                              fontSize: 10, color: AppColors.onSurface)),
                      if (d.lastError != null)
                        SizedBox(
                          width: 200,
                          child: Text('err:${d.lastError}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTheme.mono(
                                  fontSize: 9, color: AppColors.error)),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

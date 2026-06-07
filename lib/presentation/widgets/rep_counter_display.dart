import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/exercise.dart';
import 'package:poseweave/domain/entities/rep_count_result.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// Shared rep readout used by both the live counter and the video summary:
/// a big monospace rep count, the exercise label, the current phase, a form
/// chip, and any form issues. Bio-feedback colors (cyan/amber/coral) follow the
/// design system's reservation for form feedback.
class RepCounterDisplay extends StatelessWidget {
  const RepCounterDisplay({
    required this.exercise,
    required this.result,
    super.key,
  });

  final Exercise exercise;
  final RepCountResult result;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(exercise.label.toUpperCase(), style: AppTheme.labelCaps()),
          const SizedBox(height: 8),
          Center(
            // FittedBox keeps the big count from clipping under a large OS
            // font scale.
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${result.repCount}',
                maxLines: 1,
                style: AppTheme.mono(
                  color: AppColors.primary,
                  fontSize: 72,
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Center(child: Text('REPS', style: AppTheme.labelCaps(fontSize: 10))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _Chip(label: 'PHASE', value: _phaseLabel(result.phase)),
              _Chip(
                label: 'FORM',
                value: _formLabel(result.formQuality),
                color: _formColor(result.formQuality),
              ),
              _Chip(label: 'SIGNAL', value: result.signalValue.toStringAsFixed(0)),
            ],
          ),
          if (result.formIssues.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            for (final String issue in result.formIssues)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 14,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        issue,
                        style: AppTheme.mono(
                          color: AppColors.onSurface,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  static String _phaseLabel(RepPhase phase) {
    switch (phase) {
      case RepPhase.up:
        return 'UP';
      case RepPhase.down:
        return 'DOWN';
      case RepPhase.unknown:
        return '—';
    }
  }

  static String _formLabel(FormQuality q) {
    switch (q) {
      case FormQuality.good:
        return 'GOOD';
      case FormQuality.partial:
        return 'PARTIAL';
      case FormQuality.poor:
        return 'POOR';
      case FormQuality.unknown:
        return '—';
    }
  }

  static Color _formColor(FormQuality q) {
    switch (q) {
      case FormQuality.good:
        return AppColors.success;
      case FormQuality.partial:
        return AppColors.warning;
      case FormQuality.poor:
        return AppColors.error;
      case FormQuality.unknown:
        return AppColors.onSurfaceVariant;
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(label, style: AppTheme.labelCaps(fontSize: 9)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTheme.mono(
            color: color ?? AppColors.onSurface,
            fontSize: 16,
            weight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

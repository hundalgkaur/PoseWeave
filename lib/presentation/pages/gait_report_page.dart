import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/radial_gauge.dart';

/// Gait Analysis report (design/gait_analysis_report). Renders gait parameters
/// computed by `GaitAnalyzer`. Soft estimates (speed, leg rotation) carry a
/// "~ EST" tag, since 2D monocular video can't measure them exactly.
class GaitReportPage extends StatelessWidget {
  const GaitReportPage({required this.params, super.key});

  final GaitParameters params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gait Analysis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            _keyMetrics(),
            const SizedBox(height: 16),
            _upperBody(),
            const SizedBox(height: 16),
            _lowerLimb(),
            const SizedBox(height: 16),
            _gaitCycle(),
            const SizedBox(height: 12),
            Text(
              'Analyzed ${params.framesAnalyzed} frames. '
              '“~ EST” values are estimated from 2D video.',
              style: AppTheme.labelCaps(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: AppTheme.labelCaps()),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _keyMetrics() {
    return _section(
      'KEY METRICS',
      Row(
        children: <Widget>[
          Expanded(
            child: _MetricCard(
              label: 'Speed',
              value: params.speedMps.toStringAsFixed(1),
              unit: 'm/s',
              estimated: true,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MetricCard(
              label: 'Cadence',
              value: params.cadenceSpm.round().toString(),
              unit: 'spm',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _MetricCard(
              label: 'Symmetry',
              value: params.symmetryPercent.round().toString(),
              unit: '%',
            ),
          ),
        ],
      ),
    );
  }

  Widget _upperBody() {
    return _section(
      'UPPER BODY METRICS',
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RadialGauge(valueDeg: params.leftArmSwingDeg, label: 'L Arm Swing'),
          Container(width: 1, height: 48, color: AppColors.outlineVariant),
          RadialGauge(valueDeg: params.rightArmSwingDeg, label: 'R Arm Swing'),
        ],
      ),
    );
  }

  Widget _lowerLimb() {
    return _section(
      'LOWER LIMB BIOMETRICS',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Leg Rotation (In/Out)',
                style: AppTheme.labelCaps(color: AppColors.outline),
              ),
              const SizedBox(width: 6),
              const _EstTag(),
            ],
          ),
          const SizedBox(height: 8),
          _LegRotationRow(
            leg: 'Left Leg',
            inDeg: params.leftLegRotInDeg,
            outDeg: params.leftLegRotOutDeg,
          ),
          const SizedBox(height: 6),
          _LegRotationRow(
            leg: 'Right Leg',
            inDeg: params.rightLegRotInDeg,
            outDeg: params.rightLegRotOutDeg,
          ),
          const Divider(color: AppColors.outlineVariant, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Knee Flexion (Max)',
                style: AppTheme.labelCaps(color: AppColors.outline),
              ),
              Text(
                '${params.kneeFlexionMaxDeg.round()}°',
                style: AppTheme.mono(
                  fontSize: 28,
                  color: AppColors.primary,
                  weight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gaitCycle() {
    final int stance = params.stancePercent.round();
    final int swing = params.swingPercent.round();
    return _section(
      'GAIT CYCLE TIMELINE',
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 32,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: stance.clamp(1, 99),
                child: ColoredBox(
                  color: AppColors.primaryContainer.withValues(alpha: 0.2),
                  child: Center(
                    child: Text(
                      'STANCE ($stance%)',
                      style: AppTheme.mono(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: swing.clamp(1, 99),
                child: ColoredBox(
                  color: AppColors.surfaceContainerHighest,
                  child: Center(
                    child: Text(
                      'SWING ($swing%)',
                      style: AppTheme.mono(
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
    this.estimated = false,
  });
  final String label;
  final String value;
  final String unit;
  final bool estimated;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: <Widget>[
          Text(label, style: AppTheme.labelCaps(fontSize: 9)),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.mono(
              fontSize: 28,
              color: AppColors.primary,
              weight: FontWeight.w500,
            ),
          ),
          Text(
            unit,
            style: AppTheme.mono(
              fontSize: 11,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (estimated) ...<Widget>[
            const SizedBox(height: 2),
            const _EstTag(),
          ],
        ],
      ),
    );
  }
}

class _LegRotationRow extends StatelessWidget {
  const _LegRotationRow({
    required this.leg,
    required this.inDeg,
    required this.outDeg,
  });
  final String leg;
  final double inDeg;
  final double outDeg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(leg, style: Theme.of(context).textTheme.bodyMedium),
          Row(
            children: <Widget>[
              _inOut('IN', inDeg),
              const SizedBox(width: 16),
              _inOut('OUT', outDeg),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inOut(String label, double deg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(label, style: AppTheme.labelCaps(fontSize: 9)),
        Text(
          '${deg.round()}°',
          style: AppTheme.mono(fontSize: 14, color: AppColors.primary),
        ),
      ],
    );
  }
}

class _EstTag extends StatelessWidget {
  const _EstTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      child: const Text(
        '~ EST',
        style: TextStyle(
          color: AppColors.warning,
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

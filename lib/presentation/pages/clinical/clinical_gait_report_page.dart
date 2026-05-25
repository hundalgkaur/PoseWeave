import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/core/utils/clinical_assessment.dart';
import 'package:poseweave/core/utils/gait_analyzer.dart';
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';
import 'package:poseweave/domain/entities/pose_entity.dart';
import 'package:poseweave/domain/entities/recommendation_entity.dart';
import 'package:poseweave/injection.dart';
import 'package:poseweave/presentation/bloc/pose_bloc.dart';
import 'package:poseweave/presentation/bloc/pose_event.dart';
import 'package:poseweave/presentation/bloc/pose_state.dart';
import 'package:poseweave/presentation/bloc/recommendations_bloc.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/clinical/clinical_bottom_nav.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/clinical/rom_table.dart';
import 'package:poseweave/presentation/widgets/clinical/status_metric_pod.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/recommendations_panel.dart';
import 'package:printing/printing.dart';

/// Clinical gait report: picks a clip, runs the existing `GaitAnalyzer` +
/// `SegmentAggregator`, then renders a clinical layout — status pods
/// (NORMAL/WARNING/CRITICAL via `ClinicalAssessment`), ROM table, rule-based
/// diagnostic findings, AI recommendations (BYOK), referral (mock) + PDF export.
class ClinicalGaitReportPage extends StatelessWidget {
  const ClinicalGaitReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<PoseBloc>(
          create: (_) =>
              getIt<PoseBloc>()..add(const PoseEvent.pickAndAnalyzeVideo()),
        ),
        BlocProvider<RecommendationsBloc>(
          create: (_) => getIt<RecommendationsBloc>(),
        ),
      ],
      child: const _GaitView(),
    );
  }
}

class _GaitView extends StatefulWidget {
  const _GaitView();

  @override
  State<_GaitView> createState() => _GaitViewState();
}

class _GaitViewState extends State<_GaitView> {
  // Retain the last completed analysis. The same PoseBloc drives both video
  // analysis and PDF generation, so when "Export PDF" fires the bloc leaves
  // PoseVideoComplete for PoseReportGenerating/Ready. Without caching, the
  // builder would fall through to the picker, unmounting the report and its
  // export listener — so the share sheet would never open. Keeping the report
  // mounted across the report states is what makes the export button work.
  PoseVideoComplete? _lastComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Clinical Gait Report'),
      bottomNavigationBar: const ClinicalBottomNav(current: 3),
      body: SafeArea(
        child: BlocConsumer<PoseBloc, PoseState>(
          listener: (BuildContext context, PoseState state) {
            if (state is PoseVideoComplete) {
              setState(() => _lastComplete = state);
            } else if (state is PoseError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (BuildContext context, PoseState state) {
            if (state is PoseVideoProcessing) {
              return _Processing(
                progress: state.progress,
                frame: state.framesProcessed,
              );
            }
            final PoseVideoComplete? complete =
                state is PoseVideoComplete ? state : _lastComplete;
            if (complete != null) {
              if (complete.poses.isEmpty) {
                return _Prompt(
                  note: 'No human detected in that clip. Try a clearer, '
                      'side-on walking video with the full body in frame.',
                  onPick: () => context
                      .read<PoseBloc>()
                      .add(const PoseEvent.pickAndAnalyzeVideo()),
                );
              }
              return _Report(
                params: GaitAnalyzer.analyze(complete.poses),
                poses: complete.poses,
                framePaths: complete.framePaths,
              );
            }
            return _Prompt(
              onPick: () => context
                  .read<PoseBloc>()
                  .add(const PoseEvent.pickAndAnalyzeVideo()),
            );
          },
        ),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({
    required this.params,
    required this.poses,
    required this.framePaths,
  });

  final GaitParameters params;
  final List<PoseEntity> poses;
  final List<String> framePaths;

  @override
  Widget build(BuildContext context) {
    final List<ClinicalMetric> metrics = ClinicalAssessment.metrics(params);
    final List<String> findings = ClinicalAssessment.findings(params);
    final Map<String, SegmentSummary> segments =
        SegmentAggregator.summarize(poses);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const PatientHeader(patient: ClinicalPatient.demo, detailed: true),
        const SizedBox(height: 12),
        _MetadataPods(params: params),
        const SizedBox(height: 16),
        Text('CLINICAL METRICS', style: AppTheme.labelCaps()),
        const SizedBox(height: 8),
        // IntrinsicHeight gives the Row a bounded height so the pods can stretch
        // to equal height; a stretching Row directly in a ListView would throw.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (int i = 0; i < metrics.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: StatusMetricPod(metric: metrics[i])),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        RomTable(segments: segments),
        const SizedBox(height: 16),
        _Findings(findings: findings),
        const SizedBox(height: 16),
        _Recommendations(params: params, poses: poses),
        const SizedBox(height: 16),
        Text(
          'Reference ranges are illustrative (typical adult walking), not a '
          'medical standard. “~ est.” values come from 2D video. This is not a '
          'medical device.',
          style: AppTheme.labelCaps(fontSize: 9),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Referral authorization is mocked in this demo.',
                      style: AppTheme.mono(
                          color: AppColors.onSurface, fontSize: 12),
                    ),
                  ),
                ),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('REFER'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExportPdfButton(
                params: params,
                poses: poses,
                framePaths: framePaths,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetadataPods extends StatelessWidget {
  const _MetadataPods({required this.params});
  final GaitParameters params;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final bool anyCritical = ClinicalAssessment.metrics(params)
        .any((ClinicalMetric m) => m.status == ClinicalStatus.critical);
    final bool anyWarning = ClinicalAssessment.metrics(params)
        .any((ClinicalMetric m) => m.status == ClinicalStatus.warning);
    final String overall = anyCritical
        ? 'REVIEW'
        : (anyWarning ? 'MONITOR' : 'WITHIN RANGE');
    return GlassPanel(
      child: Wrap(
        spacing: 24,
        runSpacing: 8,
        children: <Widget>[
          _meta('Date', date),
          _meta('Observer', ClinicalPatient.demo.observer),
          _meta('Protocol', ClinicalPatient.demo.protocol),
          _meta('Status', overall),
          _meta('Frames', params.framesAnalyzed.toString()),
        ],
      ),
    );
  }

  Widget _meta(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label.toUpperCase(), style: AppTheme.labelCaps(fontSize: 8)),
          const SizedBox(height: 2),
          Text(value,
              style: AppTheme.mono(fontSize: 12, color: AppColors.onSurface)),
        ],
      );
}

class _Findings extends StatelessWidget {
  const _Findings({required this.findings});
  final List<String> findings;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('AUTOMATED DIAGNOSTIC FINDINGS', style: AppTheme.labelCaps()),
          const SizedBox(height: 12),
          if (findings.isEmpty)
            Row(
              children: <Widget>[
                const Icon(Icons.check_circle_outline,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'All headline metrics within reference range.',
                    style: AppTheme.mono(
                        fontSize: 12, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            )
          else
            for (final String f in findings)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(Icons.warning_amber_rounded,
                        size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(f,
                          style: AppTheme.mono(
                              fontSize: 12, color: AppColors.onSurface)),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _Recommendations extends StatelessWidget {
  const _Recommendations({required this.params, required this.poses});
  final GaitParameters params;
  final List<PoseEntity> poses;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (BuildContext context, RecommendationsState state) {
        return GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('CLINICAL RECOMMENDATIONS', style: AppTheme.labelCaps()),
              const SizedBox(height: 12),
              if (state is RecommendationsInitial)
                OutlinedButton.icon(
                  icon:
                      const Icon(Icons.auto_awesome, color: AppColors.primary),
                  label: Text('Generate recommendations',
                      style:
                          AppTheme.mono(color: AppColors.primary, fontSize: 13)),
                  onPressed: () => context.read<RecommendationsBloc>().add(
                        RecommendationsEvent.fetch(
                          gait: params,
                          segments: SegmentAggregator.summarize(poses),
                        ),
                      ),
                )
              else if (state is RecommendationsLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryContainer,
                      ),
                    ),
                  ),
                )
              else if (state is RecommendationsLoaded)
                RecommendationsPanel(items: state.items)
              else if (state is RecommendationsError)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(state.message,
                        style: AppTheme.mono(
                            color: AppColors.error, fontSize: 12)),
                    if (state.needsKey) ...<Widget>[
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.settings),
                        child: const Text('Open Settings'),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ExportPdfButton extends StatelessWidget {
  const _ExportPdfButton({
    required this.params,
    required this.poses,
    required this.framePaths,
  });

  final GaitParameters params;
  final List<PoseEntity> poses;
  final List<String> framePaths;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PoseBloc, PoseState>(
      listener: (BuildContext context, PoseState state) async {
        if (state is PoseReportReady) {
          await Printing.sharePdf(
            bytes: await File(state.filePath).readAsBytes(),
            filename: state.filePath.split(Platform.pathSeparator).last,
          );
        } else if (state is PoseReportFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (BuildContext context, PoseState state) {
        final bool generating = state is PoseReportGenerating;
        return FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryContainer,
            foregroundColor: AppColors.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: generating
              ? null
              : () {
                  final RecommendationsState rec =
                      context.read<RecommendationsBloc>().state;
                  final List<String> recLines = rec is RecommendationsLoaded
                      ? rec.items
                          .map((RecommendationEntity r) => r.asLine)
                          .toList()
                      : <String>[];
                  context.read<PoseBloc>().add(
                        PoseEvent.generateReport(
                          ReportData(
                            generatedAt: DateTime.now(),
                            exerciseType: 'Clinical gait analysis',
                            gait: params,
                            segments: SegmentAggregator.summarize(poses),
                            framePaths: framePaths,
                            recommendations: recLines,
                          ),
                        ),
                      );
                },
          icon: generating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.picture_as_pdf),
          label: Text(
            generating ? 'Generating…' : 'EXPORT PDF',
            style: AppTheme.labelCaps(color: AppColors.onPrimary),
          ),
        );
      },
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.onPick, this.note});
  final VoidCallback onPick;

  /// Optional context line (e.g. shown after a clip yielded no detections).
  final String? note;

  @override
  Widget build(BuildContext context) {
    final bool isEmptyResult = note != null;
    return Center(
      child: GestureDetector(
        onTap: onPick,
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(isEmptyResult ? Icons.person_off_outlined : Icons.directions_walk,
                  color: isEmptyResult ? AppColors.warning : AppColors.primary,
                  size: 48),
              const SizedBox(height: 16),
              Text(isEmptyResult ? 'No human detected' : 'Select a walking video',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(
                note ?? 'Side-on, full body, a few steps.',
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                    color: AppColors.onSurfaceVariant, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Text('TAP TO PICK A VIDEO', style: AppTheme.labelCaps(fontSize: 9)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Processing extends StatelessWidget {
  const _Processing({required this.progress, required this.frame});
  final double progress;
  final int frame;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Analyzing gait · frame $frame',
              style: AppTheme.mono(color: AppColors.onSurface)),
          const SizedBox(height: 16),
          SizedBox(
            width: 240,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

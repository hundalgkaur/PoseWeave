import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';

/// Static builders for each section/page of the session report PDF.
class PdfPageBuilders {
  const PdfPageBuilders._();

  static const PdfColor _accent = PdfColor.fromInt(0xFF00B8D4);
  static const PdfColor _ink = PdfColor.fromInt(0xFF0D1516);
  static const PdfColor _muted = PdfColor.fromInt(0xFF5F6B6E);

  static pw.Widget _header(String title) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 16),
    padding: const pw.EdgeInsets.only(bottom: 6),
    decoration: const pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: _accent, width: 2)),
    ),
    child: pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: _ink,
      ),
    ),
  );

  static pw.Page buildCover(ReportData data) {
    return pw.Page(
      build:
          (pw.Context context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: <pw.Widget>[
                pw.Text(
                  'PoseWeave',
                  style: pw.TextStyle(
                    fontSize: 40,
                    fontWeight: pw.FontWeight.bold,
                    color: _accent,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Session Report',
                  style: const pw.TextStyle(fontSize: 20, color: _ink),
                ),
                pw.SizedBox(height: 40),
                _kv('Date', _date(data.generatedAt)),
                _kv('Exercise', data.exerciseType),
                _kv('Frames analyzed', '${data.gait.framesAnalyzed}'),
              ],
            ),
          ),
    );
  }

  static pw.Widget buildGaitMetrics(GaitParameters g) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _header('Gait Metrics'),
        _kv('Cadence', '${g.cadenceSpm.round()} steps/min'),
        _kv('Symmetry', '${g.symmetryPercent.round()}%'),
        _kv('Max knee flexion', '${g.kneeFlexionMaxDeg.round()}°'),
        _kv(
          'Arm swing (L / R)',
          '${g.leftArmSwingDeg.round()}° / ${g.rightArmSwingDeg.round()}°',
        ),
        _kv(
          'Stance / swing',
          '${g.stancePercent.round()}% / ${g.swingPercent.round()}%',
        ),
        _kv('Estimated speed', '${g.speedMps.toStringAsFixed(2)} m/s  (~est.)'),
      ],
    );
  }

  static pw.Widget buildSegmentTable(Map<String, SegmentSummary> segments) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _header('Joint Angle Summary'),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            color: _ink,
          ),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColor.fromInt(0xFFE0F7FA),
          ),
          cellStyle: const pw.TextStyle(color: _ink, fontSize: 11),
          headers: <String>['Segment', 'Avg', 'Max', 'Classification'],
          data:
              segments.values
                  .map(
                    (SegmentSummary s) => <String>[
                      s.label,
                      '${s.avgDeg.round()}°',
                      '${s.maxDeg.round()}°',
                      '${s.classification.name}${s.isRisk ? ' (!)' : ''}',
                    ],
                  )
                  .toList(),
        ),
      ],
    );
  }

  /// Embeds up to four extracted frame images (best-effort; skips missing).
  static pw.Widget? buildSnapshots(List<String> framePaths) {
    final List<pw.Widget> images = <pw.Widget>[];
    for (final String path in framePaths) {
      if (images.length >= 4) break;
      final File f = File(path);
      if (!f.existsSync()) continue;
      images.add(
        pw.ClipRRect(
          horizontalRadius: 6,
          verticalRadius: 6,
          child: pw.Image(
            pw.MemoryImage(f.readAsBytesSync()),
            width: 200,
            height: 150,
            fit: pw.BoxFit.cover,
          ),
        ),
      );
    }
    if (images.isEmpty) return null;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _header('Frame Snapshots'),
        pw.Wrap(spacing: 12, runSpacing: 12, children: images),
      ],
    );
  }

  static pw.Widget buildRecommendations(List<String> recommendations) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        _header('AI Recommendations'),
        for (int i = 0; i < recommendations.length; i++)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Text(
              '${i + 1}. ${recommendations[i]}',
              style: const pw.TextStyle(color: _ink, fontSize: 12),
            ),
          ),
      ],
    );
  }

  static pw.Widget _kv(String k, String v) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      children: <pw.Widget>[
        pw.SizedBox(
          width: 160,
          child: pw.Text(k, style: const pw.TextStyle(color: _muted, fontSize: 12)),
        ),
        pw.Text(
          v,
          style: pw.TextStyle(
            color: _ink,
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  static String _date(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
}

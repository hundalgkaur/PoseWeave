import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poseweave/core/errors/failures.dart';
import 'package:poseweave/data/models/report_data.dart';
import 'package:poseweave/data/services/pdf_page_builders.dart';

/// Builds a multi-page session report PDF and writes it to a temp file.
@LazySingleton()
class PdfReportService {
  Future<Either<Failure, String>> generateReport(ReportData data) async {
    try {
      final pw.Document doc = pw.Document();

      // Cover is its own (centered) page; the rest flow on a MultiPage.
      doc.addPage(PdfPageBuilders.buildCover(data));

      final List<pw.Widget> sections = <pw.Widget>[
        PdfPageBuilders.buildGaitMetrics(data.gait),
        pw.SizedBox(height: 24),
        PdfPageBuilders.buildSegmentTable(data.segments),
      ];
      final pw.Widget? snapshots = PdfPageBuilders.buildSnapshots(
        data.framePaths,
      );
      if (snapshots != null) {
        sections
          ..add(pw.SizedBox(height: 24))
          ..add(snapshots);
      }
      if (data.recommendations.isNotEmpty) {
        sections
          ..add(pw.SizedBox(height: 24))
          ..add(PdfPageBuilders.buildRecommendations(data.recommendations));
      }

      doc.addPage(
        pw.MultiPage(
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => sections,
        ),
      );

      final Directory dir = await getTemporaryDirectory();
      final File file = File(
        '${dir.path}/poseweave_report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await doc.save());
      return Right<Failure, String>(file.path);
    } catch (e, st) {
      debugPrint('PDF generation failed: $e\n$st');
      return Left<Failure, String>(
        PdfGenerationFailure('Could not generate PDF: $e'),
      );
    }
  }
}

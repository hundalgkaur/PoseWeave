import 'package:poseweave/core/utils/segment_aggregator.dart';
import 'package:poseweave/domain/entities/gait_parameters.dart';

/// Everything the PDF report needs, assembled by the UI and handed to
/// `PdfReportService`. Plain immutable bundle (no serialization needed).
class ReportData {
  const ReportData({
    required this.generatedAt,
    required this.exerciseType,
    required this.gait,
    required this.segments,
    this.framePaths = const <String>[],
    this.recommendations = const <String>[],
  });

  final DateTime generatedAt;
  final String exerciseType;
  final GaitParameters gait;
  final Map<String, SegmentSummary> segments;

  /// Extracted frame image paths for snapshot pages (optional).
  final List<String> framePaths;

  /// Formatted recommendation lines (filled in F3; empty otherwise).
  final List<String> recommendations;
}

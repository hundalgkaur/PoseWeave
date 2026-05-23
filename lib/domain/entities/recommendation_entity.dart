import 'package:equatable/equatable.dart';

enum Severity { low, medium, high }

/// A single physiotherapy recommendation produced by the AI from gait/segment
/// data.
class RecommendationEntity extends Equatable {
  const RecommendationEntity({
    required this.title,
    required this.detail,
    required this.severity,
    required this.bodyPart,
  });

  final String title;
  final String detail;
  final Severity severity;
  final String bodyPart;

  /// One-line form for the PDF report.
  String get asLine => '$title ($bodyPart, ${severity.name}) — $detail';

  @override
  List<Object?> get props => <Object?>[title, detail, severity, bodyPart];
}

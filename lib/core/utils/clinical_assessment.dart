import 'package:poseweave/domain/entities/gait_parameters.dart';

/// Clinical status of a metric against reference ranges.
enum ClinicalStatus { normal, warning, critical }

/// A gait metric assessed against a clinical reference range.
class ClinicalMetric {
  const ClinicalMetric({
    required this.label,
    required this.value,
    required this.unit,
    required this.reference,
    required this.status,
  });

  final String label;
  final String value;
  final String unit;
  final String reference;
  final ClinicalStatus status;
}

/// Rule-based clinical assessment of gait parameters. Pure / testable. Reference
/// ranges are illustrative (typical adult walking), not a medical standard.
class ClinicalAssessment {
  const ClinicalAssessment._();

  static ClinicalStatus cadenceStatus(double spm) {
    if (spm >= 100 && spm <= 115) return ClinicalStatus.normal;
    if (spm >= 90 && spm <= 125) return ClinicalStatus.warning;
    return ClinicalStatus.critical;
  }

  static ClinicalStatus speedStatus(double mps) {
    if (mps >= 1.20 && mps <= 1.40) return ClinicalStatus.normal;
    if (mps >= 1.00 && mps <= 1.60) return ClinicalStatus.warning;
    return ClinicalStatus.critical;
  }

  static ClinicalStatus symmetryStatus(double pct) {
    if (pct >= 95) return ClinicalStatus.normal;
    if (pct >= 85) return ClinicalStatus.warning;
    return ClinicalStatus.critical;
  }

  /// The three headline metrics with status + reference text.
  static List<ClinicalMetric> metrics(GaitParameters g) {
    return <ClinicalMetric>[
      ClinicalMetric(
        label: 'Gait Speed',
        value: g.speedMps.toStringAsFixed(2),
        unit: 'm/s',
        reference: '1.20–1.40',
        status: speedStatus(g.speedMps),
      ),
      ClinicalMetric(
        label: 'Cadence',
        value: g.cadenceSpm.round().toString(),
        unit: 'spm',
        reference: '100–115',
        status: cadenceStatus(g.cadenceSpm),
      ),
      ClinicalMetric(
        label: 'Symmetry',
        value: g.symmetryPercent.round().toString(),
        unit: '%',
        reference: '> 95',
        status: symmetryStatus(g.symmetryPercent),
      ),
    ];
  }

  /// Human-readable diagnostic findings for the out-of-range metrics. Empty when
  /// everything is within normal range.
  static List<String> findings(GaitParameters g) {
    final List<String> out = <String>[];
    final ClinicalStatus cadence = cadenceStatus(g.cadenceSpm);
    if (cadence != ClinicalStatus.normal) {
      out.add(
        'Cadence ${g.cadenceSpm.round()} spm is outside the 100–115 reference '
        'range (${cadence.name}).',
      );
    }
    final ClinicalStatus speed = speedStatus(g.speedMps);
    if (speed != ClinicalStatus.normal) {
      out.add(
        'Gait speed ${g.speedMps.toStringAsFixed(2)} m/s is outside the '
        '1.20–1.40 m/s range (${speed.name}). [~ est.]',
      );
    }
    final ClinicalStatus symmetry = symmetryStatus(g.symmetryPercent);
    if (symmetry != ClinicalStatus.normal) {
      out.add(
        'Left/right symmetry ${g.symmetryPercent.round()}% is below the >95% '
        'target (${symmetry.name}).',
      );
    }
    if (g.kneeFlexionMaxDeg < 50) {
      out.add(
        'Reduced peak knee flexion (${g.kneeFlexionMaxDeg.round()}°) — typical '
        'walking peak is ~60°.',
      );
    }
    return out;
  }
}

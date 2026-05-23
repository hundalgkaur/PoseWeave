/// Mock patient/session context for the clinical screens (UI-only — no real PHI
/// or records backend).
class ClinicalPatient {
  const ClinicalPatient({
    required this.id,
    required this.name,
    required this.ageYears,
    required this.heightCm,
    required this.weightKg,
    required this.observer,
    required this.protocol,
  });

  final String id;
  final String name;
  final int ageYears;
  final int heightCm;
  final int weightKg;
  final String observer;
  final String protocol;

  static const ClinicalPatient demo = ClinicalPatient(
    id: 'GAIT-P204',
    name: 'J. Doe',
    ageYears: 28,
    heightCm: 182,
    weightKg: 76,
    observer: 'Dr. A. Vance',
    protocol: 'Standard 10m Walk',
  );
}

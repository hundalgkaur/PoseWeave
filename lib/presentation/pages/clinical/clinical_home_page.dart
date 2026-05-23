import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/mode_selector_card.dart';

/// Clinical hub: patient context + the four diagnostic modules, all reusing the
/// existing pose pipeline under clinical chrome.
class ClinicalHomePage extends StatelessWidget {
  const ClinicalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const ClinicalPatient patient = ClinicalPatient.demo;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnostic Suite'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'End session',
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context)
                .popUntil((Route<dynamic> r) => r.settings.name == AppRoutes.home),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const PatientHeader(patient: patient, detailed: true),
            const SizedBox(height: 12),
            Text('Patient — ${patient.ageYears}y · ${patient.heightCm}cm · '
                '${patient.weightKg}kg · Observer ${patient.observer}',
                style: AppTheme.labelCaps(fontSize: 9)),
            const SizedBox(height: 16),
            Text('DIAGNOSTIC MODULES', style: AppTheme.labelCaps()),
            const SizedBox(height: 12),
            ModeSelectorCard(
              icon: Icons.monitor_heart_outlined,
              title: 'Diagnostic Live Feed',
              subtitle: 'Real-time kinematics + sensor status',
              active: true,
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.clinicalLive),
            ),
            const SizedBox(height: 16),
            ModeSelectorCard(
              icon: Icons.biotech_outlined,
              title: 'Biomechanical Analysis',
              subtitle: 'Frame-by-frame landmark metrics from a clip',
              onTap: () => Navigator.of(context)
                  .pushNamed(AppRoutes.clinicalBiomechanical),
            ),
            const SizedBox(height: 16),
            ModeSelectorCard(
              icon: Icons.view_in_ar_outlined,
              title: '3D Reconstruction',
              subtitle: 'Rotatable skeleton with kinematic readout',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.clinical3d),
            ),
            const SizedBox(height: 16),
            ModeSelectorCard(
              icon: Icons.assignment_outlined,
              title: 'Gait Report',
              subtitle: 'Status pods, ROM table & diagnostic findings',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.clinicalGait),
            ),
            const SizedBox(height: 20),
            Text(
              'Clinical Mode is a UI demo over the on-device pose pipeline. '
              'Auth, patient records, DICOM export and referral are mocked; '
              '“mm” values are uncalibrated estimates.',
              style: AppTheme.labelCaps(fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';
import 'package:poseweave/presentation/widgets/app_top_bar.dart';
import 'package:poseweave/presentation/widgets/clinical/clinical_bottom_nav.dart';
import 'package:poseweave/presentation/widgets/clinical/patient_header.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';
import 'package:poseweave/presentation/widgets/mode_selector_card.dart';

/// Clinical hub: patient context + the four diagnostic modules as cards, with
/// the shared bottom nav (no tab highlighted on the hub). Matches the
/// `clinical_home_selector` mockup, which shows module cards *and* a bottom bar.
class ClinicalHomePage extends StatelessWidget {
  const ClinicalHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    const ClinicalPatient patient = ClinicalPatient.demo;
    return Scaffold(
      // Home (in AppTopBar) returns to the main shell; Log out lives in its menu.
      appBar: const AppTopBar(title: 'Diagnostic Suite'),
      // No tab highlighted on the hub; tapping a tab opens that module.
      bottomNavigationBar: const ClinicalBottomNav(current: -1),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const PatientHeader(patient: patient, detailed: true),
            const SizedBox(height: 12),
            Text(
              'Patient — ${patient.ageYears}y · ${patient.heightCm}cm · '
              '${patient.weightKg}kg · Observer ${patient.observer}',
              style: AppTheme.labelCaps(fontSize: 9),
            ),
            const SizedBox(height: 12),
            GlassPanel(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _status('SESSION', 'ACTIVE', AppColors.success),
                  _status('CALIBRATION', '99.8%', AppColors.primary),
                  _status('ENVIRONMENT', 'OPTIMAL', AppColors.success),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('SELECT DIAGNOSTIC MODULE', style: AppTheme.labelCaps()),
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

  Widget _status(String label, String value, Color color) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label, style: AppTheme.labelCaps(fontSize: 8)),
          const SizedBox(height: 2),
          Text(value, style: AppTheme.mono(color: color, fontSize: 12)),
        ],
      );
}

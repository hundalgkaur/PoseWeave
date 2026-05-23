import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_theme.dart';
import 'package:poseweave/domain/entities/clinical_patient.dart';

/// Compact clinical patient/session strip: ID + name, optional observer/protocol.
class PatientHeader extends StatelessWidget {
  const PatientHeader({required this.patient, super.key, this.detailed = false});

  final ClinicalPatient patient;
  final bool detailed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.badge_outlined,
              size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              detailed
                  ? '${patient.id} · ${patient.name} · ${patient.ageYears}y'
                  : 'ID: ${patient.id}   ·   ${patient.name}',
              style: AppTheme.mono(fontSize: 12, color: AppColors.onSurface),
            ),
          ),
          if (detailed)
            Text(
              patient.protocol,
              style: AppTheme.labelCaps(fontSize: 9),
            ),
        ],
      ),
    );
  }
}

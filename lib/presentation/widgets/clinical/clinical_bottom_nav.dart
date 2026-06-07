import 'package:flutter/material.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/core/constants/app_routes.dart';
import 'package:poseweave/core/constants/app_theme.dart';

/// Bottom navigation shared across the clinical suite (Live / Biomechanical /
/// 3D / Gait) so a clinician can move directly between modules.
///
/// [current] is the hosting module's index (0–3), or **-1 on the Diagnostic
/// Suite hub**, where no tab is highlighted. From a module, tapping a tab uses
/// `pushReplacementNamed` (no stacking; the live camera disposes cleanly when
/// you leave it). From the hub (current -1) it uses `pushNamed`, so the hub
/// stays beneath and the top-bar back arrow returns to it.
class ClinicalBottomNav extends StatelessWidget {
  const ClinicalBottomNav({required this.current, super.key});

  final int current;

  static const List<String> _routes = <String>[
    AppRoutes.clinicalLive,
    AppRoutes.clinicalBiomechanical,
    AppRoutes.clinical3d,
    AppRoutes.clinicalGait,
  ];

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = current >= 0;
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowest,
        indicatorColor: hasSelection
            ? AppColors.primaryContainer.withValues(alpha: 0.18)
            : Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) => AppTheme.labelCaps(
            fontSize: 10,
            color: hasSelection && states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.onSurfaceVariant,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: hasSelection ? current : 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
        onDestinationSelected: (int i) {
          // Last tab is the "Hub" — always returns to the Diagnostic Suite home
          // so a clinician is never stranded inside a module.
          if (i == _routes.length) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.clinicalHome);
            return;
          }
          if (hasSelection && i == current) return;
          if (hasSelection) {
            Navigator.of(context).pushReplacementNamed(_routes[i]);
          } else {
            Navigator.of(context).pushNamed(_routes[i]);
          }
        },
        destinations: <NavigationDestination>[
          _dest(Icons.videocam_outlined, Icons.videocam, 'Live', hasSelection),
          _dest(Icons.straighten_outlined, Icons.straighten, 'Biomech', hasSelection),
          _dest(Icons.view_in_ar_outlined, Icons.view_in_ar, '3D', hasSelection),
          _dest(Icons.directions_walk_outlined, Icons.directions_walk, 'Gait', hasSelection),
          // Always-available return to the hub (never the "current" tab).
          _dest(Icons.dashboard_outlined, Icons.dashboard, 'Hub', false),
        ],
      ),
    );
  }

  /// Builds a destination. On the hub (no selection) the "selected" icon is the
  /// same outlined icon, so index 0 doesn't read as active.
  NavigationDestination _dest(
    IconData icon,
    IconData filled,
    String label,
    bool hasSelection,
  ) {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: hasSelection
          ? Icon(filled, color: AppColors.primary)
          : Icon(icon),
      label: label,
    );
  }
}

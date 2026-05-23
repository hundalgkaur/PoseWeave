import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poseweave/core/constants/app_colors.dart';
import 'package:poseweave/presentation/widgets/glass_panel.dart';

/// A mode tile on the home screen: icon, title (with optional badge), subtitle,
/// and a trailing chevron. The active tile gets a glowing cyan accent bar;
/// disabled tiles dim and ignore taps.
class ModeSelectorCard extends StatelessWidget {
  const ModeSelectorCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.active = false,
    this.enabled = true,
    this.badge,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;
  final bool enabled;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap:
            enabled && onTap != null
                ? () {
                  HapticFeedback.selectionClick();
                  onTap!.call();
                }
                : null,
        child: GlassPanel(
          padding: const EdgeInsets.all(20),
          borderColor:
              active ? AppColors.primaryContainer.withValues(alpha: 0.5) : null,
          child: Row(
            children: <Widget>[
              if (active)
                Container(
                  width: 3,
                  height: 44,
                  margin: const EdgeInsets.only(right: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.primaryContainer.withValues(
                          alpha: 0.8,
                        ),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      active
                          ? AppColors.primaryContainer.withValues(alpha: 0.12)
                          : AppColors.surfaceVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color:
                        active
                            ? AppColors.primaryContainer.withValues(alpha: 0.3)
                            : AppColors.glassBorder,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      active ? AppColors.primary : AppColors.onSurfaceVariant,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            title,
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (badge != null) ...<Widget>[
                          const SizedBox(width: 8),
                          _Badge(label: badge!),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color:
                    active
                        ? AppColors.primary
                        : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.primaryContainer.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/money_formatter.dart';

/// Small chip used inside the hero balance card to show income or expense
/// totals. Contained here so the balance section stays layout-only.
class DashboardFlowChip extends StatelessWidget {
  final String label;
  final double value;
  final String currency;
  final IconData icon;
  final Color tint;

  const DashboardFlowChip({
    super.key,
    required this.label,
    required this.value,
    required this.currency,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMeasurements.paddingMedium,
        vertical: AppMeasurements.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: context.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.85),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 12, color: context.onPrimary),
              ),
              const SizedBox(width: AppMeasurements.paddingSmall),
              Expanded(
                child: Text(
                  label,
                  style: context.labelSmall?.copyWith(
                    color: context.onPrimary.withValues(alpha: 0.85),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              value.toMoney(currency),
              style: context.titleMedium?.copyWith(
                color: context.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';
import '../responsive/app_measurements.dart';

/// Reusable empty-state placeholder. Renders an icon + message, muted, centered.
/// Use [compact] for row-height contexts (dashboard sections) instead of the
/// default column-height one used inside a list body.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool compact;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.message,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppMeasurements.paddingLarge,
        ),
        child: Row(
          children: [
            Icon(icon, color: context.onSurface.withValues(alpha: 0.35)),
            const SizedBox(width: AppMeasurements.paddingMedium),
            Expanded(
              child: Text(
                message,
                style: context.bodyMedium?.copyWith(
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppMeasurements.iconLarge * 2,
            color: context.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppMeasurements.paddingMedium),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: context.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

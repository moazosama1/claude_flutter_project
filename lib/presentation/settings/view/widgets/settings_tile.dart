import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';

/// Small card wrapper for a grouped settings block. Section title + icon at
/// the top, arbitrary rows below. Kept private to the Settings feature —
/// promote to `lib/core/custom_widget/` if a second feature needs it.
class SettingsGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppMeasurements.paddingLarge),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppMeasurements.paddingMedium,
              AppMeasurements.paddingMedium,
              AppMeasurements.paddingMedium,
              AppMeasurements.paddingSmall,
            ),
            child: Row(
              children: [
                Icon(icon, color: context.primaryColor),
                const SizedBox(width: AppMeasurements.paddingSmall),
                Text(
                  title,
                  style: context.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

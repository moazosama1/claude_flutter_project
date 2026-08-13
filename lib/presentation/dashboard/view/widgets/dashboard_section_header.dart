import 'package:flutter/material.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';

/// Compact section header with an optional trailing action (typically a
/// "See all" link). Used across the dashboard sections for consistent tone.
class DashboardSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DashboardSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppMeasurements.paddingExtraSmall,
        right: AppMeasurements.paddingExtraSmall,
        bottom: AppMeasurements.paddingMedium,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMeasurements.paddingSmall,
                  vertical: AppMeasurements.paddingExtraSmall,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: context.labelMedium?.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

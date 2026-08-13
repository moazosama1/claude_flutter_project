import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/router/route_names.dart';
import 'settings_tile.dart';

class SettingsCommitmentsSection extends StatelessWidget {
  const SettingsCommitmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: context.l10n.commitmentsTitle,
      icon: Icons.event_repeat_rounded,
      children: [
        InkWell(
          onTap: () => context.push(RouteNames.commitments),
          borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
          child: Padding(
            padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.manageCommitments,
                        style: context.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.manageCommitmentsDesc,
                        style: context.labelSmall?.copyWith(
                          color: context.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.onSurface.withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

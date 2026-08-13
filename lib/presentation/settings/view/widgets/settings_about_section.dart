import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'settings_tile.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: context.l10n.about,
      icon: Icons.info_outline_rounded,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.appName,
                  style: context.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '${context.l10n.version} ${context.l10n.appVersion}',
                style: context.bodySmall?.copyWith(
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

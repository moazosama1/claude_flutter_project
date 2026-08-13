import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/core_cubit/core_events.dart';
import '../../../../core/core_cubit/core_state.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'settings_tile.dart';

class SettingsThemeSection extends StatelessWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CoreCubit, CoreState, ThemeMode>(
      selector: (state) => state.themeMode,
      builder: (context, mode) {
        return SettingsGroup(
          title: context.l10n.theme,
          icon: Icons.brightness_6_rounded,
          children: [
            _ThemeOption(
              label: context.l10n.themeSystem,
              mode: ThemeMode.system,
              selected: mode,
              icon: Icons.brightness_auto_rounded,
            ),
            const Divider(height: 1),
            _ThemeOption(
              label: context.l10n.themeLight,
              mode: ThemeMode.light,
              selected: mode,
              icon: Icons.light_mode_rounded,
            ),
            const Divider(height: 1),
            _ThemeOption(
              label: context.l10n.themeDark,
              mode: ThemeMode.dark,
              selected: mode,
              icon: Icons.dark_mode_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String label;
  final ThemeMode mode;
  final ThemeMode selected;
  final IconData icon;

  const _ThemeOption({
    required this.label,
    required this.mode,
    required this.selected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == selected;
    return InkWell(
      onTap: () => context
          .read<CoreCubit>()
          .doIntent(ChangeThemeModeCoreEvent(mode)),
      borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMeasurements.paddingMedium,
          vertical: AppMeasurements.paddingMedium,
        ),
        child: Row(
          children: [
            Icon(icon, color: context.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: AppMeasurements.paddingMedium),
            Expanded(
              child: Text(
                label,
                style: context.bodyMedium?.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, color: context.primaryColor),
          ],
        ),
      ),
    );
  }
}

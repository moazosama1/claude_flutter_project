import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/core_cubit/core_events.dart';
import '../../../../core/core_cubit/core_state.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'settings_tile.dart';

class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CoreCubit, CoreState, Locale>(
      selector: (state) => state.locale,
      builder: (context, locale) {
        return SettingsGroup(
          title: context.l10n.language,
          icon: Icons.translate_rounded,
          children: [
            _LocaleOption(
              label: context.l10n.english,
              code: 'en',
              selectedCode: locale.languageCode,
            ),
            const _Sep(),
            _LocaleOption(
              label: context.l10n.arabic,
              code: 'ar',
              selectedCode: locale.languageCode,
            ),
          ],
        );
      },
    );
  }
}

class _LocaleOption extends StatelessWidget {
  final String label;
  final String code;
  final String selectedCode;

  const _LocaleOption({
    required this.label,
    required this.code,
    required this.selectedCode,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = code == selectedCode;
    return InkWell(
      onTap: () => context
          .read<CoreCubit>()
          .doIntent(ChangeLocaleCoreEvent(Locale(code))),
      borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMeasurements.paddingMedium,
          vertical: AppMeasurements.paddingMedium,
        ),
        child: Row(
          children: [
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

class _Sep extends StatelessWidget {
  const _Sep();
  @override
  Widget build(BuildContext context) => const Divider(height: 1);
}

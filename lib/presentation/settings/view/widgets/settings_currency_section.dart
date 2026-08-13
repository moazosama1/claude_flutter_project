import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/core_cubit/core_events.dart';
import '../../../../core/core_cubit/core_state.dart';
import '../../../../core/custom_widget/custom_dropdown_field.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'settings_tile.dart';

class SettingsCurrencySection extends StatelessWidget {
  const SettingsCurrencySection({super.key});

  // Kept short; expand as needed. ISO-4217 codes.
  static const _codes = ['USD', 'EUR', 'GBP', 'EGP', 'SAR', 'AED'];

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CoreCubit, CoreState, String>(
      selector: (state) => state.currencyCode,
      builder: (context, code) {
        return SettingsGroup(
          title: context.l10n.currency,
          icon: Icons.attach_money_rounded,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
              child: CustomDropdownField<String>(
                items: _codes,
                value: _codes.contains(code) ? code : _codes.first,
                itemAsString: (c) => c,
                onChanged: (c) {
                  if (c == null) return;
                  context
                      .read<CoreCubit>()
                      .doIntent(ChangeCurrencyCoreEvent(c));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

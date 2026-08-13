import 'package:flutter/material.dart';

import '../../../../core/custom_widget/screen_header.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'settings_about_section.dart';
import 'settings_categories_section.dart';
import 'settings_commitments_section.dart';
import 'settings_currency_section.dart';
import 'settings_data_section.dart';
import 'settings_language_section.dart';
import 'settings_theme_section.dart';

class SettingsViewBody extends StatelessWidget {
  const SettingsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: AppMeasurements.padding64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenHeader(title: context.l10n.settingsTitle, subtitle: ''),
          const SizedBox(height: AppMeasurements.paddingLarge),
          const SettingsLanguageSection(),
          const SettingsThemeSection(),
          const SettingsCurrencySection(),
          const SettingsCategoriesSection(),
          const SettingsCommitmentsSection(),
          const SettingsDataSection(),
          const SettingsAboutSection(),
        ],
      ),
    );
  }
}

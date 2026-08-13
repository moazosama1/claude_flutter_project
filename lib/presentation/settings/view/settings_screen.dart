import 'package:flutter/material.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import 'widgets/settings_view_body.dart';

/// Every setting the Settings screen exposes lives in `CoreCubit`
/// (locale, theme, currency), which is already provided at the app root.
/// So the screen doesn't need its own ViewModel — it's pure composition.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScreenWrapper(body: SettingsViewBody());
  }
}

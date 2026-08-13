import 'package:flutter/material.dart';

sealed class CoreEvents {}

class LoadLocaleCoreEvent extends CoreEvents {}

class ToggleLocaleCoreEvent extends CoreEvents {}

class ChangeLocaleCoreEvent extends CoreEvents {
  final Locale locale;
  ChangeLocaleCoreEvent(this.locale);
}

class ChangeThemeModeCoreEvent extends CoreEvents {
  final ThemeMode mode;
  ChangeThemeModeCoreEvent(this.mode);
}

class ChangeCurrencyCoreEvent extends CoreEvents {
  final String currencyCode;
  ChangeCurrencyCoreEvent(this.currencyCode);
}

// Kept as a stub so `AuthInterceptor` (Supabase-shaped, currently unwired for
// real auth) can compile. Handler in `CoreCubit` is a no-op until real auth lands.
class LogoutCoreEvent extends CoreEvents {}

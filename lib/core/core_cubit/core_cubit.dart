import 'dart:ui';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../generated/l10n.dart';
import '../constants/const_keys.dart';
import '../manager/secure_storage_manager.dart';
import 'core_events.dart';
import 'core_state.dart';

@lazySingleton
class CoreCubit extends Cubit<CoreState> {
  final SecureStorageManager _storageManager;

  CoreCubit(this._storageManager) : super(const CoreState()) {
    _init();
  }

  void doIntent(CoreEvents event) {
    switch (event) {
      case LoadLocaleCoreEvent():
        _loadLocale();
      case ToggleLocaleCoreEvent():
        _toggleLocale();
      case ChangeLocaleCoreEvent():
        _changeLocale(event.locale);
      case ChangeThemeModeCoreEvent():
        _changeThemeMode(event.mode);
      case ChangeCurrencyCoreEvent():
        _changeCurrency(event.currencyCode);
      case LogoutCoreEvent():
        // No-op until real auth is added. Kept so the sealed switch stays exhaustive.
        break;
    }
  }

  Future<void> _init() async {
    await Future.wait([_loadLocale(), _loadThemeMode(), _loadCurrency()]);
  }

  Future<void> _loadLocale() async {
    final localeCode = await _storageManager.getString(key: ConstKeys.kLocale);
    emit(
      state.copyWith(
        locale: localeCode == null
            ? supportedLocales.first
            : Locale(localeCode),
      ),
    );
  }

  Future<void> _changeLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;
    await _storageManager.setString(
      key: ConstKeys.kLocale,
      value: locale.languageCode,
    );
    emit(state.copyWith(locale: locale));
  }

  Future<void> _toggleLocale() async {
    final currentIndex = supportedLocales.indexOf(currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    final nextLocale = supportedLocales[nextIndex];
    await _changeLocale(nextLocale);
  }

  Future<void> _loadThemeMode() async {
    final stored = await _storageManager.getString(key: ConstKeys.kThemeMode);
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _changeThemeMode(ThemeMode mode) async {
    await _storageManager.setString(
      key: ConstKeys.kThemeMode,
      value: mode.name,
    );
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> _loadCurrency() async {
    final code = await _storageManager.getString(key: ConstKeys.kCurrency);
    emit(state.copyWith(currencyCode: code ?? 'USD'));
  }

  Future<void> _changeCurrency(String code) async {
    await _storageManager.setString(key: ConstKeys.kCurrency, value: code);
    emit(state.copyWith(currencyCode: code));
  }

  List<Locale> get supportedLocales =>
      AppLocalizations.delegate.supportedLocales;

  Locale get currentLocale => state.locale;
}

import 'dart:ui';

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

  CoreCubit(this._storageManager) : super(const CoreState()){
    _init();
  }

  void doIntent(CoreEvents events) {
    switch (events) {
      case LoadLocaleCoreEvent():
        _loadLocale();
      case ToggleLocaleCoreEvent():
        _toggleLocale();
      case ChangeLocaleCoreEvent():
        _changeLocale(events.locale);
    }
  }

  Future<void> _init() async {
    Future.wait([
      _loadLocale(),
    ]);
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

  List<Locale> get supportedLocales =>
      AppLocalizations.delegate.supportedLocales;

  Locale get currentLocale => state.locale;
}

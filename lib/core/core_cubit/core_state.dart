import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show ThemeMode;

class CoreState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;

  /// ISO-4217 currency code used to format every monetary amount in the UI.
  /// Persisted via the same SecureStorage bucket as locale/theme for
  /// consistency; not treated as sensitive.
  final String currencyCode;

  const CoreState({
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
    this.currencyCode = 'USD',
  });

  CoreState copyWith({
    Locale? locale,
    ThemeMode? themeMode,
    String? currencyCode,
  }) {
    return CoreState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode, currencyCode];
}

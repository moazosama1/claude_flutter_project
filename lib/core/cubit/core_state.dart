import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../constants/const_keys.dart';

class CoreState extends Equatable {
  final Locale locale;

  const CoreState({
    this.locale = const Locale(ConstKeys.englishLangCode),
  });

  CoreState copyWith({bool? isLoading, String? errorMessage, Locale? locale}) {
    return CoreState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [locale];
}

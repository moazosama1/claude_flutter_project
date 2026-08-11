import 'dart:ui';

import 'package:equatable/equatable.dart';

class CoreState extends Equatable {
  final Locale locale;

  const CoreState({
    this.locale = const Locale('en'),
  });

  CoreState copyWith({
    Locale? locale,
  }) {
    return CoreState(
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [locale];
}

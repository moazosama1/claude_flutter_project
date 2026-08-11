import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  // Colors
  Color get primaryColor => theme.colorScheme.primary;
  Color get onPrimary => theme.colorScheme.onPrimary;
  Color get secondaryColor => theme.colorScheme.secondary;
  Color get onSecondary => theme.colorScheme.onSecondary;
  Color get errorColor => theme.colorScheme.error;
  Color get surfaceColor => theme.colorScheme.surface;
  Color get onSurface => theme.colorScheme.onSurface;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;
  Color get cardColor => theme.cardTheme.color ?? theme.colorScheme.surface;
  Color get shadowColor =>
      theme.cardTheme.shadowColor ?? Colors.black.withValues(alpha: 0.1);
  Color get fieldFillColor =>
      theme.inputDecorationTheme.fillColor ?? surfaceColor;
  Color get successColor => const Color(0xFF0F7F2A);
  Color get infoColor => const Color(0xFF00E5FF);
  Color get warningColor => const Color(0xFFFFC107);
  Color get outlineColor => theme.colorScheme.outline;

  // Text Styles
  TextStyle? get bodySmall => theme.textTheme.bodySmall;
  TextStyle? get bodyMedium => theme.textTheme.bodyMedium;
  TextStyle? get bodyLarge => theme.textTheme.bodyLarge;
  TextStyle? get labelSmall => theme.textTheme.labelSmall;
  TextStyle? get labelMedium => theme.textTheme.labelMedium;
  TextStyle? get labelLarge => theme.textTheme.labelLarge;
  TextStyle? get tableDateStyle => theme.textTheme.bodySmall?.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 13,
  );
  TextStyle? get headlineSmall => theme.textTheme.headlineSmall;
  TextStyle? get headlineMedium => theme.textTheme.headlineMedium;
  TextStyle? get headlineLarge => theme.textTheme.headlineLarge;
  TextStyle? get titleSmall => theme.textTheme.titleSmall;
  TextStyle? get titleMedium => theme.textTheme.titleMedium;
  TextStyle? get titleLarge => theme.textTheme.titleLarge;
  TextStyle? get displaySmall => theme.textTheme.displaySmall;
  TextStyle? get displayMedium => theme.textTheme.displayMedium;
}

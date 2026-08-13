import 'package:flutter/material.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import 'package:initialize_project/core/constants/const_keys.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    primaryColor: AppColors.mainColor,
    colorScheme: colorSchemeLight,
    scaffoldBackgroundColor: AppColors.surface,
    surfaceColor: AppColors.surfaceContainerLowest,
    cardColor: AppColors.surfaceContainerLowest,
    fieldFillColor: null, // computed from primary + surface
    primaryTextColor: AppColors.black[100]!,
    secondaryTextColor: null, // computed at 85% alpha of primary
    hintColor: AppColors.gray.withValues(alpha: 0.6),
    outlineColor: AppColors.outlineVariant,
    shadowColor: AppColors.black.withValues(alpha: 0.12),
    bottomNavElevation: 8,
  );

  static ThemeData get darkTheme => _buildTheme(
    primaryColor: AppColors.mainColor,
    colorScheme: colorSchemeDark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    surfaceColor: AppColors.darkSurface,
    cardColor: AppColors.darkSurfaceElevated,
    fieldFillColor: AppColors.darkFieldFill,
    primaryTextColor: AppColors.darkOnSurface,
    secondaryTextColor: AppColors.darkOnSurfaceMuted,
    hintColor: AppColors.darkOnSurfaceMuted.withValues(alpha: 0.7),
    outlineColor: AppColors.darkOutline,
    shadowColor: AppColors.darkShadow,
    bottomNavElevation: 0,
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color primaryColor,
    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color cardColor,
    required Color primaryTextColor,
    required Color hintColor,
    required Color outlineColor,
    required Color shadowColor,
    required double bottomNavElevation,
    Color? fieldFillColor,
    Color? secondaryTextColor,
  }) {
    final secondaryText =
        secondaryTextColor ?? primaryTextColor.withValues(alpha: 0.85);
    final resolvedFieldFill = fieldFillColor ??
        Color.alphaBlend(
          primaryColor.withValues(alpha: 0.04),
          surfaceColor,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      fontFamily: ConstKeys.cairoFont,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,

      // Typography
      textTheme: TextTheme(
        displaySmall: getTextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        displayMedium: getTextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        displayLarge: getTextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w700,
          color: primaryTextColor,
        ),
        titleSmall: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: primaryTextColor,
        ),
        titleMedium: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        titleLarge: getTextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        bodySmall: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: secondaryText,
        ),
        bodyMedium: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: secondaryText,
        ),
        bodyLarge: getTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: secondaryText,
        ),

        headlineSmall: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: secondaryText,
        ),
        headlineMedium: getTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: secondaryText,
        ),
        headlineLarge: getTextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: secondaryText,
        ),

        labelSmall: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondaryText,
        ),
        labelMedium: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: secondaryText,
        ),
        labelLarge: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: secondaryText,
        ),
      ),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryTextColor),
        titleTextStyle: getTextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainColor,
          foregroundColor: AppColors.surfaceContainerHighest,
          disabledBackgroundColor: AppColors.gray.withValues(alpha: 0.3),
          elevation: 0,
          textStyle: getTextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mainColor,
          textStyle: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.mainColor,
          side: BorderSide(color: AppColors.mainColor),
          textStyle: getTextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: resolvedFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: getTextStyle(color: hintColor, fontSize: 16),
        labelStyle: getTextStyle(color: primaryTextColor, fontSize: 16),
        floatingLabelStyle: getTextStyle(
          color: AppColors.mainColor,
          fontSize: 14,
        ),
        errorStyle: getTextStyle(color: AppColors.red, fontSize: 14),
        border: getOutlineInputBorder(color: outlineColor),
        enabledBorder: getOutlineInputBorder(color: outlineColor, width: 1.1),
        focusedBorder: getOutlineInputBorder(color: primaryColor, width: 1.8),
        errorBorder: getOutlineInputBorder(color: AppColors.red),
        focusedErrorBorder: getOutlineInputBorder(
          color: AppColors.red,
          width: 1.8,
        ),
        prefixIconColor: primaryColor,
        suffixIconColor: primaryColor,
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryTextColor,
        ),
        contentTextStyle: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: primaryTextColor,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: outlineColor.withValues(alpha: 0.3),
        thickness: 1,
        space: 1,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackgroundColor,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.gray,
        selectedLabelStyle: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.mainColor,
        ),
        unselectedLabelStyle: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.gray,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: bottomNavElevation,
      ),
    );
  }

  static OutlineInputBorder getOutlineInputBorder({
    required Color color,
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextStyle getTextStyle({
    Color? color,
    double? fontSize,
    String? fontFamily,
    FontWeight? fontWeight,
    double? height,
  }) {
    return TextStyle(
      color: color ?? AppColors.black,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? ConstKeys.cairoFont,
      fontWeight: fontWeight ?? FontWeight.w400,
      height: height,
    );
  }
}

ColorScheme colorSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: AppColors.mainColor,
  onPrimary: AppColors.surfaceContainerHighest,
  secondary: AppColors.black,
  onSecondary: AppColors.surfaceContainerLowest,
  tertiary: AppColors.splashBackground,
  error: AppColors.red,
  onError: AppColors.surfaceContainerLowest,
  surface: AppColors.surface,
  onSurface: AppColors.black[100]!,
);

// Dark scheme — deep navy family. `primary` stays the brand color so buttons
// and highlights pop against the dark background; `surface` is the base card
// color (matches `cardColor` passed into _buildTheme) so Material widgets that
// derive their fill from the color scheme look consistent.
ColorScheme colorSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.mainColor,
  onPrimary: AppColors.darkOnSurface,
  secondary: AppColors.mainColor,
  onSecondary: AppColors.darkOnSurface,
  tertiary: AppColors.mainColor,
  error: AppColors.red,
  onError: AppColors.darkOnSurface,
  surface: AppColors.darkSurface,
  onSurface: AppColors.darkOnSurface,
  outline: AppColors.darkOutline,
);

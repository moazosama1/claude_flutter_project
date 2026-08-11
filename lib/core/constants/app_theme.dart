import 'package:flutter/material.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import 'package:initialize_project/core/constants/const_keys.dart';

abstract class AppTheme {
  static ThemeData get lightTheme => _buildTheme(
    primaryColor: AppColors.mainColor,
    colorScheme: colorSchemeLight,
    scaffoldBackgroundColor: AppColors.surface,
    surfaceColor: AppColors.surfaceContainerLowest,
    primaryTextColor: AppColors.black[100]!,
    shadowColor: AppColors.black.withValues(alpha: 0.12),
    bottomNavElevation: 8,
  );

  static ThemeData get darkTheme => _buildTheme(
    primaryColor: AppColors.mainColor,
    colorScheme: colorSchemeDark,
    scaffoldBackgroundColor: AppColors.black,
    surfaceColor: AppColors.black[50]!,
    primaryTextColor: AppColors.white,
    shadowColor: AppColors.black.withValues(alpha: 0.2),
    bottomNavElevation: 0,
  );

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color primaryColor,

    required Color scaffoldBackgroundColor,
    required Color surfaceColor,
    required Color primaryTextColor,
    required Color shadowColor,
    required double bottomNavElevation,
  }) {
    // Using a high-opacity primary text color for secondary text to ensure readability in sunlight
    // while maintaining a slight visual hierarchy.
    final secondaryTextColor = primaryTextColor.withValues(alpha: 0.85);

    return ThemeData(
      useMaterial3: true,
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
          color: secondaryTextColor,
        ),
        bodyMedium: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: secondaryTextColor,
        ),
        bodyLarge: getTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: secondaryTextColor,
        ),

        headlineSmall: getTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: secondaryTextColor,
        ),
        headlineMedium: getTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: secondaryTextColor,
        ),
        headlineLarge: getTextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: secondaryTextColor,
        ),

        labelSmall: getTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondaryTextColor,
        ),
        labelMedium: getTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: secondaryTextColor,
        ),
        labelLarge: getTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: secondaryTextColor,
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
        fillColor: Color.alphaBlend(
          primaryColor.withValues(alpha: 0.04),
          surfaceColor,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: getTextStyle(
          color: AppColors.gray.withValues(alpha: 0.6),
          fontSize: 16,
        ),
        labelStyle: getTextStyle(color: primaryTextColor, fontSize: 16),
        floatingLabelStyle: getTextStyle(
          color: AppColors.mainColor,
          fontSize: 14,
        ),
        errorStyle: getTextStyle(color: AppColors.red, fontSize: 14),
        border: getOutlineInputBorder(color: AppColors.outlineVariant),
        enabledBorder: getOutlineInputBorder(
          color: AppColors.outlineVariant,
          width: 1.1,
        ),
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
        backgroundColor: surfaceColor,
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
        backgroundColor: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: shadowColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.zero,
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: AppColors.outlineVariant.withValues(alpha: 0.1),
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

ColorScheme colorSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: AppColors.mainColor,
  onPrimary: AppColors.surfaceContainerHighest,
  secondary: AppColors.surfaceContainerLowest,
  onSecondary: AppColors.black,
  tertiary: AppColors.splashBackground,
  error: AppColors.red,
  onError: AppColors.surfaceContainerLowest,
  surface: AppColors.black,
  onSurface: AppColors.surfaceContainerLowest,
);

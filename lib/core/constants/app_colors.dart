import 'package:flutter/material.dart';

abstract class AppColors {
  // Neutral - #F8FAFC
  static MaterialColor white = const MaterialColor(0xFFF8FAFC, <int, Color>{
    10: Color(0xFFfefefe),
    20: Color(0xFFfdfdfd),
    30: Color(0xFFfcfcfc),
    40: Color(0xFFfbfbfb),
    50: Color(0xFFfafafa),
    60: Color(0xFFd0d0d0),
    70: Color(0xFFa6a6a6),
    80: Color(0xFF7d7d7d),
    90: Color(0xFF647488),
    100: Color(0xFF323232),
  });

  // Primary - #0087C0 (Blue)
  static MaterialColor mainColor = const MaterialColor(0xFF324CF5, <int, Color>{
    10: Color(0xFFd9f0f9),
    20: Color(0xFFb3e1f3),
    30: Color(0xFF8dd2ed),
    40: Color(0xFF67c3e7),
    50: Color(0xFF41b4e1),
    60: Color(0xFF0087c0),
    70: Color(0xFF006b99),
    80: Color(0xFF004f72),
    90: Color(0xFF00334b),
    100: Color(0xFF001724),
  });

  // Secondary - #647488 (Gray-blue)
  static MaterialColor black = const MaterialColor(0xFF647488, <int, Color>{
    10: Color(0xFFe8eaed),
    20: Color(0xFFd1d5db),
    30: Color(0xFFbac0ca),
    40: Color(0xFFa3abb9),
    50: Color(0xFF8c96a8),
    60: Color(0xFF647488),
    70: Color(0xFF525d70),
    80: Color(0xFF404658),
    90: Color(0xFF2e2f40),
    100: Color(0xFF1c1d28),
  });

  // Surface colors
  static const Color surface = Color(0xFFF0F2F5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFf3f5f7);
  static const Color surfaceContainerHighest = Color(0xFFfdfdfd);
  static const Color outlineVariant = Color(0xFFcecfd0);
  static const Color splashBackground = Color(0xFFe3f2fd);

  static const Color gray = Color(0xFF647488);
  static const Color red = Color(0xffCC1010);
  static const Color green = Color(0xFF0F7F2A);
  static const Color lightBackground = Color(0xFFF0F2F5);
  static const Color yellow = Color(0xFFC8D444);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color transparent = Colors.transparent;

  // -- Expenses module colours --------------------------------------------
  static const Color expenseOrange = Color(0xFFFF5722); // deepOrange
  static const Color expenseOrangeLight = Color(0xFFFBE9E7);
  static const Color supplierOrange = Color(0xFFFF6600); // supplier form accent
  static const Color supplierOrangeLight = Color(0xFFFFF3EB);
  static const Color supplierPurple = Color(0xFF7B1FA2); // digital payment
  static const Color supplierPurpleLight = Color(0xFFF3E5F5);
  static const Color salaryIndigo = Color(0xFF3949AB); // indigo
  static const Color employeeTeal = Color(0xFF009688); // teal from screenshot
  static const Color tabBackground = Color(0xFFF5F5F5); // grey[100]
  static const Color tabSurface = Color(0xFFFFFFFF);
}

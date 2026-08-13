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

  // Primary - Modern indigo (#4F46E5 base, Tailwind indigo-600 family).
  // The full 10→100 ramp are actual shades of the base — sub-shades used to
  // be a mismatched cyan/blue family; unified for consistent tinting.
  static MaterialColor mainColor = const MaterialColor(0xFF4F46E5, <int, Color>{
    10: Color(0xFFEEF2FF),  // indigo-50
    20: Color(0xFFE0E7FF),  // indigo-100
    30: Color(0xFFC7D2FE),  // indigo-200
    40: Color(0xFFA5B4FC),  // indigo-300
    50: Color(0xFF818CF8),  // indigo-400
    60: Color(0xFF6366F1),  // indigo-500
    70: Color(0xFF4F46E5),  // indigo-600 (base)
    80: Color(0xFF4338CA),  // indigo-700
    90: Color(0xFF3730A3),  // indigo-800
    100: Color(0xFF312E81), // indigo-900
  });

  // Optional accent — modern violet, for gradients / secondary highlights.
  static const Color accentViolet = Color(0xFF8B5CF6);   // violet-500
  static const Color accentEmerald = Color(0xFF10B981);  // emerald-500 (money/positive)

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

  // -- Light-mode surfaces (Tailwind slate family; softer than pure white) -
  static const Color surface = Color(0xFFF8FAFC);              // slate-50 (scaffold)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // pure white (cards)
  static const Color surfaceContainerLow = Color(0xFFF1F5F9);   // slate-100
  static const Color surfaceContainerHighest = Color(0xFFFFFFFF);
  static const Color outlineVariant = Color(0xFFE2E8F0);        // slate-200 (soft borders)
  static const Color splashBackground = Color(0xFFEEF2FF);      // indigo-50 tint

  // -- Semantic (modern Tailwind palette) ---------------------------------
  static const Color gray = Color(0xFF64748B);   // slate-500
  static const Color red = Color(0xFFEF4444);    // red-500
  static const Color green = Color(0xFF10B981);  // emerald-500
  static const Color yellow = Color(0xFFF59E0B); // amber-500
  static const Color info = Color(0xFF0EA5E9);   // sky-500

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color gray300 = Color(0xFFE2E8F0);
  static const Color transparent = Colors.transparent;

  // -- Dark theme palette (deep navy / black-blue family) -----------------
  // Chosen so cards read as elevated against the scaffold (surface >
  // surfaceElevated separation of ~6% lightness), and text stays legible
  // without going pure white.
  static const Color darkBackground = Color(0xFF0B1220);     // scaffold
  static const Color darkSurface = Color(0xFF111A2E);        // sheets, base surface
  static const Color darkSurfaceElevated = Color(0xFF1A2540); // cards, dialogs
  static const Color darkFieldFill = Color(0xFF162037);      // input fills
  static const Color darkOnSurface = Color(0xFFE2E8F0);      // primary text
  static const Color darkOnSurfaceMuted = Color(0xFF94A3B8); // secondary text / hints
  static const Color darkOutline = Color(0xFF2A3854);
  static const Color darkShadow = Color(0xCC000000);         // slightly heavier shadow

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

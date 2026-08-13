import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Icon options offered in the category form's icon picker.
/// Kept as a curated Material Icons set so the picker isn't overwhelming.
const List<IconData> kCategoryIcons = [
  Icons.restaurant,
  Icons.local_cafe,
  Icons.local_grocery_store,
  Icons.directions_car,
  Icons.local_gas_station,
  Icons.train,
  Icons.flight,
  Icons.home,
  Icons.receipt_long,
  Icons.bolt,
  Icons.water_drop,
  Icons.wifi,
  Icons.local_hospital,
  Icons.medication,
  Icons.school,
  Icons.book,
  Icons.movie,
  Icons.sports_esports,
  Icons.shopping_bag,
  Icons.card_giftcard,
  Icons.attach_money,
  Icons.savings,
  Icons.trending_up,
  Icons.pets,
  Icons.fitness_center,
  Icons.spa,
  Icons.cut,
  Icons.category,
];

/// Color options offered in the category form's color picker.
/// Tailwind-500 family, matches the app's modern palette.
const List<String> kCategoryColors = [
  '#EF4444', // red
  '#F97316', // orange
  '#F59E0B', // amber
  '#EAB308', // yellow
  '#84CC16', // lime
  '#22C55E', // green
  '#10B981', // emerald
  '#14B8A6', // teal
  '#06B6D4', // cyan
  '#3B82F6', // blue
  '#6366F1', // indigo
  '#8B5CF6', // violet
  '#A855F7', // purple
  '#EC4899', // pink
  '#F43F5E', // rose
  '#64748B', // slate
];

/// Parses a stored `#RRGGBB` (or `#AARRGGBB`) hex into a Color. Falls back
/// to the palette's neutral gray on malformed input.
Color parseCategoryHex(String hex) {
  var cleaned = hex.replaceFirst('#', '');
  if (cleaned.length == 6) cleaned = 'FF$cleaned';
  final parsed = int.tryParse(cleaned, radix: 16);
  return parsed != null ? Color(parsed) : AppColors.gray;
}

import 'package:intl/intl.dart';

extension NumberFormattingExtension on num {
  /// Formats a number with commas as thousand separators.
  /// Example: 500000 -> "500,000"
  /// Example: 1250000.5 -> "1,250,000.5" or "1,250,000.50" if [decimalDigits] is specified.
  String toFormattedString({int? decimalDigits, bool isCompact = false}) {
    if (isCompact) {
      return NumberFormat.compact().format(this);
    }

    if (decimalDigits != null) {
      final formatter = NumberFormat.currency(
        symbol: '',
        decimalDigits: decimalDigits,
      );
      return formatter.format(this).trim();
    }

    // Default formatting: add thousand separators and preserve up to 2 decimal places if present
    final formatter = NumberFormat('#,##0.##');
    return formatter.format(this);
  }
}

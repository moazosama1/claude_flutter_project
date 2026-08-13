import 'number_formatter.dart';

/// Formats a monetary amount with a currency symbol prefix. Falls back to
/// the ISO-4217 code when we don't have a known symbol.
///
/// Usage: `1250.5.toMoney('EGP')` -> `'E£1,250.50'`.
extension MoneyFormatting on num {
  String toMoney(String currencyCode, {int decimalDigits = 2}) {
    final symbol = _currencySymbol(currencyCode);
    final amount = toFormattedString(decimalDigits: decimalDigits);
    return '$symbol$amount';
  }
}

String _currencySymbol(String code) {
  switch (code) {
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'EGP':
      return 'E£';
    case 'SAR':
      // Arabic riyal symbol with trailing space for legibility.
      return 'ر.س ';
    case 'AED':
      return 'د.إ ';
    default:
      // Unknown or user-added code — fall back to the raw code + space.
      return '$code ';
  }
}

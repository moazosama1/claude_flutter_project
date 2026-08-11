import 'package:intl/intl.dart';

abstract class FormateDate {
  /// Example: December 10, 2025
  static String formatLong(String? dateStr) {
    return _format(dateStr, DateFormat.yMMMMd('en_US'));
  }

  /// Example: 02:30 PM
  static String formatTime(String? dateStr) {
    return _format(dateStr, DateFormat('hh:mm a'));
  }

  /// Example: 10 Dec 2025
  static String formatMedium(String? dateStr) {
    return _format(dateStr, DateFormat('d MMM yyyy', 'en_US'));
  }

  /// Example: 10/12/2025
  static String formatShort(String? dateStr) {
    return _format(dateStr, DateFormat('dd/MM/yyyy', 'en_US'));
  }

  /// Example: 10/12/2025 - 02:30 PM
  static String formatShortWithHour(String? dateStr) {
    return _format(dateStr, DateFormat('dd/MM/yyyy - hh:mm a', 'en_US'));
  }

  /// Example: 2025-12-10
  static String formatIso(String? dateStr) {
    return _format(dateStr, DateFormat('yyyy-MM-dd', 'en_US'));
  }

  /// Example: 10 Dec 2025 - 14:22
  static String formatWithTime(String? dateStr) {
    return _format(dateStr, DateFormat('d MMM yyyy - HH:mm', 'en_US'));
  }

  /// Wednesday, December 10, 2025
  static String fullDay(String? dateStr) =>
      _format(dateStr, DateFormat('EEEE, MMMM d, yyyy'));

  /// Wed, 10 Dec 2025
  static String fullDayShort(String? dateStr) =>
      _format(dateStr, DateFormat('EEE, d MMM yyyy'));

  /// 10 December 2025 at 14:22
  static String fullWithTime(String? dateStr) =>
      _format(dateStr, DateFormat('d MMMM yyyy at HH:mm'));
  // jun 4
  static String formatMonthDay(String? dateStr) =>
      _format(dateStr, DateFormat('MMM d'));
  // 5 Dec
  static String formatDayMonth(String? dateStr) =>
      _format(dateStr, DateFormat('d MMM'));

  /// Private shared formatter
  static String _format(String? dateStr, DateFormat formatter) {
    try {
      final date = dateStr == null ? DateTime.now() : DateTime.parse(dateStr).toLocal();
      return formatter.format(date);
    } catch (_) {
      return formatter.format(DateTime.now());
    }
  }
}

class DateFormatter {
  /// Formats a [DateTime] object into a string based on the given [pattern].
  /// Default pattern is 'yyyy-MM-dd'.
  static String format(DateTime date, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(date);
  }

  /// Parses a date string and formats it into the given [pattern].
  /// If parsing fails, it returns the original string.
  static String formatString(
    String dateString, {
    String pattern = 'yyyy-MM-dd',
  }) {
    try {
      final DateTime date = DateTime.parse(dateString).toLocal();
      return format(date, pattern: pattern);
    } catch (e) {
      return dateString;
    }
  }
}

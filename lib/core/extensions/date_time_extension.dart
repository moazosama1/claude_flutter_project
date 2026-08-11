extension DateTimeExtension on DateTime {
  /// Returns the start of the day (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Returns the end of the day (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59);
  }

  /// Returns ISO 8601 string for the start of the day
  String get startOfDayIso8601 {
    return startOfDay.toIso8601String();
  }

  /// Returns ISO 8601 string for the end of the day
  String get endOfDayIso8601 {
    return endOfDay.toIso8601String();
  }

  /// Returns the current business date based on the 06:00 AM cut-off.
  /// Any time before 06:00 AM is considered part of the previous day.
  DateTime get businessDate {
    if (hour < 6) {
      return subtract(const Duration(days: 1));
    }
    return this;
  }
}

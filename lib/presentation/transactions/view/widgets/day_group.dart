import '../../../../domain/entities/transaction_entity.dart';

/// Pure Dart grouping helper. Buckets transactions by calendar day (local),
/// most recent day first. Used by the transactions list to render day headers.
class DayGroup {
  final DateTime day;
  final List<TransactionEntity> items;

  DayGroup(this.day, this.items);
}

List<DayGroup> groupByDay(List<TransactionEntity> txns) {
  final sorted = [...txns]..sort((a, b) => b.date.compareTo(a.date));
  final map = <String, DayGroup>{};
  for (final t in sorted) {
    final key = '${t.date.year}-${t.date.month}-${t.date.day}';
    map
        .putIfAbsent(
          key,
          () => DayGroup(DateTime(t.date.year, t.date.month, t.date.day), []),
        )
        .items
        .add(t);
  }
  return map.values.toList();
}

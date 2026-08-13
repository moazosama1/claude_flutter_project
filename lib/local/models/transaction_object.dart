import 'package:objectbox/objectbox.dart';

@Entity()
class TransactionObject {
  @Id()
  int id;

  double amount;

  // Stores the TransactionType enum as its ordinal. Conversion happens in the
  // mapper — the entity keeps its enum, the object keeps the int.
  int typeIndex;

  int categoryId;

  String? note;

  @Property(type: PropertyType.date)
  DateTime date;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  TransactionObject({
    this.id = 0,
    required this.amount,
    required this.typeIndex,
    required this.categoryId,
    required this.date,
    required this.createdAt,
    this.note,
  });
}

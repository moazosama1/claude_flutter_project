import 'package:objectbox/objectbox.dart';

@Entity()
class CategoryObject {
  @Id()
  int id;

  String name;

  int iconCodePoint;

  String colorHex;

  // Stores the TransactionType enum as its ordinal. See transaction_object.dart.
  int typeIndex;

  CategoryObject({
    this.id = 0,
    required this.name,
    required this.iconCodePoint,
    required this.colorHex,
    required this.typeIndex,
  });
}

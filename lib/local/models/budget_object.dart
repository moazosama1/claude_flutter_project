import 'package:objectbox/objectbox.dart';

@Entity()
class BudgetObject {
  @Id()
  int id;

  // One budget per category is enforced in the data source (upsert by
  // categoryId), not by a unique index here.
  int categoryId;

  double monthlyLimit;

  BudgetObject({
    this.id = 0,
    required this.categoryId,
    required this.monthlyLimit,
  });
}

import '../../local/models/budget_object.dart';

abstract class BudgetsLocalDataSource {
  List<BudgetObject> getAll();

  /// Upsert by categoryId: if a budget already exists for the object's
  /// category, its row id is reused so the limit is replaced in place.
  BudgetObject put(BudgetObject obj);

  void remove(int id);
}

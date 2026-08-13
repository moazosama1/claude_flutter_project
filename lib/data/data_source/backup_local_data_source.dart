import '../../local/models/budget_object.dart';
import '../../local/models/category_object.dart';
import '../../local/models/transaction_object.dart';

abstract class BackupLocalDataSource {
  List<TransactionObject> allTransactions();
  List<CategoryObject> allCategories();
  List<BudgetObject> allBudgets();

  /// Atomically wipes the three boxes and inserts the given lists. If any
  /// step fails, the ObjectBox write transaction rolls back — the store is
  /// left in its pre-import state.
  void replaceAll({
    required List<CategoryObject> categories,
    required List<TransactionObject> transactions,
    required List<BudgetObject> budgets,
  });
}

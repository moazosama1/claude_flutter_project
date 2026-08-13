import 'package:injectable/injectable.dart';

import '../../data/data_source/backup_local_data_source.dart';
import '../../local/models/budget_object.dart';
import '../../local/models/category_object.dart';
import '../../local/models/transaction_object.dart';
// objectbox.g.dart re-exports Store/Box/TxMode.
import '../../objectbox.g.dart';

@Injectable(as: BackupLocalDataSource)
class BackupLocalDataSourceImpl implements BackupLocalDataSource {
  final Store _store;
  late final Box<TransactionObject> _txnBox = _store.box<TransactionObject>();
  late final Box<CategoryObject> _categoryBox = _store.box<CategoryObject>();
  late final Box<BudgetObject> _budgetBox = _store.box<BudgetObject>();

  BackupLocalDataSourceImpl(this._store);

  @override
  List<TransactionObject> allTransactions() => _txnBox.getAll();

  @override
  List<CategoryObject> allCategories() => _categoryBox.getAll();

  @override
  List<BudgetObject> allBudgets() => _budgetBox.getAll();

  @override
  void replaceAll({
    required List<CategoryObject> categories,
    required List<TransactionObject> transactions,
    required List<BudgetObject> budgets,
  }) {
    // Single ObjectBox write transaction: everything commits together, or
    // nothing changes at all if any step throws.
    _store.runInTransaction(TxMode.write, () {
      _txnBox.removeAll();
      _budgetBox.removeAll();
      _categoryBox.removeAll();

      // putMany preserves the incoming id when non-zero — critical so the
      // categoryId foreign keys on transactions/budgets still resolve.
      if (categories.isNotEmpty) _categoryBox.putMany(categories);
      if (transactions.isNotEmpty) _txnBox.putMany(transactions);
      if (budgets.isNotEmpty) _budgetBox.putMany(budgets);
    });
  }
}

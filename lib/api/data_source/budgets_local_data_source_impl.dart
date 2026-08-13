import 'package:injectable/injectable.dart';

import '../../data/data_source/budgets_local_data_source.dart';
import '../../local/models/budget_object.dart';
// objectbox.g.dart re-exports Store/Box/QueryBuilder.
import '../../objectbox.g.dart';

@Injectable(as: BudgetsLocalDataSource)
class BudgetsLocalDataSourceImpl implements BudgetsLocalDataSource {
  final Store _store;
  late final Box<BudgetObject> _box = _store.box<BudgetObject>();

  BudgetsLocalDataSourceImpl(this._store);

  @override
  List<BudgetObject> getAll() => _box.getAll();

  @override
  BudgetObject put(BudgetObject obj) {
    // Enforce one budget per category: if a row already exists for this
    // category, reuse its id so put() replaces instead of duplicating.
    if (obj.id == 0) {
      final query = _box
          .query(BudgetObject_.categoryId.equals(obj.categoryId))
          .build();
      try {
        final existing = query.findFirst();
        if (existing != null) obj.id = existing.id;
      } finally {
        query.close();
      }
    }
    _box.put(obj);
    return obj;
  }

  @override
  void remove(int id) => _box.remove(id);
}

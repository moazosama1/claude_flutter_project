import 'package:injectable/injectable.dart';

import '../../core/utils/data_result.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repo/budgets_repo.dart';
import '../../local/mappers/budget_mapper.dart';
import '../data_source/budgets_local_data_source.dart';

@Injectable(as: BudgetsRepo)
class BudgetsRepoImpl implements BudgetsRepo {
  final BudgetsLocalDataSource _local;

  BudgetsRepoImpl(this._local);

  @override
  Future<DataResult<List<BudgetEntity>>> getBudgets() => safeDataCall(
    () async => _local.getAll(),
    (list) => list.map((o) => o.toEntity()).toList(),
  );

  @override
  Future<DataResult<BudgetEntity>> setBudget(BudgetEntity budget) =>
      safeDataCall(
        () async => _local.put(budget.toObject()),
        (obj) => obj.toEntity(),
      );

  @override
  Future<DataResult<void>> deleteBudget(int id) async {
    try {
      _local.remove(id);
      return DataSuccess<void>(null);
    } catch (e) {
      return DataError<void>(e);
    }
  }
}

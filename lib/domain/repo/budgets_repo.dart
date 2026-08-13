import '../../core/utils/data_result.dart';
import '../entities/budget_entity.dart';

abstract class BudgetsRepo {
  Future<DataResult<List<BudgetEntity>>> getBudgets();

  /// Upserts a budget. If a budget already exists for the entity's
  /// `categoryId`, its limit is replaced; otherwise a new row is created.
  Future<DataResult<BudgetEntity>> setBudget(BudgetEntity budget);

  Future<DataResult<void>> deleteBudget(int id);
}

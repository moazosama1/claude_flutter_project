import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/budget_entity.dart';
import '../../repo/budgets_repo.dart';

@injectable
class SetBudgetUseCase {
  final BudgetsRepo _repo;

  SetBudgetUseCase(this._repo);

  Future<DataResult<BudgetEntity>> call(BudgetEntity budget) =>
      _repo.setBudget(budget);
}

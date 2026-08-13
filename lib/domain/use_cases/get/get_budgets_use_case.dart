import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/budget_entity.dart';
import '../../repo/budgets_repo.dart';

@injectable
class GetBudgetsUseCase {
  final BudgetsRepo _repo;

  GetBudgetsUseCase(this._repo);

  Future<DataResult<List<BudgetEntity>>> call() => _repo.getBudgets();
}

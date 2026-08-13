import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/budgets_repo.dart';

@injectable
class DeleteBudgetUseCase {
  final BudgetsRepo _repo;

  DeleteBudgetUseCase(this._repo);

  Future<DataResult<void>> call(int id) => _repo.deleteBudget(id);
}

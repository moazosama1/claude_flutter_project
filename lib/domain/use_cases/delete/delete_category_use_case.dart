import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/transactions_repo.dart';

@injectable
class DeleteCategoryUseCase {
  final TransactionsRepo _repo;

  DeleteCategoryUseCase(this._repo);

  Future<DataResult<void>> call(int id) => _repo.deleteCategory(id);
}

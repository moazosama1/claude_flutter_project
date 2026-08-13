import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/category_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class UpdateCategoryUseCase {
  final TransactionsRepo _repo;

  UpdateCategoryUseCase(this._repo);

  Future<DataResult<CategoryEntity>> call(CategoryEntity category) =>
      _repo.updateCategory(category);
}

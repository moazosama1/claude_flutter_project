import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/category_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class AddCategoryUseCase {
  final TransactionsRepo _repo;

  AddCategoryUseCase(this._repo);

  Future<DataResult<CategoryEntity>> call(CategoryEntity category) =>
      _repo.addCategory(category);
}

import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/category_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class GetCategoriesUseCase {
  final TransactionsRepo _repo;

  GetCategoriesUseCase(this._repo);

  Future<DataResult<List<CategoryEntity>>> call() => _repo.getCategories();
}

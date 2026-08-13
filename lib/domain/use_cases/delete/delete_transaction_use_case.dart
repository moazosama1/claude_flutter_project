import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/transactions_repo.dart';

@injectable
class DeleteTransactionUseCase {
  final TransactionsRepo _repo;

  DeleteTransactionUseCase(this._repo);

  Future<DataResult<void>> call(int id) => _repo.deleteTransaction(id);
}

import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/transaction_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class UpdateTransactionUseCase {
  final TransactionsRepo _repo;

  UpdateTransactionUseCase(this._repo);

  Future<DataResult<TransactionEntity>> call(TransactionEntity txn) =>
      _repo.updateTransaction(txn);
}

import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/transaction_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class AddTransactionUseCase {
  final TransactionsRepo _repo;

  AddTransactionUseCase(this._repo);

  Future<DataResult<TransactionEntity>> call(TransactionEntity txn) =>
      _repo.addTransaction(txn);
}

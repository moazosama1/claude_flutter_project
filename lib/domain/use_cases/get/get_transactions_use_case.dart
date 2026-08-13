import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/transaction_entity.dart';
import '../../repo/transactions_repo.dart';

@injectable
class GetTransactionsUseCase {
  final TransactionsRepo _repo;

  GetTransactionsUseCase(this._repo);

  Future<DataResult<List<TransactionEntity>>> call({
    DateTime? from,
    DateTime? to,
  }) => _repo.getTransactions(from: from, to: to);
}

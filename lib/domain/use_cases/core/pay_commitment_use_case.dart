import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/commitment_entity.dart';
import '../../entities/transaction_entity.dart';
import '../../repo/commitments_repo.dart';
import '../../repo/transactions_repo.dart';

/// Orchestrates the "mark commitment paid" flow: creates a linked transaction
/// with the commitment's amount + category, then stamps the commitment's
/// `lastPaidDate`. Both must succeed for the operation to be considered done.
@injectable
class PayCommitmentUseCase {
  final CommitmentsRepo _commitmentsRepo;
  final TransactionsRepo _transactionsRepo;

  PayCommitmentUseCase(this._commitmentsRepo, this._transactionsRepo);

  Future<DataResult<TransactionEntity>> call(CommitmentEntity commitment) async {
    final now = DateTime.now();

    // Rent/installment/goal → outflow. Jam'iya's monthly contribution is
    // also outflow (payout is handled separately by G2's own flow).
    final txn = TransactionEntity(
      id: 0,
      amount: commitment.amount,
      type: TransactionType.expense,
      categoryId: commitment.categoryId,
      note: commitment.name,
      date: now,
      createdAt: now,
    );

    final txnResult = await _transactionsRepo.addTransaction(txn);
    switch (txnResult) {
      case DataError(:final error):
        return DataError<TransactionEntity>(error);
      case DataSuccess(:final data):
        final markResult = await _commitmentsRepo.markPaid(commitment.id, now);
        switch (markResult) {
          case DataError(:final error):
            // Transaction is already saved; surface the mark-paid error so
            // the user knows the commitment state may be stale.
            return DataError<TransactionEntity>(error);
          case DataSuccess():
            return DataSuccess<TransactionEntity>(data);
        }
    }
  }
}

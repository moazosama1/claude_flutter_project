import '../../core/utils/data_result.dart';
import '../entities/commitment_entity.dart';

abstract class CommitmentsRepo {
  Future<DataResult<List<CommitmentEntity>>> getCommitments();

  /// Upsert by id: id == 0 inserts a new row, non-zero updates in place.
  Future<DataResult<CommitmentEntity>> setCommitment(CommitmentEntity commitment);

  Future<DataResult<void>> deleteCommitment(int id);

  /// Stamps [id]'s `lastPaidDate` to [paidAt]. Called by [PayCommitmentUseCase]
  /// alongside creating the linked transaction.
  Future<DataResult<CommitmentEntity>> markPaid(int id, DateTime paidAt);
}

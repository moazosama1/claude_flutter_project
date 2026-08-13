import 'package:injectable/injectable.dart';

import '../../core/utils/data_result.dart';
import '../../domain/entities/commitment_entity.dart';
import '../../domain/repo/commitments_repo.dart';
import '../../local/mappers/commitment_mapper.dart';
import '../data_source/commitments_local_data_source.dart';

@Injectable(as: CommitmentsRepo)
class CommitmentsRepoImpl implements CommitmentsRepo {
  final CommitmentsLocalDataSource _local;

  CommitmentsRepoImpl(this._local);

  @override
  Future<DataResult<List<CommitmentEntity>>> getCommitments() => safeDataCall(
    () async => _local.getAll(),
    (list) => list.map((o) => o.toEntity()).toList(),
  );

  @override
  Future<DataResult<CommitmentEntity>> setCommitment(
    CommitmentEntity commitment,
  ) => safeDataCall(
    () async => _local.put(commitment.toObject()),
    (obj) => obj.toEntity(),
  );

  @override
  Future<DataResult<void>> deleteCommitment(int id) async {
    try {
      _local.remove(id);
      return DataSuccess<void>(null);
    } catch (e) {
      return DataError<void>(e);
    }
  }

  @override
  Future<DataResult<CommitmentEntity>> markPaid(int id, DateTime paidAt) =>
      safeDataCall(
        () async => _local.markPaid(id, paidAt),
        (obj) => obj.toEntity(),
      );
}

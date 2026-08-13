import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/commitment_entity.dart';
import '../../repo/commitments_repo.dart';

@injectable
class SetCommitmentUseCase {
  final CommitmentsRepo _repo;

  SetCommitmentUseCase(this._repo);

  Future<DataResult<CommitmentEntity>> call(CommitmentEntity commitment) =>
      _repo.setCommitment(commitment);
}

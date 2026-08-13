import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../entities/commitment_entity.dart';
import '../../repo/commitments_repo.dart';

@injectable
class GetCommitmentsUseCase {
  final CommitmentsRepo _repo;

  GetCommitmentsUseCase(this._repo);

  Future<DataResult<List<CommitmentEntity>>> call() => _repo.getCommitments();
}

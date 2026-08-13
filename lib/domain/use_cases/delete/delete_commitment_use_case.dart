import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/commitments_repo.dart';

@injectable
class DeleteCommitmentUseCase {
  final CommitmentsRepo _repo;

  DeleteCommitmentUseCase(this._repo);

  Future<DataResult<void>> call(int id) => _repo.deleteCommitment(id);
}

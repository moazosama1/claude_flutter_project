import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/backup_repo.dart';

@injectable
class ImportBackupUseCase {
  final BackupRepo _repo;

  ImportBackupUseCase(this._repo);

  Future<DataResult<void>> call(String path) => _repo.importFromFile(path);
}

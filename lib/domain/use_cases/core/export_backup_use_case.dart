import 'package:injectable/injectable.dart';

import '../../../core/utils/data_result.dart';
import '../../repo/backup_repo.dart';

@injectable
class ExportBackupUseCase {
  final BackupRepo _repo;

  ExportBackupUseCase(this._repo);

  Future<DataResult<String>> call() => _repo.exportToFile();
}

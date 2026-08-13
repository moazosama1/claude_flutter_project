import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/backup_serializer.dart';
import '../../core/utils/data_result.dart';
import '../../domain/entities/backup_data_entity.dart';
import '../../domain/repo/backup_repo.dart';
import '../../local/mappers/budget_mapper.dart';
import '../../local/mappers/category_mapper.dart';
import '../../local/mappers/transaction_mapper.dart';
import '../data_source/backup_local_data_source.dart';

@Injectable(as: BackupRepo)
class BackupRepoImpl implements BackupRepo {
  final BackupLocalDataSource _local;

  BackupRepoImpl(this._local);

  @override
  Future<DataResult<String>> exportToFile() async {
    try {
      final backup = BackupDataEntity(
        version: BackupDataEntity.currentVersion,
        exportedAt: DateTime.now(),
        categories: _local.allCategories().map((o) => o.toEntity()).toList(),
        transactions:
            _local.allTransactions().map((o) => o.toEntity()).toList(),
        budgets: _local.allBudgets().map((o) => o.toEntity()).toList(),
      );

      final jsonStr = const JsonEncoder.withIndent('  ')
          .convert(backupToJson(backup));

      final dir = await getTemporaryDirectory();
      final fileName = 'spendly_backup_${_fileDatePart(backup.exportedAt)}.json';
      final path = '${dir.path}/$fileName';
      final file = await File(path).writeAsString(jsonStr);

      // Open the OS share sheet — user picks where the file goes.
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          fileNameOverrides: [fileName],
        ),
      );

      return DataSuccess<String>(file.path);
    } catch (e) {
      return DataError<String>(e);
    }
  }

  @override
  Future<DataResult<void>> importFromFile(String path) async {
    try {
      final content = await File(path).readAsString();
      final raw = jsonDecode(content);
      if (raw is! Map<String, dynamic>) {
        throw const InvalidBackupException(
          'Backup file must be a JSON object at the top level',
        );
      }
      final backup = backupFromJson(raw);

      _local.replaceAll(
        categories: backup.categories.map((e) => e.toObject()).toList(),
        transactions: backup.transactions.map((e) => e.toObject()).toList(),
        budgets: backup.budgets.map((e) => e.toObject()).toList(),
      );

      return DataSuccess<void>(null);
    } catch (e) {
      return DataError<void>(e);
    }
  }

  String _fileDatePart(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }
}

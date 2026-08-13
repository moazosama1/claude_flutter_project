import '../../core/utils/data_result.dart';

abstract class BackupRepo {
  /// Serializes all user data and offers it via the OS share sheet.
  /// Returns the path of the written temp file on success.
  Future<DataResult<String>> exportToFile();

  /// Reads the file at [path], validates it's a supported backup, then
  /// replaces all current data with the backup's contents.
  Future<DataResult<void>> importFromFile(String path);
}

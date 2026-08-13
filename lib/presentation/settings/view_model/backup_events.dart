sealed class BackupEvents {}

class ExportBackupEvent extends BackupEvents {}

class ImportBackupEvent extends BackupEvents {
  final String path;
  ImportBackupEvent(this.path);
}

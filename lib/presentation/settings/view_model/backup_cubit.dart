import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/use_cases/core/export_backup_use_case.dart';
import '../../../domain/use_cases/core/import_backup_use_case.dart';
import 'backup_events.dart';
import 'backup_state.dart';

@injectable
class BackupCubit extends Cubit<BackupState> {
  final ExportBackupUseCase _export;
  final ImportBackupUseCase _import;

  BackupCubit(this._export, this._import) : super(BackupState());

  void doIntent(BackupEvents event) {
    switch (event) {
      case ExportBackupEvent():
        _runExport();
      case ImportBackupEvent():
        _runImport(event.path);
    }
  }

  Future<void> _runExport() async {
    emit(state.copyWith(export: BaseState.loading()));
    final result = await _export();
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(export: BaseState.success(data)));
      case DataError(:final message):
        emit(state.copyWith(export: BaseState.error(message)));
    }
  }

  Future<void> _runImport(String path) async {
    emit(state.copyWith(import: BaseState.loading()));
    final result = await _import(path);
    switch (result) {
      case DataSuccess():
        emit(state.copyWith(import: BaseState.success(null)));
      case DataError(:final message):
        emit(state.copyWith(import: BaseState.error(message)));
    }
  }
}

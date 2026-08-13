import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';

class BackupState extends Equatable {
  final BaseState<String> export;
  final BaseState<void> import;

  BackupState({
    BaseState<String>? export,
    BaseState<void>? import,
  })  : export = export ?? BaseState(),
        import = import ?? BaseState();

  BackupState copyWith({
    BaseState<String>? export,
    BaseState<void>? import,
  }) {
    return BackupState(
      export: export ?? this.export,
      import: import ?? this.import,
    );
  }

  @override
  List<Object?> get props => [export, import];
}

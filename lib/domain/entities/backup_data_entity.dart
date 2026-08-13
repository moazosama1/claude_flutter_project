import 'package:equatable/equatable.dart';

import 'budget_entity.dart';
import 'category_entity.dart';
import 'transaction_entity.dart';

/// Full snapshot of user data used for export/import. Versioned so future
/// schema changes can migrate older backups instead of rejecting them.
class BackupDataEntity extends Equatable {
  static const int currentVersion = 1;

  final int version;
  final DateTime exportedAt;
  final List<CategoryEntity> categories;
  final List<TransactionEntity> transactions;
  final List<BudgetEntity> budgets;

  const BackupDataEntity({
    required this.version,
    required this.exportedAt,
    required this.categories,
    required this.transactions,
    required this.budgets,
  });

  @override
  List<Object?> get props => [
    version,
    exportedAt,
    categories,
    transactions,
    budgets,
  ];
}

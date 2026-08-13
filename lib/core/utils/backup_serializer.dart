import '../../domain/entities/backup_data_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';

/// Thrown by [backupFromJson] when the payload is not a valid backup.
/// Callers should catch and wrap in a `DataResult.error`.
class InvalidBackupException implements Exception {
  final String message;
  const InvalidBackupException(this.message);

  @override
  String toString() => 'InvalidBackupException: $message';
}

Map<String, dynamic> backupToJson(BackupDataEntity backup) => {
  'version': backup.version,
  'exportedAt': backup.exportedAt.toIso8601String(),
  'categories': backup.categories.map(_categoryToJson).toList(),
  'transactions': backup.transactions.map(_transactionToJson).toList(),
  'budgets': backup.budgets.map(_budgetToJson).toList(),
};

BackupDataEntity backupFromJson(Map<String, dynamic> raw) {
  final version = raw['version'];
  if (version is! int) {
    throw const InvalidBackupException('Missing or invalid version field');
  }
  if (version != BackupDataEntity.currentVersion) {
    throw InvalidBackupException(
      'Unsupported backup version: $version (expected ${BackupDataEntity.currentVersion})',
    );
  }

  final exportedAtRaw = raw['exportedAt'];
  final exportedAt = exportedAtRaw is String
      ? DateTime.tryParse(exportedAtRaw) ?? DateTime.now()
      : DateTime.now();

  final categories = _requireList(raw, 'categories')
      .map((e) => _categoryFromJson(e as Map<String, dynamic>))
      .toList();
  final transactions = _requireList(raw, 'transactions')
      .map((e) => _transactionFromJson(e as Map<String, dynamic>))
      .toList();
  final budgets = _requireList(raw, 'budgets')
      .map((e) => _budgetFromJson(e as Map<String, dynamic>))
      .toList();

  return BackupDataEntity(
    version: version,
    exportedAt: exportedAt,
    categories: categories,
    transactions: transactions,
    budgets: budgets,
  );
}

List<dynamic> _requireList(Map<String, dynamic> raw, String key) {
  final value = raw[key];
  if (value is! List) {
    throw InvalidBackupException('Missing or invalid `$key` array');
  }
  return value;
}

// -- Per-entity encode --------------------------------------------------

Map<String, dynamic> _categoryToJson(CategoryEntity c) => {
  'id': c.id,
  'name': c.name,
  'iconCodePoint': c.iconCodePoint,
  'colorHex': c.colorHex,
  'typeIndex': c.type.index,
};

Map<String, dynamic> _transactionToJson(TransactionEntity t) => {
  'id': t.id,
  'amount': t.amount,
  'typeIndex': t.type.index,
  'categoryId': t.categoryId,
  'note': t.note,
  'date': t.date.millisecondsSinceEpoch,
  'createdAt': t.createdAt.millisecondsSinceEpoch,
};

Map<String, dynamic> _budgetToJson(BudgetEntity b) => {
  'id': b.id,
  'categoryId': b.categoryId,
  'monthlyLimit': b.monthlyLimit,
};

// -- Per-entity decode --------------------------------------------------

CategoryEntity _categoryFromJson(Map<String, dynamic> j) => CategoryEntity(
  id: (j['id'] as num).toInt(),
  name: j['name'] as String,
  iconCodePoint: (j['iconCodePoint'] as num).toInt(),
  colorHex: j['colorHex'] as String,
  type: _typeFromIndex(j['typeIndex']),
);

TransactionEntity _transactionFromJson(Map<String, dynamic> j) =>
    TransactionEntity(
      id: (j['id'] as num).toInt(),
      amount: (j['amount'] as num).toDouble(),
      type: _typeFromIndex(j['typeIndex']),
      categoryId: (j['categoryId'] as num).toInt(),
      note: j['note'] as String?,
      date: DateTime.fromMillisecondsSinceEpoch((j['date'] as num).toInt()),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (j['createdAt'] as num).toInt(),
      ),
    );

BudgetEntity _budgetFromJson(Map<String, dynamic> j) => BudgetEntity(
  id: (j['id'] as num).toInt(),
  categoryId: (j['categoryId'] as num).toInt(),
  monthlyLimit: (j['monthlyLimit'] as num).toDouble(),
);

TransactionType _typeFromIndex(dynamic raw) {
  final i = raw is num ? raw.toInt() : 0;
  if (i < 0 || i >= TransactionType.values.length) {
    throw InvalidBackupException('Invalid typeIndex: $i');
  }
  return TransactionType.values[i];
}

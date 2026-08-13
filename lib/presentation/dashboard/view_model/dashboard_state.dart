import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';

class DashboardState extends Equatable {
  final BaseState<List<TransactionEntity>> transactions;
  final BaseState<List<CategoryEntity>> categories;

  DashboardState({
    BaseState<List<TransactionEntity>>? transactions,
    BaseState<List<CategoryEntity>>? categories,
  })  : transactions = transactions ?? BaseState(),
        categories = categories ?? BaseState();

  DashboardState copyWith({
    BaseState<List<TransactionEntity>>? transactions,
    BaseState<List<CategoryEntity>>? categories,
  }) {
    return DashboardState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
    );
  }

  List<TransactionEntity> get _txns => transactions.data ?? const [];

  double get totalIncome => _txns
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => _txns
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get balance => totalIncome - totalExpense;

  /// Expense sums grouped by category. Categories with no matching entity are
  /// skipped — chart legend can't render them safely.
  Map<CategoryEntity, double> get expenseByCategory {
    final cats = categories.data ?? const <CategoryEntity>[];
    final byId = {for (final c in cats) c.id: c};
    final out = <CategoryEntity, double>{};
    for (final t in _txns) {
      if (t.type != TransactionType.expense) continue;
      final cat = byId[t.categoryId];
      if (cat == null) continue;
      out.update(cat, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    return out;
  }

  @override
  List<Object?> get props => [transactions, categories];
}

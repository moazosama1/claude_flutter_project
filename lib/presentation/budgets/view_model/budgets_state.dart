import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';
import '../../../domain/entities/budget_entity.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../view/widgets/budget_status.dart';
import 'budget_progress.dart';

class BudgetsState extends Equatable {
  final BaseState<List<BudgetEntity>> budgets;
  final BaseState<List<TransactionEntity>> monthTransactions;
  final BaseState<List<CategoryEntity>> categories;
  final BaseState<BudgetEntity> mutation;

  BudgetsState({
    BaseState<List<BudgetEntity>>? budgets,
    BaseState<List<TransactionEntity>>? monthTransactions,
    BaseState<List<CategoryEntity>>? categories,
    BaseState<BudgetEntity>? mutation,
  })  : budgets = budgets ?? BaseState(),
        monthTransactions = monthTransactions ?? BaseState(),
        categories = categories ?? BaseState(),
        mutation = mutation ?? BaseState();

  BudgetsState copyWith({
    BaseState<List<BudgetEntity>>? budgets,
    BaseState<List<TransactionEntity>>? monthTransactions,
    BaseState<List<CategoryEntity>>? categories,
    BaseState<BudgetEntity>? mutation,
  }) {
    return BudgetsState(
      budgets: budgets ?? this.budgets,
      monthTransactions: monthTransactions ?? this.monthTransactions,
      categories: categories ?? this.categories,
      mutation: mutation ?? this.mutation,
    );
  }

  List<BudgetEntity> get _budgets => budgets.data ?? const [];
  List<TransactionEntity> get _txns => monthTransactions.data ?? const [];
  List<CategoryEntity> get _cats => categories.data ?? const [];

  /// Joins each budget with its category and this month's summed expense
  /// spend, ordered most-over-budget first. Budgets whose category no longer
  /// exists are skipped. Mirrors [DashboardState.expenseByCategory].
  List<BudgetProgress> get progress {
    final catById = {for (final c in _cats) c.id: c};

    final spentByCategory = <int, double>{};
    for (final t in _txns) {
      if (t.type != TransactionType.expense) continue;
      spentByCategory.update(
        t.categoryId,
        (v) => v + t.amount,
        ifAbsent: () => t.amount,
      );
    }

    final rows = <BudgetProgress>[];
    for (final b in _budgets) {
      final cat = catById[b.categoryId];
      if (cat == null) continue;
      rows.add(
        BudgetProgress(
          budgetId: b.id,
          category: cat,
          limit: b.monthlyLimit,
          spent: spentByCategory[b.categoryId] ?? 0,
        ),
      );
    }
    rows.sort((a, b) => b.ratio.compareTo(a.ratio));
    return rows;
  }

  /// Expense categories that don't yet have a budget — offered in the
  /// add-budget picker.
  List<CategoryEntity> get budgetableCategories {
    final budgetedIds = _budgets.map((b) => b.categoryId).toSet();
    return _cats
        .where((c) => c.type == TransactionType.expense)
        .where((c) => !budgetedIds.contains(c.id))
        .toList();
  }

  int get overBudgetCount =>
      progress.where((p) => p.status == BudgetStatus.over).length;

  int get nearLimitCount =>
      progress.where((p) => p.status == BudgetStatus.near).length;

  bool get hasAnyBudget => _budgets.isNotEmpty;

  @override
  List<Object?> get props => [
    budgets,
    monthTransactions,
    categories,
    mutation,
  ];
}

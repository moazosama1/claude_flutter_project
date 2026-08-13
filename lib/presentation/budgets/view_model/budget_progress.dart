import '../../../domain/entities/category_entity.dart';
import '../view/widgets/budget_status.dart';

/// A view-model row joining a budget's limit with the live spend for its
/// category and a derived status. Computed on the fly in [BudgetsState];
/// never stored.
class BudgetProgress {
  final int budgetId;
  final CategoryEntity category;
  final double limit;
  final double spent;

  const BudgetProgress({
    required this.budgetId,
    required this.category,
    required this.limit,
    required this.spent,
  });

  double get ratio => limit <= 0 ? 0 : spent / limit;

  double get remaining => limit - spent;

  BudgetStatus get status => statusFor(ratio);
}

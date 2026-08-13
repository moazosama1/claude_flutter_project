import '../../../domain/entities/budget_entity.dart';

sealed class BudgetsEvents {}

class LoadBudgetsEvent extends BudgetsEvents {}

class SubmitBudgetEvent extends BudgetsEvents {
  final BudgetEntity budget;
  SubmitBudgetEvent(this.budget);
}

class DeleteBudgetEvent extends BudgetsEvents {
  final int id;
  DeleteBudgetEvent(this.id);
}

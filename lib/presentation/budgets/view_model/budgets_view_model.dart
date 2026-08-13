import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/entities/budget_entity.dart';
import '../../../domain/use_cases/add/set_budget_use_case.dart';
import '../../../domain/use_cases/delete/delete_budget_use_case.dart';
import '../../../domain/use_cases/get/get_budgets_use_case.dart';
import '../../../domain/use_cases/get/get_categories_use_case.dart';
import '../../../domain/use_cases/get/get_transactions_use_case.dart';
import 'budgets_events.dart';
import 'budgets_state.dart';

@lazySingleton
class BudgetsViewModel extends Cubit<BudgetsState> {
  final GetBudgetsUseCase _getBudgets;
  final SetBudgetUseCase _setBudget;
  final DeleteBudgetUseCase _deleteBudget;
  final GetTransactionsUseCase _getTransactions;
  final GetCategoriesUseCase _getCategories;

  BudgetsViewModel(
    this._getBudgets,
    this._setBudget,
    this._deleteBudget,
    this._getTransactions,
    this._getCategories,
  ) : super(BudgetsState()) {
    _init();
  }

  void doIntent(BudgetsEvents event) {
    switch (event) {
      case LoadBudgetsEvent():
        _load();
      case SubmitBudgetEvent():
        _submit(event.budget);
      case DeleteBudgetEvent():
        _delete(event.id);
    }
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(
      budgets: BaseState.loading(),
      monthTransactions: BaseState.loading(),
      categories: BaseState.loading(),
    ));

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);

    final results = await Future.wait([
      _getBudgets(),
      _getTransactions(from: from, to: to),
      _getCategories(),
    ]);

    final budgetResult = results[0] as DataResult;
    final txnResult = results[1] as DataResult;
    final catResult = results[2] as DataResult;

    switch (budgetResult) {
      case DataSuccess(:final data):
        emit(state.copyWith(budgets: BaseState.success(data as dynamic)));
      case DataError(:final message):
        emit(state.copyWith(budgets: BaseState.error(message)));
    }

    switch (txnResult) {
      case DataSuccess(:final data):
        emit(state.copyWith(
          monthTransactions: BaseState.success(data as dynamic),
        ));
      case DataError(:final message):
        emit(state.copyWith(monthTransactions: BaseState.error(message)));
    }

    switch (catResult) {
      case DataSuccess(:final data):
        emit(state.copyWith(categories: BaseState.success(data as dynamic)));
      case DataError(:final message):
        emit(state.copyWith(categories: BaseState.error(message)));
    }
  }

  Future<void> _submit(BudgetEntity budget) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _setBudget(budget);
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(mutation: BaseState.success(data)));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _delete(int id) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _deleteBudget(id);
    switch (result) {
      case DataSuccess():
        // Sentinel signals a delete to the view's listener (id 0 == not a
        // real saved budget). Matches the transactions delete pattern.
        emit(state.copyWith(
          mutation: BaseState.success(
            BudgetEntity(id: 0, categoryId: 0, monthlyLimit: 1),
          ),
        ));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }
}

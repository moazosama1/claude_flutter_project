import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/use_cases/add/add_transaction_use_case.dart';
import '../../../domain/use_cases/delete/delete_transaction_use_case.dart';
import '../../../domain/use_cases/get/get_categories_use_case.dart';
import '../../../domain/use_cases/get/get_transactions_use_case.dart';
import '../../../domain/use_cases/update/update_transaction_use_case.dart';
import 'transactions_events.dart';
import 'transactions_state.dart';

@lazySingleton
class TransactionsViewModel extends Cubit<TransactionsState> {
  final GetTransactionsUseCase _getTransactions;
  final GetCategoriesUseCase _getCategories;
  final AddTransactionUseCase _addTransaction;
  final UpdateTransactionUseCase _updateTransaction;
  final DeleteTransactionUseCase _deleteTransaction;

  TransactionsViewModel(
    this._getTransactions,
    this._getCategories,
    this._addTransaction,
    this._updateTransaction,
    this._deleteTransaction,
  ) : super(TransactionsState()) {
    _init();
  }

  void doIntent(TransactionsEvents event) {
    switch (event) {
      case LoadTransactionsEvent():
        _loadTransactions(month: event.month);
      case LoadCategoriesTransactionsEvent():
        _loadCategories();
      case SubmitTransactionEvent():
        _submit(event.txn);
      case DeleteTransactionEvent():
        _delete(event.id);
      case ChangeMonthTransactionsEvent():
        _changeMonth(event.month);
    }
  }

  Future<void> _init() async {
    await Future.wait([_loadTransactions(), _loadCategories()]);
  }

  Future<void> _loadTransactions({DateTime? month}) async {
    emit(state.copyWith(transactions: BaseState.loading()));

    final DateTime? from;
    final DateTime? to;
    if (month != null) {
      from = DateTime(month.year, month.month, 1);
      // Last microsecond of the last day of `month`.
      to = DateTime(month.year, month.month + 1, 0, 23, 59, 59, 999);
    } else {
      from = null;
      to = null;
    }

    final result = await _getTransactions(from: from, to: to);
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(transactions: BaseState.success(data)));
      case DataError(:final message):
        emit(state.copyWith(transactions: BaseState.error(message)));
    }
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(categories: BaseState.loading()));
    final result = await _getCategories();
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(categories: BaseState.success(data)));
      case DataError(:final message):
        emit(state.copyWith(categories: BaseState.error(message)));
    }
  }

  Future<void> _submit(TransactionEntity txn) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = txn.id == 0
        ? await _addTransaction(txn)
        : await _updateTransaction(txn);
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(mutation: BaseState.success(data)));
        await _loadTransactions(month: state.selectedMonth);
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _delete(int id) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _deleteTransaction(id);
    switch (result) {
      case DataSuccess():
        // Sentinel entity signals "deleted" to the view's BlocListener.
        // Distinguished from a submit success in the view by checking id == 0
        // AND amount == 0 (only .empty() produces that combination).
        emit(state.copyWith(mutation: BaseState.success(TransactionEntity.empty())));
        await _loadTransactions(month: state.selectedMonth);
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _changeMonth(DateTime? m) async {
    emit(state.copyWith(selectedMonth: m));
    await _loadTransactions(month: m);
  }
}

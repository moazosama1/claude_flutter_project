import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/use_cases/get/get_categories_use_case.dart';
import '../../../domain/use_cases/get/get_transactions_use_case.dart';
import 'dashboard_events.dart';
import 'dashboard_state.dart';

@lazySingleton
class DashboardViewModel extends Cubit<DashboardState> {
  final GetTransactionsUseCase _getTransactions;
  final GetCategoriesUseCase _getCategories;

  DashboardViewModel(this._getTransactions, this._getCategories)
      : super(DashboardState()) {
    _init();
  }

  void doIntent(DashboardEvents event) {
    switch (event) {
      case LoadDashboardEvent():
        _load();
      case RefreshDashboardEvent():
        _load();
    }
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(
      transactions: BaseState.loading(),
      categories: BaseState.loading(),
    ));

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1);
    final to = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);

    final results = await Future.wait([
      _getTransactions(from: from, to: to),
      _getCategories(),
    ]);

    final txnResult = results[0] as DataResult;
    final catResult = results[1] as DataResult;

    switch (txnResult) {
      case DataSuccess(:final data):
        emit(state.copyWith(transactions: BaseState.success(data as dynamic)));
      case DataError(:final message):
        emit(state.copyWith(transactions: BaseState.error(message)));
    }

    switch (catResult) {
      case DataSuccess(:final data):
        emit(state.copyWith(categories: BaseState.success(data as dynamic)));
      case DataError(:final message):
        emit(state.copyWith(categories: BaseState.error(message)));
    }
  }
}

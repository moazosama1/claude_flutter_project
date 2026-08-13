import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';

class TransactionsState extends Equatable {
  final BaseState<List<TransactionEntity>> transactions;
  final BaseState<List<CategoryEntity>> categories;
  final DateTime? selectedMonth;
  final BaseState<TransactionEntity> mutation;

  TransactionsState({
    BaseState<List<TransactionEntity>>? transactions,
    BaseState<List<CategoryEntity>>? categories,
    this.selectedMonth,
    BaseState<TransactionEntity>? mutation,
  }) : transactions = transactions ?? BaseState(),
       categories = categories ?? BaseState(),
       mutation = mutation ?? BaseState();

  TransactionsState copyWith({
    BaseState<List<TransactionEntity>>? transactions,
    BaseState<List<CategoryEntity>>? categories,
    DateTime? selectedMonth,
    BaseState<TransactionEntity>? mutation,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      mutation: mutation ?? this.mutation,
    );
  }

  @override
  List<Object?> get props => [transactions, categories, selectedMonth, mutation];
}

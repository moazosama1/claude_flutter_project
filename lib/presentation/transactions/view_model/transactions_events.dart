import '../../../domain/entities/transaction_entity.dart';

sealed class TransactionsEvents {}

class LoadTransactionsEvent extends TransactionsEvents {
  final DateTime? month;
  LoadTransactionsEvent({this.month});
}

class LoadCategoriesTransactionsEvent extends TransactionsEvents {}

class SubmitTransactionEvent extends TransactionsEvents {
  final TransactionEntity txn;
  SubmitTransactionEvent(this.txn);
}

class DeleteTransactionEvent extends TransactionsEvents {
  final int id;
  DeleteTransactionEvent(this.id);
}

class ChangeMonthTransactionsEvent extends TransactionsEvents {
  final DateTime? month;
  ChangeMonthTransactionsEvent(this.month);
}

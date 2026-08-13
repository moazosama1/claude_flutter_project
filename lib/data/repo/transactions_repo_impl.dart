import 'package:injectable/injectable.dart';

import '../../core/utils/data_result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repo/transactions_repo.dart';
import '../../local/mappers/category_mapper.dart';
import '../../local/mappers/transaction_mapper.dart';
import '../data_source/transactions_local_data_source.dart';

@Injectable(as: TransactionsRepo)
class TransactionsRepoImpl implements TransactionsRepo {
  final TransactionsLocalDataSource _local;

  TransactionsRepoImpl(this._local);

  @override
  Future<DataResult<List<TransactionEntity>>> getTransactions({
    DateTime? from,
    DateTime? to,
  }) => safeDataCall(
    () async => _local.getAll(from: from, to: to),
    (list) => list.map((o) => o.toEntity()).toList(),
  );

  @override
  Future<DataResult<TransactionEntity>> addTransaction(TransactionEntity txn) =>
      safeDataCall(
        () async => _local.add(txn.toObject()),
        (obj) => obj.toEntity(),
      );

  @override
  Future<DataResult<TransactionEntity>> updateTransaction(
    TransactionEntity txn,
  ) => safeDataCall(
    () async => _local.update(txn.toObject()),
    (obj) => obj.toEntity(),
  );

  // safeDataCall<TIn, TOut> can't cleanly produce DataResult<void> because the
  // TOut = void case forces us to pass `null` through a `void` slot (lint
  // `avoid_returning_null_for_void` fires). Hand-writing the try/catch keeps
  // the surface honest — same shape as safeDataCall internally.
  @override
  Future<DataResult<void>> deleteTransaction(int id) async {
    try {
      _local.delete(id);
      return DataSuccess<void>(null);
    } catch (e) {
      return DataError<void>(e);
    }
  }

  @override
  Future<DataResult<List<CategoryEntity>>> getCategories() => safeDataCall(
    () async => _local.getCategories(),
    (list) => list.map((o) => o.toEntity()).toList(),
  );

  @override
  Future<DataResult<CategoryEntity>> addCategory(CategoryEntity category) =>
      safeDataCall(
        () async => _local.addCategory(category.toObject()),
        (obj) => obj.toEntity(),
      );

  @override
  Future<DataResult<CategoryEntity>> updateCategory(CategoryEntity category) =>
      safeDataCall(
        () async => _local.updateCategory(category.toObject()),
        (obj) => obj.toEntity(),
      );

  @override
  Future<DataResult<void>> deleteCategory(int id) async {
    try {
      _local.deleteCategory(id);
      return DataSuccess<void>(null);
    } catch (e) {
      return DataError<void>(e);
    }
  }
}

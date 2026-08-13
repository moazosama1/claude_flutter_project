import '../../core/utils/data_result.dart';
import '../entities/category_entity.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionsRepo {
  Future<DataResult<List<TransactionEntity>>> getTransactions({
    DateTime? from,
    DateTime? to,
  });

  Future<DataResult<TransactionEntity>> addTransaction(TransactionEntity txn);

  Future<DataResult<TransactionEntity>> updateTransaction(
    TransactionEntity txn,
  );

  Future<DataResult<void>> deleteTransaction(int id);

  Future<DataResult<List<CategoryEntity>>> getCategories();

  Future<DataResult<CategoryEntity>> addCategory(CategoryEntity category);

  Future<DataResult<CategoryEntity>> updateCategory(CategoryEntity category);

  /// Fails with a clear error if the category is referenced by any
  /// transaction or budget — callers should surface that message to the user.
  Future<DataResult<void>> deleteCategory(int id);
}

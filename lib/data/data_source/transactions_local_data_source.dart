import '../../local/models/category_object.dart';
import '../../local/models/transaction_object.dart';

abstract class TransactionsLocalDataSource {
  List<TransactionObject> getAll({DateTime? from, DateTime? to});

  TransactionObject add(TransactionObject obj);

  TransactionObject update(TransactionObject obj);

  void delete(int id);

  List<CategoryObject> getCategories();

  CategoryObject addCategory(CategoryObject obj);

  CategoryObject updateCategory(CategoryObject obj);

  /// Throws [CategoryInUseException] if any transaction or budget references
  /// the given category id.
  void deleteCategory(int id);
}

/// Signals a delete-category attempt on a category that's still referenced.
/// The presentation layer converts this to a user-facing "cannot delete" toast.
class CategoryInUseException implements Exception {
  final int transactionCount;
  final int budgetCount;
  const CategoryInUseException(this.transactionCount, this.budgetCount);

  @override
  String toString() =>
      'CategoryInUseException(transactions: $transactionCount, budgets: $budgetCount)';
}

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../data/data_source/transactions_local_data_source.dart';
import '../../local/models/budget_object.dart';
import '../../local/models/category_object.dart';
import '../../local/models/transaction_object.dart';
// objectbox.g.dart re-exports Store/Box/Condition/QueryBuilder — no need to
// import `package:objectbox/objectbox.dart` separately.
import '../../objectbox.g.dart';

@Injectable(as: TransactionsLocalDataSource)
class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  final Store _store;
  late final Box<TransactionObject> _txnBox = _store.box<TransactionObject>();
  late final Box<CategoryObject> _categoryBox = _store.box<CategoryObject>();
  // Used only for the in-use check on deleteCategory.
  late final Box<BudgetObject> _budgetBox = _store.box<BudgetObject>();

  TransactionsLocalDataSourceImpl(this._store);

  @override
  List<TransactionObject> getAll({DateTime? from, DateTime? to}) {
    if (from == null && to == null) {
      return _txnBox.getAll();
    }

    final Condition<TransactionObject> condition;
    if (from != null && to != null) {
      condition = TransactionObject_.date.between(
        from.millisecondsSinceEpoch,
        to.millisecondsSinceEpoch,
      );
    } else if (from != null) {
      condition = TransactionObject_.date.greaterOrEqual(
        from.millisecondsSinceEpoch,
      );
    } else {
      condition = TransactionObject_.date.lessOrEqual(
        to!.millisecondsSinceEpoch,
      );
    }

    final query = _txnBox.query(condition).build();
    try {
      return query.find();
    } finally {
      query.close();
    }
  }

  @override
  TransactionObject add(TransactionObject obj) {
    _txnBox.put(obj); // ObjectBox mutates obj.id in place on insert.
    return obj;
  }

  @override
  TransactionObject update(TransactionObject obj) {
    _txnBox.put(obj); // put upserts by id.
    return obj;
  }

  @override
  void delete(int id) {
    _txnBox.remove(id);
  }

  @override
  List<CategoryObject> getCategories() {
    if (_categoryBox.isEmpty()) {
      _categoryBox.putMany(_defaultCategories());
    }
    return _categoryBox.getAll();
  }

  @override
  CategoryObject addCategory(CategoryObject obj) {
    _categoryBox.put(obj); // put() populates obj.id on insert.
    return obj;
  }

  @override
  CategoryObject updateCategory(CategoryObject obj) {
    _categoryBox.put(obj); // put() is upsert by id.
    return obj;
  }

  @override
  void deleteCategory(int id) {
    // Refuse to delete a category that's still in use — otherwise transactions
    // and budgets would render as "unknown" and confuse the user.
    final txnQuery =
        _txnBox.query(TransactionObject_.categoryId.equals(id)).build();
    final budgetQuery =
        _budgetBox.query(BudgetObject_.categoryId.equals(id)).build();
    try {
      final txnCount = txnQuery.count();
      final budgetCount = budgetQuery.count();
      if (txnCount > 0 || budgetCount > 0) {
        throw CategoryInUseException(txnCount, budgetCount);
      }
    } finally {
      txnQuery.close();
      budgetQuery.close();
    }
    _categoryBox.remove(id);
  }

  // Seeded on first read. Half income (Salary), half expense (the rest).
  // Ids are auto-assigned (0 = new).
  List<CategoryObject> _defaultCategories() => [
    CategoryObject(
      name: 'Food',
      iconCodePoint: Icons.restaurant.codePoint,
      colorHex: '#FF5722',
      typeIndex: 1, // expense
    ),
    CategoryObject(
      name: 'Transport',
      iconCodePoint: Icons.directions_car.codePoint,
      colorHex: '#2196F3',
      typeIndex: 1,
    ),
    CategoryObject(
      name: 'Bills',
      iconCodePoint: Icons.receipt_long.codePoint,
      colorHex: '#F44336',
      typeIndex: 1,
    ),
    CategoryObject(
      name: 'Shopping',
      iconCodePoint: Icons.shopping_bag.codePoint,
      colorHex: '#9C27B0',
      typeIndex: 1,
    ),
    CategoryObject(
      name: 'Other',
      iconCodePoint: Icons.category.codePoint,
      colorHex: '#607D8B',
      typeIndex: 1,
    ),
    CategoryObject(
      name: 'Salary',
      iconCodePoint: Icons.attach_money.codePoint,
      colorHex: '#4CAF50',
      typeIndex: 0, // income
    ),
  ];
}

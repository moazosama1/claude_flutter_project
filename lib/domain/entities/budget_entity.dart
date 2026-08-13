import 'package:equatable/equatable.dart';

class BudgetEntity extends Equatable {
  final int id;
  final int categoryId;
  final double monthlyLimit;

  // Public constructor enforces the domain invariant: a budget limit must be
  // positive. A zero/negative limit is meaningless.
  BudgetEntity({
    required this.id,
    required this.categoryId,
    required this.monthlyLimit,
  }) {
    if (monthlyLimit <= 0) {
      throw ArgumentError.value(
        monthlyLimit,
        'monthlyLimit',
        'must be greater than zero',
      );
    }
  }

  BudgetEntity copyWith({
    int? id,
    int? categoryId,
    double? monthlyLimit,
  }) {
    return BudgetEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      monthlyLimit: monthlyLimit ?? this.monthlyLimit,
    );
  }

  @override
  List<Object?> get props => [id, categoryId, monthlyLimit];
}

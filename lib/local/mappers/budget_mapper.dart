import '../../domain/entities/budget_entity.dart';
import '../models/budget_object.dart';

extension BudgetObjectX on BudgetObject {
  BudgetEntity toEntity() => BudgetEntity(
    id: id,
    categoryId: categoryId,
    monthlyLimit: monthlyLimit,
  );
}

extension BudgetEntityX on BudgetEntity {
  BudgetObject toObject() => BudgetObject(
    id: id,
    categoryId: categoryId,
    monthlyLimit: monthlyLimit,
  );
}

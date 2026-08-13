import '../../domain/entities/transaction_entity.dart';
import '../models/transaction_object.dart';

extension TransactionObjectX on TransactionObject {
  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    type: TransactionType.values[typeIndex],
    categoryId: categoryId,
    note: note,
    date: date,
    createdAt: createdAt,
  );
}

extension TransactionEntityX on TransactionEntity {
  TransactionObject toObject() => TransactionObject(
    id: id,
    amount: amount,
    typeIndex: type.index,
    categoryId: categoryId,
    note: note,
    date: date,
    createdAt: createdAt,
  );
}

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../models/category_object.dart';

extension CategoryObjectX on CategoryObject {
  CategoryEntity toEntity() => CategoryEntity(
    id: id,
    name: name,
    iconCodePoint: iconCodePoint,
    colorHex: colorHex,
    type: TransactionType.values[typeIndex],
  );
}

extension CategoryEntityX on CategoryEntity {
  CategoryObject toObject() => CategoryObject(
    id: id,
    name: name,
    iconCodePoint: iconCodePoint,
    colorHex: colorHex,
    typeIndex: type.index,
  );
}

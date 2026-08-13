import 'package:equatable/equatable.dart';

import '../../../core/utils/base_state.dart';
import '../../../domain/entities/category_entity.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categories;
  final BaseState<CategoryEntity> mutation;

  CategoriesState({
    BaseState<List<CategoryEntity>>? categories,
    BaseState<CategoryEntity>? mutation,
  })  : categories = categories ?? BaseState(),
        mutation = mutation ?? BaseState();

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categories,
    BaseState<CategoryEntity>? mutation,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      mutation: mutation ?? this.mutation,
    );
  }

  @override
  List<Object?> get props => [categories, mutation];
}

import '../../../domain/entities/category_entity.dart';

sealed class CategoriesEvents {}

class LoadCategoriesEvent extends CategoriesEvents {}

class SubmitCategoryEvent extends CategoriesEvents {
  final CategoryEntity category;
  SubmitCategoryEvent(this.category);
}

class DeleteCategoryEvent extends CategoriesEvents {
  final int id;
  DeleteCategoryEvent(this.id);
}

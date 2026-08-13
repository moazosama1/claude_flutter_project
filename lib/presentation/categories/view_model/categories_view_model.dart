import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/base_state.dart';
import '../../../core/utils/data_result.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/use_cases/add/add_category_use_case.dart';
import '../../../domain/use_cases/delete/delete_category_use_case.dart';
import '../../../domain/use_cases/get/get_categories_use_case.dart';
import '../../../domain/use_cases/update/update_category_use_case.dart';
import 'categories_events.dart';
import 'categories_state.dart';

@lazySingleton
class CategoriesViewModel extends Cubit<CategoriesState> {
  final GetCategoriesUseCase _getCategories;
  final AddCategoryUseCase _addCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  CategoriesViewModel(
    this._getCategories,
    this._addCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoriesState()) {
    _init();
  }

  void doIntent(CategoriesEvents event) {
    switch (event) {
      case LoadCategoriesEvent():
        _load();
      case SubmitCategoryEvent():
        _submit(event.category);
      case DeleteCategoryEvent():
        _delete(event.id);
    }
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _load() async {
    emit(state.copyWith(categories: BaseState.loading()));
    final result = await _getCategories();
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(categories: BaseState.success(data)));
      case DataError(:final message):
        emit(state.copyWith(categories: BaseState.error(message)));
    }
  }

  Future<void> _submit(CategoryEntity category) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = category.id == 0
        ? await _addCategory(category)
        : await _updateCategory(category);
    switch (result) {
      case DataSuccess(:final data):
        emit(state.copyWith(mutation: BaseState.success(data)));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }

  Future<void> _delete(int id) async {
    emit(state.copyWith(mutation: BaseState.loading()));
    final result = await _deleteCategory(id);
    switch (result) {
      case DataSuccess():
        // Sentinel: id == 0 tells the view listener this was a delete.
        emit(state.copyWith(
          mutation: BaseState.success(
            const CategoryEntity(
              id: 0,
              name: '_deleted_',
              iconCodePoint: 0,
              colorHex: '#000000',
              type: TransactionType.expense,
            ),
          ),
        ));
        await _load();
      case DataError(:final message):
        emit(state.copyWith(mutation: BaseState.error(message)));
    }
  }
}

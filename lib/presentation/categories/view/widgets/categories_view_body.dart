import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_dialog.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/custom_widget/custom_loading_indicator.dart';
import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/custom_widget/error_state_view.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../view_model/categories_events.dart';
import '../../view_model/categories_state.dart';
import '../../view_model/categories_view_model.dart';
import 'category_form_sheet.dart';
import 'category_list_item.dart';

class CategoriesViewBody extends StatelessWidget {
  const CategoriesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<CategoriesViewModel, CategoriesState>(
          buildWhen: (a, b) => a.categories != b.categories,
          builder: (context, state) {
            if (state.categories.isLoading &&
                (state.categories.data?.isEmpty ?? true)) {
              return const Center(child: CustomLoadingIndicator());
            }
            if (state.categories.errorMessage != null) {
              return ErrorStateView(
                message: state.categories.errorMessage!,
                onRetry: () => context
                    .read<CategoriesViewModel>()
                    .doIntent(LoadCategoriesEvent()),
              );
            }

            final categories = state.categories.data ?? const [];
            if (categories.isEmpty) {
              return EmptyStateView(
                icon: Icons.label_outline_rounded,
                message: context.l10n.noCategories,
              );
            }

            // Sort: expenses first, then income; alphabetical within group.
            final sorted = [...categories]..sort((a, b) {
              final byType = a.type.index.compareTo(b.type.index);
              if (byType != 0) return byType;
              return a.name.compareTo(b.name);
            });

            return ListView.separated(
              padding: const EdgeInsets.only(
                top: AppMeasurements.paddingSmall,
                bottom: AppMeasurements.padding64,
              ),
              itemCount: sorted.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: context.onSurface.withValues(alpha: 0.06),
              ),
              itemBuilder: (context, i) {
                final c = sorted[i];
                return CategoryListItem(
                  category: c,
                  onEdit: () => _openForm(context, c),
                  onDelete: () => _confirmDelete(context, c),
                );
              },
            );
          },
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: AppMeasurements.paddingLarge,
          bottom: AppMeasurements.paddingLarge,
          child: FloatingActionButton.extended(
            onPressed: () => _openForm(context, null),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addCategory),
          ),
        ),
      ],
    );
  }

  void _openForm(BuildContext context, CategoryEntity? initial) {
    final vm = context.read<CategoriesViewModel>();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetCtx) => BlocProvider<CategoriesViewModel>.value(
        value: vm,
        child: CategoryFormSheet(initial: initial),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CategoryEntity category,
  ) async {
    final vm = context.read<CategoriesViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => CustomDialog(
        showCloseButton: false,
        header: Text(
          dialogCtx.l10n.deleteCategoryTitle,
          style: dialogCtx.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogCtx.l10n.deleteCategoryConfirm,
              style: dialogCtx.bodyMedium,
            ),
            const SizedBox(height: AppMeasurements.paddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(false),
                  child: Text(dialogCtx.l10n.cancel),
                ),
                const SizedBox(width: AppMeasurements.paddingSmall),
                CustomElevatedButtonLoading(
                  isLoading: false,
                  onPressed: () => Navigator.of(dialogCtx).pop(true),
                  textButton: dialogCtx.l10n.deleteCategoryTitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      vm.doIntent(DeleteCategoryEvent(category.id));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_loading_indicator.dart';
import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/custom_widget/error_state_view.dart';
import '../../../../core/custom_widget/screen_header.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/budget_entity.dart';
import '../../view_model/budget_progress.dart';
import '../../view_model/budgets_events.dart';
import '../../view_model/budgets_state.dart';
import '../../view_model/budgets_view_model.dart';
import 'budget_form_sheet.dart';
import 'budget_progress_card.dart';

class BudgetsViewBody extends StatelessWidget {
  const BudgetsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(title: context.l10n.budgetsTitle, subtitle: ''),
            const SizedBox(height: AppMeasurements.paddingMedium),
            Expanded(
              child: BlocBuilder<BudgetsViewModel, BudgetsState>(
                builder: (context, state) {
                  if (state.budgets.isLoading &&
                      !state.hasAnyBudget) {
                    return const Center(child: CustomLoadingIndicator());
                  }
                  if (state.budgets.errorMessage != null) {
                    return ErrorStateView(
                      message: state.budgets.errorMessage!,
                      onRetry: () => context
                          .read<BudgetsViewModel>()
                          .doIntent(LoadBudgetsEvent()),
                    );
                  }

                  final rows = state.progress;
                  if (rows.isEmpty) {
                    return EmptyStateView(
                      icon: Icons.savings_outlined,
                      message: context.l10n.noBudgets,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: AppMeasurements.paddingSmall,
                      bottom: AppMeasurements.padding64,
                    ),
                    itemCount: rows.length,
                    itemBuilder: (context, i) {
                      final p = rows[i];
                      return BudgetProgressCard(
                        progress: p,
                        onEdit: () => _openForm(context, p),
                        onDelete: () => context
                            .read<BudgetsViewModel>()
                            .doIntent(DeleteBudgetEvent(p.budgetId)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: AppMeasurements.paddingLarge,
          bottom: AppMeasurements.paddingLarge,
          child: BlocBuilder<BudgetsViewModel, BudgetsState>(
            buildWhen: (a, b) => a.categories != b.categories,
            builder: (context, state) {
              final canAdd = state.budgetableCategories.isNotEmpty;
              return FloatingActionButton.extended(
                onPressed: canAdd ? () => _openForm(context, null) : null,
                icon: const Icon(Icons.add),
                label: Text(context.l10n.addBudget),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openForm(BuildContext context, BudgetProgress? existing) {
    final vm = context.read<BudgetsViewModel>();
    showModalBottomSheet<void>(
      context: context,
      // Root navigator so the sheet renders above the shell's floating bottom
      // nav pill — otherwise the save button hides behind it.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetCtx) => BlocProvider<BudgetsViewModel>.value(
        value: vm,
        child: BudgetFormSheet(
          initial: existing == null
              ? null
              : BudgetEntity(
                  id: existing.budgetId,
                  categoryId: existing.category.id,
                  monthlyLimit: existing.limit,
                ),
          fixedCategory: existing?.category,
        ),
      ),
    );
  }
}

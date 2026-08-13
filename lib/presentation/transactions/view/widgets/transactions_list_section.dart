import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_loading_indicator.dart';
import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/custom_widget/error_state_view.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../view_model/transactions_events.dart';
import '../../view_model/transactions_state.dart';
import '../../view_model/transactions_view_model.dart';
import 'day_group.dart';
import 'delete_transaction_dialog.dart';
import 'transaction_list_item.dart';

class TransactionsListSection extends StatelessWidget {
  final void Function(TransactionEntity txn) onEditRequested;

  const TransactionsListSection({super.key, required this.onEditRequested});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionsViewModel, TransactionsState>(
      buildWhen: (a, b) =>
          a.transactions != b.transactions || a.categories != b.categories,
      builder: (context, state) {
        final txnState = state.transactions;

        if (txnState.isLoading) {
          return const Center(child: CustomLoadingIndicator());
        }

        if (txnState.errorMessage != null) {
          return ErrorStateView(
            message: txnState.errorMessage!,
            onRetry: () => context.read<TransactionsViewModel>().doIntent(
              LoadTransactionsEvent(month: state.selectedMonth),
            ),
          );
        }

        final txns = txnState.data ?? const <TransactionEntity>[];
        if (txns.isEmpty) {
          return EmptyStateView(
            icon: Icons.inbox_outlined,
            message: context.l10n.noTransactions,
          );
        }

        final categories = state.categories.data ?? const <CategoryEntity>[];
        final categoriesById = <int, CategoryEntity>{
          for (final c in categories) c.id: c,
        };

        final grouped = groupByDay(txns);

        return ListView.builder(
          padding: const EdgeInsets.only(
            top: AppMeasurements.paddingMedium,
            bottom: AppMeasurements.padding64,
          ),
          itemCount: grouped.length,
          itemBuilder: (context, groupIndex) {
            final group = grouped[groupIndex];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppMeasurements.paddingSmall,
                  ),
                  child: Text(
                    formatTransactionDayHeader(group.day),
                    style: context.tableDateStyle?.copyWith(
                      color: context.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ...group.items.map(
                  (txn) => TransactionListItem(
                    txn: txn,
                    category: categoriesById[txn.categoryId],
                    onEdit: () => onEditRequested(txn),
                    onDelete: () => _confirmDelete(context, txn),
                  ),
                ),
                const Divider(height: AppMeasurements.paddingLarge),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TransactionEntity txn,
  ) async {
    final vm = context.read<TransactionsViewModel>();
    final confirmed = await showDeleteTransactionDialog(context);
    if (confirmed == true) {
      vm.doIntent(DeleteTransactionEvent(txn.id));
    }
  }
}

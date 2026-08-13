import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/router/route_names.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../transactions/view/widgets/transaction_list_item.dart';
import '../../view_model/dashboard_state.dart';
import '../../view_model/dashboard_view_model.dart';
import 'dashboard_section_header.dart';

class DashboardRecentTransactionsSection extends StatelessWidget {
  const DashboardRecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      buildWhen: (a, b) =>
          a.transactions != b.transactions || a.categories != b.categories,
      builder: (context, state) {
        final txns = state.transactions.data ?? const [];
        final recent = [...txns]..sort((a, b) => b.date.compareTo(a.date));
        final top = recent.take(5).toList();

        final categoriesById = <int, CategoryEntity>{
          for (final c in (state.categories.data ?? const <CategoryEntity>[]))
            c.id: c,
        };

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(
              title: context.l10n.recentTransactions,
              actionLabel: top.isEmpty ? null : context.l10n.seeAll,
              onAction: top.isEmpty
                  ? null
                  : () => context.go(RouteNames.transactions),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMeasurements.paddingMedium,
                vertical: AppMeasurements.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(
                  AppMeasurements.radiusLarge,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.shadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: top.isEmpty
                  ? EmptyStateView(
                      icon: Icons.receipt_long_outlined,
                      message: context.l10n.noTransactions,
                      compact: true,
                    )
                  : Column(
                      children: [
                        for (int i = 0; i < top.length; i++) ...[
                          TransactionListItem(
                            txn: top[i],
                            category: categoriesById[top[i].categoryId],
                          ),
                          if (i < top.length - 1)
                            Divider(
                              height: 1,
                              color: context.onSurface.withValues(alpha: 0.06),
                            ),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

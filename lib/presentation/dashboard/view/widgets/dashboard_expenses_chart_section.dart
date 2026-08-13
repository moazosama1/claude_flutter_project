import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../view_model/dashboard_state.dart';
import '../../view_model/dashboard_view_model.dart';
import 'dashboard_pie_chart.dart';
import 'dashboard_section_header.dart';

class DashboardExpensesChartSection extends StatelessWidget {
  const DashboardExpensesChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      buildWhen: (a, b) =>
          a.transactions != b.transactions || a.categories != b.categories,
      builder: (context, state) {
        final map = state.expenseByCategory;
        final currency = context.select<CoreCubit, String>(
          (c) => c.state.currencyCode,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardSectionHeader(title: context.l10n.expensesByCategory),
            Container(
              padding: const EdgeInsets.all(AppMeasurements.paddingLarge),
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
              child: map.isEmpty
                  ? SizedBox(
                      height: 140,
                      child: EmptyStateView(
                        icon: Icons.pie_chart_outline_rounded,
                        message: context.l10n.noExpensesYet,
                      ),
                    )
                  : DashboardPieChart(
                      entries: map.entries.toList(),
                      currency: currency,
                    ),
            ),
          ],
        );
      },
    );
  }
}

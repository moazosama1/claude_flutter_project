import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import 'dashboard_balance_section.dart';
import 'dashboard_budget_health_section.dart';
import 'dashboard_commitments_due_section.dart';
import 'dashboard_expenses_chart_section.dart';
import 'dashboard_recent_transactions_section.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Format the current month using the active locale so Arabic and English
    // renders both look natural (e.g. "December 2026" / "ديسمبر 2026").
    final monthLabel = DateFormat.yMMMM(
      Localizations.localeOf(context).toLanguageTag(),
    ).format(DateTime.now());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: AppMeasurements.padding64 + AppMeasurements.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: AppMeasurements.paddingSmall,
              bottom: AppMeasurements.paddingLarge,
              left: AppMeasurements.paddingExtraSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.dashboardTitle,
                  style: context.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${context.l10n.thisMonth} • $monthLabel',
                  style: context.labelSmall?.copyWith(
                    color: context.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const DashboardBalanceSection(),
          const SizedBox(height: AppMeasurements.paddingLarge),
          const DashboardCommitmentsDueSection(),
          const DashboardBudgetHealthSection(),
          const DashboardExpensesChartSection(),
          const SizedBox(height: AppMeasurements.paddingLarge),
          const DashboardRecentTransactionsSection(),
        ],
      ),
    );
  }
}

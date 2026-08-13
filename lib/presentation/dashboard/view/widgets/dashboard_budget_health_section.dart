import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/di.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/router/route_names.dart';
import '../../../budgets/view_model/budgets_state.dart';
import '../../../budgets/view_model/budgets_view_model.dart';

/// Compact "budget health" strip for the dashboard. Reads the shared
/// [BudgetsViewModel] singleton and summarizes how many categories are over
/// or near their limit. Hidden entirely when the user has no budgets yet, so
/// it never nags before the feature is in use. Tapping goes to the Budgets tab.
class DashboardBudgetHealthSection extends StatelessWidget {
  const DashboardBudgetHealthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BudgetsViewModel>.value(
      value: getIt<BudgetsViewModel>(),
      child: BlocBuilder<BudgetsViewModel, BudgetsState>(
        builder: (context, state) {
          if (!state.hasAnyBudget) return const SizedBox.shrink();

          final over = state.overBudgetCount;
          final near = state.nearLimitCount;
          final allClear = over == 0 && near == 0;

          final Color accent;
          final IconData icon;
          final String message;
          if (over > 0) {
            accent = context.errorColor;
            icon = Icons.error_outline_rounded;
            message = context.l10n.categoriesOverBudget(over);
          } else if (near > 0) {
            accent = context.warningColor;
            icon = Icons.warning_amber_rounded;
            message = context.l10n.categoriesNearLimit(near);
          } else {
            accent = context.successColor;
            icon = Icons.check_circle_outline_rounded;
            message = context.l10n.budgetHealthAllClear;
          }

          return Padding(
            padding: const EdgeInsets.only(
              bottom: AppMeasurements.paddingLarge,
            ),
            child: Material(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
              child: InkWell(
                borderRadius: BorderRadius.circular(
                  AppMeasurements.radiusLarge,
                ),
                onTap: () => context.go(RouteNames.budgets),
                child: Padding(
                  padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
                  child: Row(
                    children: [
                      Icon(icon, color: accent),
                      const SizedBox(width: AppMeasurements.paddingMedium),
                      Expanded(
                        child: Text(
                          message,
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: allClear ? context.onSurface : accent,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: context.onSurface.withValues(alpha: 0.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

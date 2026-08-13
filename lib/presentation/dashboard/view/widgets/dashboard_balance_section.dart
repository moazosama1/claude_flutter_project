import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../view_model/dashboard_state.dart';
import '../../view_model/dashboard_view_model.dart';
import 'dashboard_flow_chip.dart';

/// Hero balance card. Dominant number on a brand-gradient background, with
/// income/expense breakdown as chips at the bottom.
class DashboardBalanceSection extends StatelessWidget {
  const DashboardBalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardViewModel, DashboardState>(
      buildWhen: (a, b) => a.transactions != b.transactions,
      builder: (context, state) {
        final balance = state.balance;
        final income = state.totalIncome;
        final expense = state.totalExpense;
        final currency = context.select<CoreCubit, String>(
          (c) => c.state.currencyCode,
        );

        return Container(
          padding: const EdgeInsets.all(AppMeasurements.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [context.primaryColor, AppColors.accentViolet],
            ),
            borderRadius: BorderRadius.circular(
              AppMeasurements.radiusExtraLarge,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: context.onPrimary.withValues(alpha: 0.85),
                    size: AppMeasurements.iconMedium,
                  ),
                  const SizedBox(width: AppMeasurements.paddingSmall),
                  Text(
                    context.l10n.balance,
                    style: context.labelMedium?.copyWith(
                      color: context.onPrimary.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppMeasurements.paddingMedium),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  balance.toMoney(currency),
                  style: context.displaySmall?.copyWith(
                    color: context.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppMeasurements.paddingLarge),
              Row(
                children: [
                  Expanded(
                    child: DashboardFlowChip(
                      label: context.l10n.totalIncome,
                      value: income,
                      currency: currency,
                      icon: Icons.arrow_upward_rounded,
                      tint: AppColors.accentEmerald,
                    ),
                  ),
                  const SizedBox(width: AppMeasurements.paddingSmall),
                  Expanded(
                    child: DashboardFlowChip(
                      label: context.l10n.totalExpense,
                      value: expense,
                      currency: currency,
                      icon: Icons.arrow_downward_rounded,
                      tint: AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

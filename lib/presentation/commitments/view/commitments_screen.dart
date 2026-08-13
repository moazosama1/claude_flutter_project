import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import '../../../core/custom_widget/custom_toastification.dart';
import '../../../core/di/di.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../budgets/view_model/budgets_events.dart';
import '../../budgets/view_model/budgets_view_model.dart';
import '../../dashboard/view_model/dashboard_events.dart';
import '../../dashboard/view_model/dashboard_view_model.dart';
import '../../transactions/view_model/transactions_events.dart';
import '../../transactions/view_model/transactions_view_model.dart';
import '../view_model/commitments_state.dart';
import '../view_model/commitments_view_model.dart';
import 'widgets/commitments_view_body.dart';

class CommitmentsScreen extends StatelessWidget {
  const CommitmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommitmentsViewModel>.value(
      value: getIt<CommitmentsViewModel>(),
      child: BlocListener<CommitmentsViewModel, CommitmentsState>(
        listenWhen: (a, b) => a.mutation != b.mutation && !b.mutation.isLoading,
        listener: (context, state) {
          final mutation = state.mutation;
          if (mutation.errorMessage != null) {
            customToastification(
              context,
              ToastificationType.error,
              mutation.errorMessage,
            );
            return;
          }

          final entity = mutation.data;
          if (entity == null) return;

          // Distinguish the three outcomes:
          // - id == 0                    → delete (sentinel)
          // - lastPaidDate freshly set   → pay
          // - else                       → save/edit
          //
          // A "pay" emission always has lastPaidDate == today (same instant),
          // so we approximate by checking that lastPaidDate is within the
          // last minute. Simple, correct enough for a toast.
          final String message;
          if (entity.id == 0) {
            message = context.l10n.commitmentDeleted;
          } else if (entity.lastPaidDate != null &&
              DateTime.now().difference(entity.lastPaidDate!).inMinutes < 1) {
            message = context.l10n.commitmentPaid;
            // Paying creates a transaction → refresh other singletons.
            _refreshDependentSingletons();
          } else {
            message = context.l10n.commitmentSaved;
          }

          customToastification(
            context,
            ToastificationType.success,
            message,
          );
        },
        child: CustomScreenWrapper(
          appBar: AppBar(
            title: Text(context.l10n.commitmentsTitle),
            leading: const BackButton(),
          ),
          body: const CommitmentsViewBody(),
        ),
      ),
    );
  }

  void _refreshDependentSingletons() {
    final txnVm = getIt<TransactionsViewModel>();
    txnVm.doIntent(LoadTransactionsEvent(month: txnVm.state.selectedMonth));
    getIt<DashboardViewModel>().doIntent(RefreshDashboardEvent());
    getIt<BudgetsViewModel>().doIntent(LoadBudgetsEvent());
  }
}

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
import '../view_model/categories_state.dart';
import '../view_model/categories_view_model.dart';
import 'widgets/categories_view_body.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesViewModel>.value(
      value: getIt<CategoriesViewModel>(),
      child: BlocListener<CategoriesViewModel, CategoriesState>(
        listenWhen: (a, b) => a.mutation != b.mutation && !b.mutation.isLoading,
        listener: (context, state) {
          final mutation = state.mutation;
          if (mutation.errorMessage != null) {
            // Nicer copy for the in-use error the data source throws.
            final rawError = mutation.errorMessage!;
            final friendly = rawError.contains('CategoryInUseException')
                ? _friendlyInUseMessage(context, rawError)
                : rawError;
            customToastification(
              context,
              ToastificationType.error,
              friendly,
            );
            return;
          }

          final entity = mutation.data;
          if (entity == null) return;

          // id == 0 sentinel = delete; anything else = save.
          final isDelete = entity.id == 0;
          customToastification(
            context,
            ToastificationType.success,
            isDelete
                ? context.l10n.categoryDeleted
                : context.l10n.categorySaved,
          );

          // Everything that renders categories needs to pick up the change.
          _refreshDependentSingletons();
        },
        child: CustomScreenWrapper(
          appBar: AppBar(
            title: Text(context.l10n.categoriesTitle),
            leading: const BackButton(),
          ),
          body: const CategoriesViewBody(),
        ),
      ),
    );
  }

  void _refreshDependentSingletons() {
    final txnVm = getIt<TransactionsViewModel>();
    txnVm.doIntent(LoadCategoriesTransactionsEvent());
    txnVm.doIntent(LoadTransactionsEvent(month: txnVm.state.selectedMonth));
    getIt<DashboardViewModel>().doIntent(RefreshDashboardEvent());
    getIt<BudgetsViewModel>().doIntent(LoadBudgetsEvent());
  }

  /// The data source throws `CategoryInUseException(txn, budget)`; the
  /// default toString isn't user-friendly. Extract counts if present, fall
  /// back to a generic message otherwise.
  String _friendlyInUseMessage(BuildContext context, String raw) {
    final match = RegExp(r'transactions:\s*(\d+),\s*budgets:\s*(\d+)')
        .firstMatch(raw);
    final txns = int.tryParse(match?.group(1) ?? '') ?? 0;
    final budgets = int.tryParse(match?.group(2) ?? '') ?? 0;
    return context.l10n.cannotDeleteInUse(txns, budgets);
  }
}

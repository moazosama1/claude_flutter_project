import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import '../../../core/custom_widget/custom_toastification.dart';
import '../../../core/di/di.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../view_model/budgets_state.dart';
import '../view_model/budgets_view_model.dart';
import 'widgets/budgets_view_body.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `.value` — BudgetsViewModel is a lazySingleton shared with the dashboard
    // health strip and the nav reload-on-tap; must not be closed on pop.
    return BlocProvider<BudgetsViewModel>.value(
      value: getIt<BudgetsViewModel>(),
      child: BlocListener<BudgetsViewModel, BudgetsState>(
        listenWhen: (a, b) => a.mutation != b.mutation,
        listener: (context, state) {
          final mutation = state.mutation;
          if (mutation.isLoading) return;

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

          // Delete emits a sentinel with id == 0; every real save carries the
          // persisted budget (id > 0).
          final isDelete = entity.id == 0;
          customToastification(
            context,
            ToastificationType.success,
            isDelete ? context.l10n.budgetDeleted : context.l10n.budgetSaved,
          );
        },
        child: const CustomScreenWrapper(body: BudgetsViewBody()),
      ),
    );
  }
}

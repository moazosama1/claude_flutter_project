import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../core/custom_widget/custom_screen_wrapper.dart';
import '../../../core/custom_widget/custom_toastification.dart';
import '../../../core/di/di.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../view_model/transactions_state.dart';
import '../view_model/transactions_view_model.dart';
import 'widgets/transaction_form_section.dart';
import 'widgets/transactions_view_body.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // `.value` — TransactionsViewModel is a lazySingleton; must not be
    // closed when the tab's route is popped.
    return BlocProvider<TransactionsViewModel>.value(
      value: getIt<TransactionsViewModel>(),
      child: BlocListener<TransactionsViewModel, TransactionsState>(
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

          // The delete flow signals success by emitting BaseState.success with
          // TransactionEntity.empty(). Every other mutation carries the real
          // saved entity. Distinguish by id == 0 (only .empty()'s id is 0).
          final isDelete = entity.id == 0;
          customToastification(
            context,
            ToastificationType.success,
            isDelete
                ? context.l10n.transactionDeleted
                : context.l10n.transactionSaved,
          );
        },
        child: Builder(
          builder: (context) => CustomScreenWrapper(
            body: TransactionsViewBody(
              onOpenForm: (initial) => _openForm(context, initial),
            ),
          ),
        ),
      ),
    );
  }

  void _openForm(BuildContext context, TransactionEntity? initial) {
    final vm = context.read<TransactionsViewModel>();
    showModalBottomSheet<void>(
      context: context,
      // Root navigator so the sheet renders above the shell's floating bottom
      // nav pill — otherwise the save button hides behind it.
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetCtx) => BlocProvider<TransactionsViewModel>.value(
        value: vm,
        child: TransactionFormSection(initial: initial),
      ),
    );
  }
}

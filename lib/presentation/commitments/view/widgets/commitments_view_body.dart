import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_dialog.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/custom_widget/custom_loading_indicator.dart';
import '../../../../core/custom_widget/empty_state_view.dart';
import '../../../../core/custom_widget/error_state_view.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/commitment_entity.dart';
import '../../view_model/commitments_events.dart';
import '../../view_model/commitments_state.dart';
import '../../view_model/commitments_view_model.dart';
import 'commitment_form_sheet.dart';
import 'commitment_list_item.dart';

class CommitmentsViewBody extends StatelessWidget {
  const CommitmentsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<CommitmentsViewModel, CommitmentsState>(
          buildWhen: (a, b) => a.commitments != b.commitments,
          builder: (context, state) {
            if (state.commitments.isLoading &&
                (state.commitments.data?.isEmpty ?? true)) {
              return const Center(child: CustomLoadingIndicator());
            }
            if (state.commitments.errorMessage != null) {
              return ErrorStateView(
                message: state.commitments.errorMessage!,
                onRetry: () => context
                    .read<CommitmentsViewModel>()
                    .doIntent(LoadCommitmentsEvent()),
              );
            }

            final rows = state.dueList;
            if (rows.isEmpty) {
              return EmptyStateView(
                icon: Icons.event_repeat_rounded,
                message: context.l10n.noCommitments,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(
                top: AppMeasurements.paddingMedium,
                bottom: AppMeasurements.padding64,
              ),
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final due = rows[i];
                return CommitmentListItem(
                  due: due,
                  onEdit: () => _openForm(context, due.commitment),
                  onDelete: () => _confirmDelete(context, due.commitment),
                  onPay: () => context
                      .read<CommitmentsViewModel>()
                      .doIntent(PayCommitmentEvent(due.commitment)),
                );
              },
            );
          },
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: AppMeasurements.paddingLarge,
          bottom: AppMeasurements.paddingLarge,
          child: FloatingActionButton.extended(
            onPressed: () => _openForm(context, null),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addCommitment),
          ),
        ),
      ],
    );
  }

  void _openForm(BuildContext context, CommitmentEntity? initial) {
    final vm = context.read<CommitmentsViewModel>();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetCtx) => BlocProvider<CommitmentsViewModel>.value(
        value: vm,
        child: CommitmentFormSheet(initial: initial),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    CommitmentEntity commitment,
  ) async {
    final vm = context.read<CommitmentsViewModel>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => CustomDialog(
        showCloseButton: false,
        header: Text(
          dialogCtx.l10n.deleteCommitmentTitle,
          style: dialogCtx.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dialogCtx.l10n.deleteCommitmentConfirm,
              style: dialogCtx.bodyMedium,
            ),
            const SizedBox(height: AppMeasurements.paddingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(false),
                  child: Text(dialogCtx.l10n.cancel),
                ),
                const SizedBox(width: AppMeasurements.paddingSmall),
                CustomElevatedButtonLoading(
                  isLoading: false,
                  onPressed: () => Navigator.of(dialogCtx).pop(true),
                  textButton: dialogCtx.l10n.deleteCommitmentTitle,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      vm.doIntent(DeleteCommitmentEvent(commitment.id));
    }
  }
}

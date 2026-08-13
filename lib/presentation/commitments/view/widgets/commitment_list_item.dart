import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../view_model/commitment_due_status.dart';
import 'commitment_kind_helpers.dart';

class CommitmentListItem extends StatelessWidget {
  final CommitmentDue due;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onPay;

  const CommitmentListItem({
    super.key,
    required this.due,
    required this.onEdit,
    required this.onDelete,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    final commitment = due.commitment;
    final currency = context.select<CoreCubit, String>(
      (c) => c.state.currencyCode,
    );
    final accent = _statusColor(context, due.status);
    final statusLabel = _statusLabel(context, due.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppMeasurements.paddingMedium),
      padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commitment.name,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${kindLabel(context, commitment.kind)} · '
                      '${frequencyLabel(context, commitment.frequency)}',
                      style: context.labelSmall?.copyWith(
                        color: context.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              _StatusBadge(label: statusLabel, accent: accent),
              PopupMenuButton<_Action>(
                icon: Icon(
                  Icons.more_vert,
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
                onSelected: (a) {
                  switch (a) {
                    case _Action.edit:
                      onEdit();
                    case _Action.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _Action.edit,
                    child: Text(context.l10n.editCommitment),
                  ),
                  PopupMenuItem(
                    value: _Action.delete,
                    child: Text(context.l10n.deleteCommitmentTitle),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppMeasurements.paddingSmall),
          Row(
            children: [
              Icon(
                Icons.event_rounded,
                size: AppMeasurements.iconSmall,
                color: context.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: AppMeasurements.paddingExtraSmall),
              Text(
                context.l10n.dueOn(
                  DateFormatter.format(due.nextDueDate, pattern: 'd MMM yyyy'),
                ),
                style: context.labelSmall?.copyWith(
                  color: context.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const Spacer(),
              Text(
                commitment.amount.toMoney(currency),
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppMeasurements.paddingExtraSmall),
          Text(
            commitment.lastPaidDate == null
                ? context.l10n.neverPaid
                : context.l10n.lastPaid(
                    DateFormatter.format(
                      commitment.lastPaidDate!,
                      pattern: 'd MMM yyyy',
                    ),
                  ),
            style: context.labelSmall?.copyWith(
              color: context.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: AppMeasurements.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: due.status == CommitmentDueStatus.ended ? null : onPay,
              icon: const Icon(Icons.check_rounded, size: 18),
              label: Text(context.l10n.markPaid),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: context.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BuildContext context, CommitmentDueStatus s) {
    switch (s) {
      case CommitmentDueStatus.overdue:
        return context.errorColor;
      case CommitmentDueStatus.dueSoon:
        return context.warningColor;
      case CommitmentDueStatus.upcoming:
        return context.primaryColor;
      case CommitmentDueStatus.ended:
        return context.onSurface.withValues(alpha: 0.5);
    }
  }

  String _statusLabel(BuildContext context, CommitmentDueStatus s) {
    switch (s) {
      case CommitmentDueStatus.overdue:
        return context.l10n.overdue;
      case CommitmentDueStatus.dueSoon:
        return context.l10n.dueSoon;
      case CommitmentDueStatus.upcoming:
        return context.l10n.upNext;
      case CommitmentDueStatus.ended:
        return context.l10n.endDate;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color accent;

  const _StatusBadge({required this.label, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppMeasurements.paddingSmall,
        vertical: AppMeasurements.paddingExtraSmall,
      ),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
      ),
      child: Text(
        label,
        style: context.labelSmall?.copyWith(
          color: accent,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum _Action { edit, delete }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../transactions/view/widgets/category_name_localization.dart';
import '../../view_model/budget_progress.dart';
import 'budget_status.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetProgress progress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BudgetProgressCard({
    super.key,
    required this.progress,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = context.select<CoreCubit, String>(
      (c) => c.state.currencyCode,
    );
    final status = progress.status;
    final accent = budgetStatusColor(context, status);
    final categoryColor = _parseHex(progress.category.colorHex);
    final ratio = progress.ratio.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: AppMeasurements.paddingMedium),
      padding: const EdgeInsets.all(AppMeasurements.paddingMedium),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusLarge),
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
              Container(
                width: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
                height: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(
                    AppMeasurements.radiusMedium,
                  ),
                ),
                child: Icon(
                  IconData(
                    progress.category.iconCodePoint,
                    fontFamily: 'MaterialIcons',
                  ),
                  color: categoryColor,
                  size: AppMeasurements.iconMedium,
                ),
              ),
              const SizedBox(width: AppMeasurements.paddingMedium),
              Expanded(
                child: Text(
                  localizeCategoryName(context, progress.category.name),
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _StatusBadge(status: status, accent: accent),
              PopupMenuButton<_CardAction>(
                icon: Icon(
                  Icons.more_vert,
                  color: context.onSurface.withValues(alpha: 0.6),
                ),
                onSelected: (a) => a == _CardAction.edit ? onEdit() : onDelete(),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _CardAction.edit,
                    child: Text(context.l10n.editBudget),
                  ),
                  PopupMenuItem(
                    value: _CardAction.delete,
                    child: Text(context.l10n.deleteBudget),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppMeasurements.paddingSmall),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 8,
              backgroundColor: context.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
          const SizedBox(height: AppMeasurements.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.l10n.spent}: ${progress.spent.toMoney(currency)}',
                style: context.labelSmall?.copyWith(
                  color: context.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Text(
                progress.limit.toMoney(currency),
                style: context.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _parseHex(String hex) {
    var cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    return Color(int.parse(cleaned, radix: 16));
  }
}

class _StatusBadge extends StatelessWidget {
  final BudgetStatus status;
  final Color accent;

  const _StatusBadge({required this.status, required this.accent});

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      BudgetStatus.over => context.l10n.overBudget,
      BudgetStatus.near => context.l10n.nearLimit,
      BudgetStatus.under => context.l10n.onTrack,
    };
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

enum _CardAction { edit, delete }

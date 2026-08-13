import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core_cubit/core_cubit.dart';
import '../../../../core/core_cubit/core_state.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import 'category_name_localization.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionEntity txn;
  final CategoryEntity? category;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionListItem({
    super.key,
    required this.txn,
    required this.category,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = txn.type == TransactionType.income;
    final amountColor = isIncome ? context.successColor : context.errorColor;
    final sign = isIncome ? '+' : '-';
    final categoryColor = _parseHex(category?.colorHex);
    final iconData = category != null
        ? IconData(category!.iconCodePoint, fontFamily: 'MaterialIcons')
        : Icons.circle_outlined;

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppMeasurements.paddingSmall,
      ),
      child: Row(
        children: [
          Container(
            width: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
            height: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
            ),
            child: Icon(
              iconData,
              color: categoryColor,
              size: AppMeasurements.iconMedium,
            ),
          ),
          const SizedBox(width: AppMeasurements.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  category != null
                      ? localizeCategoryName(context, category!.name)
                      : context.l10n.unknown,
                  style: context.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (txn.note != null && txn.note!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppMeasurements.paddingExtraSmall,
                    ),
                    child: Text(
                      txn.note!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodySmall?.copyWith(
                        color: context.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppMeasurements.paddingMedium),
          BlocSelector<CoreCubit, CoreState, String>(
            selector: (s) => s.currencyCode,
            builder: (context, code) => Text(
              '$sign${txn.amount.toMoney(code)}',
              style: context.titleMedium?.copyWith(
                color: amountColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (onEdit != null || onDelete != null)
            PopupMenuButton<_ItemAction>(
              icon: Icon(
                Icons.more_vert,
                color: context.onSurface.withValues(alpha: 0.6),
              ),
              onSelected: (action) {
                switch (action) {
                  case _ItemAction.edit:
                    onEdit?.call();
                  case _ItemAction.delete:
                    onDelete?.call();
                }
              },
              itemBuilder: (context) => [
                if (onEdit != null)
                  PopupMenuItem(
                    value: _ItemAction.edit,
                    child: Text(context.l10n.editTransaction),
                  ),
                if (onDelete != null)
                  PopupMenuItem(
                    value: _ItemAction.delete,
                    child: Text(context.l10n.deleteTransaction),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Color _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) return const Color(0xFF9E9E9E);
    var cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) cleaned = 'FF$cleaned';
    return Color(int.parse(cleaned, radix: 16));
  }
}

/// Formats a transaction date for the day-group header. Uses [DateFormatter]
/// from the core utils so the format stays consistent with the rest of the app.
String formatTransactionDayHeader(DateTime date) {
  return DateFormatter.format(date, pattern: 'EEE, d MMM yyyy');
}

enum _ItemAction { edit, delete }

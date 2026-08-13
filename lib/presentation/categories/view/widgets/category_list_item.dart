import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../transactions/view/widgets/category_name_localization.dart';
import 'category_presets.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseCategoryHex(category.colorHex);
    final typeLabel = category.type == TransactionType.income
        ? context.l10n.income
        : context.l10n.expense;

    return InkWell(
      onTap: onEdit,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppMeasurements.paddingMedium,
          vertical: AppMeasurements.paddingMedium,
        ),
        child: Row(
          children: [
            Container(
              width: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
              height: AppMeasurements.iconLarge + AppMeasurements.paddingSmall,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius:
                    BorderRadius.circular(AppMeasurements.radiusMedium),
              ),
              child: Icon(
                IconData(category.iconCodePoint, fontFamily: 'MaterialIcons'),
                color: color,
                size: AppMeasurements.iconMedium,
              ),
            ),
            const SizedBox(width: AppMeasurements.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizeCategoryName(context, category.name),
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    typeLabel,
                    style: context.labelSmall?.copyWith(
                      color: context.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete_outline_rounded,
                color: context.errorColor.withValues(alpha: 0.85),
              ),
              onPressed: onDelete,
              tooltip: context.l10n.deleteCategoryTitle,
            ),
          ],
        ),
      ),
    );
  }
}

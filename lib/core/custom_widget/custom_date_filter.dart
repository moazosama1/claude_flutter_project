import 'package:flutter/material.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import 'package:initialize_project/core/extensions/theme_extension.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';
import 'package:initialize_project/core/custom_widget/compact_date_picker_dialog.dart';
import 'package:initialize_project/core/utils/date_formatter.dart';
import 'package:initialize_project/core/extensions/l10n_extension.dart';

class CustomDateFilter extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?>? onDateChanged;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDateFilter({
    super.key,
    this.selectedDate,
    this.onDateChanged,
    this.label,
    this.firstDate,
    this.lastDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
        border: Border.all(
          color: selectedDate != null
              ? context.primaryColor
              : AppColors.white[60]!,
          width: selectedDate != null ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onDateChanged != null
                  ? () async {
                      final result = await showCompactDatePicker(
                        context,
                        selectedDate ?? DateTime.now(),
                        firstDate: firstDate,
                        lastDate: lastDate,
                      );
                      if (result != null) {
                        if (result.isCleared) {
                          onDateChanged!(null);
                        } else {
                          onDateChanged!(result.date);
                        }
                      }
                    }
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMeasurements.paddingMedium,
                  vertical: AppMeasurements.paddingSmall,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: AppMeasurements.iconSmall,
                      color: selectedDate != null
                          ? context.primaryColor
                          : context.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: AppMeasurements.paddingSmall),
                    Text(
                      selectedDate != null
                          ? (selectedDate!.year == DateTime.now().year &&
                                    selectedDate!.month ==
                                        DateTime.now().month &&
                                    selectedDate!.day == DateTime.now().day
                                ? context.l10n.today
                                : FormateDate.formatShort(
                                    selectedDate.toString(),
                                  ))
                          : (label ?? context.l10n.allDates),
                      style: context.labelSmall?.copyWith(
                        fontWeight: selectedDate != null
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: selectedDate != null
                            ? context.primaryColor
                            : context.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedDate != null) ...[
              Container(
                height: 20,
                width: 1,
                color: context.primaryColor.withValues(alpha: 0.3),
              ),
              InkWell(
                onTap: onDateChanged != null
                    ? () => onDateChanged!(null)
                    : null,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppMeasurements.paddingSmall,
                    vertical: AppMeasurements.paddingSmall,
                  ),
                  child: Icon(
                    Icons.cancel,
                    size: AppMeasurements.iconSmall,
                    color: context.errorColor.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import 'package:initialize_project/core/extensions/l10n_extension.dart';
import 'package:initialize_project/core/extensions/theme_extension.dart';
import 'package:initialize_project/core/responsive/app_measurements.dart';

class CompactDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onSelected;
  final VoidCallback onClear;
  final VoidCallback onToday;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CompactDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onSelected,
    required this.onClear,
    required this.onToday,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CompactDatePickerDialog> createState() =>
      _CompactDatePickerDialogState();
}

class _CompactDatePickerDialogState extends State<CompactDatePickerDialog> {
  late final ValueNotifier<DateTime> _currentDateNotifier;

  @override
  void initState() {
    super.initState();
    DateTime date = widget.initialDate;
    if (widget.firstDate != null && date.isBefore(widget.firstDate!)) {
      date = widget.firstDate!;
    }
    if (widget.lastDate != null && date.isAfter(widget.lastDate!)) {
      date = widget.lastDate!;
    }
    _currentDateNotifier = ValueNotifier<DateTime>(date);
  }

  @override
  void dispose() {
    _currentDateNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: AppMeasurements.dialogElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMeasurements.radiusSmall),
      ),
      child: SizedBox(
        width: AppMeasurements.compactDatePickerWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<DateTime>(
              valueListenable: _currentDateNotifier,
              builder: (context, currentDate, _) {
                return CalendarDatePicker(
                  initialDate: currentDate,
                  firstDate: widget.firstDate ?? DateTime(2020),
                  lastDate: widget.lastDate ?? DateTime(2030),
                  onDateChanged: (date) {
                    _currentDateNotifier.value = date;
                    widget.onSelected(date);
                  },
                );
              },
            ),
            const Divider(height: AppMeasurements.compactDatePickerDividerHeight),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMeasurements.paddingMedium,
                vertical: AppMeasurements.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: widget.onClear,
                    child: Text(
                      context.l10n.clear,
                      style: context.labelLarge?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onToday,
                    child: Text(
                      context.l10n.today,
                      style: context.labelLarge?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompactDatePickerResult {
  final DateTime? date;
  final bool isCleared;

  const CompactDatePickerResult.selected(DateTime this.date) : isCleared = false;
  const CompactDatePickerResult.cleared() : date = null, isCleared = true;
}

Future<CompactDatePickerResult?> showCompactDatePicker(
  BuildContext context,
  DateTime initialDate, {
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  CompactDatePickerResult? result;
  DateTime dateToUse = initialDate;
  if (firstDate != null && dateToUse.isBefore(firstDate)) {
    dateToUse = firstDate;
  }
  if (lastDate != null && dateToUse.isAfter(lastDate)) {
    dateToUse = lastDate;
  }
  await showDialog<void>(
    context: context,
    barrierColor: AppColors.transparent,
    builder: (ctx) => CompactDatePickerDialog(
      initialDate: dateToUse,
      firstDate: firstDate,
      lastDate: lastDate,
      onSelected: (d) {
        result = CompactDatePickerResult.selected(d);
        Navigator.of(ctx).pop();
      },
      onClear: () {
        result = const CompactDatePickerResult.cleared();
        Navigator.of(ctx).pop();
      },
      onToday: () {
        DateTime today = DateTime.now();
        if (firstDate != null && today.isBefore(firstDate)) {
          today = firstDate;
        }
        if (lastDate != null && today.isAfter(lastDate)) {
          today = lastDate;
        }
        result = CompactDatePickerResult.selected(today);
        Navigator.of(ctx).pop();
      },
    ),
  );
  return result;
}

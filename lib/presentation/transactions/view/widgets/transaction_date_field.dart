import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/date_formatter.dart';

class TransactionDateField extends StatelessWidget {
  final DateTime date;
  final Future<void> Function() onPick;

  const TransactionDateField({
    super.key,
    required this.date,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      initialValue: date,
      validator: (d) => (d != null && d.isAfter(DateTime.now()))
          ? context.l10n.dateInFuture
          : null,
      builder: (state) {
        return InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: context.l10n.date,
              border: const OutlineInputBorder(),
              errorText: state.errorText,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ),
            child: Text(
              DateFormatter.format(date, pattern: 'd MMM yyyy'),
              style: context.bodyLarge,
            ),
          ),
        );
      },
    );
  }
}

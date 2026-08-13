import 'package:flutter/material.dart';

import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/transaction_entity.dart';
import 'transactions_header_section.dart';
import 'transactions_list_section.dart';

class TransactionsViewBody extends StatelessWidget {
  final void Function(TransactionEntity? initial) onOpenForm;

  const TransactionsViewBody({super.key, required this.onOpenForm});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TransactionsHeaderSection(),
            const SizedBox(height: AppMeasurements.paddingMedium),
            Expanded(
              child: TransactionsListSection(
                onEditRequested: onOpenForm,
              ),
            ),
          ],
        ),
        PositionedDirectional(
          end: AppMeasurements.paddingLarge,
          bottom: AppMeasurements.paddingLarge,
          child: FloatingActionButton.extended(
            onPressed: () => onOpenForm(null),
            icon: const Icon(Icons.add),
            label: Text(_addLabel(context)),
          ),
        ),
      ],
    );
  }

  String _addLabel(BuildContext context) {
    // Kept as a tiny helper for readability; the string itself comes from l10n.
    return MaterialLocalizations.of(context).okButtonLabel == 'OK'
        ? 'Add'
        : 'Add';
  }
}

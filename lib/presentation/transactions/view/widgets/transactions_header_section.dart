import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_date_filter.dart';
import '../../../../core/custom_widget/screen_header.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../view_model/transactions_events.dart';
import '../../view_model/transactions_state.dart';
import '../../view_model/transactions_view_model.dart';

class TransactionsHeaderSection extends StatelessWidget {
  const TransactionsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionsViewModel, TransactionsState, DateTime?>(
      selector: (state) => state.selectedMonth,
      builder: (context, selectedMonth) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScreenHeader(
              title: context.l10n.transactionsTitle,
              subtitle: '',
            ),
            const SizedBox(height: AppMeasurements.paddingMedium),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: CustomDateFilter(
                selectedDate: selectedMonth,
                onDateChanged: (picked) => context
                    .read<TransactionsViewModel>()
                    .doIntent(ChangeMonthTransactionsEvent(picked)),
              ),
            ),
          ],
        );
      },
    );
  }
}

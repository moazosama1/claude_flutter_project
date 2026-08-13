import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/compact_date_picker_dialog.dart';
import '../../../../core/custom_widget/custom_dropdown_field.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/custom_widget/custom_tab_bar.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../view_model/transactions_events.dart';
import '../../view_model/transactions_state.dart';
import '../../view_model/transactions_view_model.dart';
import 'category_name_localization.dart';
import 'transaction_amount_field.dart';
import 'transaction_date_field.dart';
import 'transaction_note_field.dart';

/// Form for adding/editing a transaction. Form-local reactive state uses
/// `ValueNotifier` per the project rulebook — no `setState`. Text fields
/// keep their `TextEditingController` (already reactive by nature).
class TransactionFormSection extends StatefulWidget {
  final TransactionEntity? initial;

  const TransactionFormSection({super.key, this.initial});

  @override
  State<TransactionFormSection> createState() => _TransactionFormSectionState();
}

class _TransactionFormSectionState extends State<TransactionFormSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;

  // Reactive form state: each field is its own ValueNotifier so only the
  // dependent sub-widget rebuilds on change (no full-form setState).
  late final ValueNotifier<TransactionType> _typeNotifier;
  late final ValueNotifier<DateTime> _dateNotifier;
  late final ValueNotifier<int?> _categoryIdNotifier;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;

    _typeNotifier = ValueNotifier(initial?.type ?? TransactionType.expense);
    _dateNotifier = ValueNotifier(
      (initial != null && initial.date.millisecondsSinceEpoch > 0)
          ? initial.date
          : DateTime.now(),
    );
    _categoryIdNotifier = ValueNotifier(
      (initial?.categoryId != null && initial!.categoryId != 0)
          ? initial.categoryId
          : null,
    );

    // When the type flips, drop the current category selection since the
    // dropdown's items filter by type — otherwise the value could go stale.
    _typeNotifier.addListener(() => _categoryIdNotifier.value = null);

    _amountController = TextEditingController(
      text: (initial != null && initial.amount > 0)
          ? initial.amount.toString()
          : '',
    );
    _noteController = TextEditingController(text: initial?.note ?? '');
  }

  @override
  void dispose() {
    _typeNotifier.dispose();
    _dateNotifier.dispose();
    _categoryIdNotifier.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      TransactionsViewModel,
      TransactionsState,
      List<CategoryEntity>
    >(
      selector: (state) => state.categories.data ?? const <CategoryEntity>[],
      builder: (context, categories) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppMeasurements.paddingLarge,
            right: AppMeasurements.paddingLarge,
            top: AppMeasurements.paddingLarge,
            bottom:
                MediaQuery.of(context).viewInsets.bottom +
                AppMeasurements.paddingLarge,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.initial == null
                        ? context.l10n.addTransaction
                        : context.l10n.editTransaction,
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingLarge),

                  ValueListenableBuilder<TransactionType>(
                    valueListenable: _typeNotifier,
                    builder: (context, type, _) => CustomTabBar<TransactionType>(
                      tabs: [
                        CustomTabItem(
                          label: context.l10n.income,
                          value: TransactionType.income,
                        ),
                        CustomTabItem(
                          label: context.l10n.expense,
                          value: TransactionType.expense,
                        ),
                      ],
                      selectedTab: type,
                      onTabChanged: (v) => _typeNotifier.value = v,
                    ),
                  ),

                  const SizedBox(height: AppMeasurements.paddingLarge),
                  TransactionAmountField(controller: _amountController),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  ListenableBuilder(
                    listenable: Listenable.merge(
                      [_typeNotifier, _categoryIdNotifier],
                    ),
                    builder: (context, _) {
                      final type = _typeNotifier.value;
                      final selectedId = _categoryIdNotifier.value;
                      final filtered = categories
                          .where((c) => c.type == type)
                          .toList(growable: false);
                      final selectedValue =
                          filtered.any((c) => c.id == selectedId)
                          ? filtered.firstWhere((c) => c.id == selectedId)
                          : null;

                      return CustomDropdownField<CategoryEntity>(
                        label: context.l10n.category,
                        items: filtered,
                        value: selectedValue,
                        onChanged: (v) => _categoryIdNotifier.value = v?.id,
                        itemAsString: (c) =>
                            localizeCategoryName(context, c.name),
                        validator: (v) =>
                            v == null ? context.l10n.categoryRequired : null,
                      );
                    },
                  ),

                  const SizedBox(height: AppMeasurements.paddingMedium),

                  ValueListenableBuilder<DateTime>(
                    valueListenable: _dateNotifier,
                    builder: (context, date, _) =>
                        TransactionDateField(date: date, onPick: _pickDate),
                  ),

                  const SizedBox(height: AppMeasurements.paddingMedium),
                  TransactionNoteField(controller: _noteController),
                  const SizedBox(height: AppMeasurements.paddingLarge),

                  BlocSelector<TransactionsViewModel, TransactionsState, bool>(
                    selector: (state) => state.mutation.isLoading,
                    builder: (context, isLoading) =>
                        CustomElevatedButtonLoading(
                          isExpanded: true,
                          isLoading: isLoading,
                          onPressed: () => _onSave(context),
                          textButton: context.l10n.save,
                        ),
                  ),
                  const SizedBox(height: AppMeasurements.appBarHeight),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final result = await showCompactDatePicker(
      context,
      _dateNotifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (result != null && !result.isCleared && result.date != null) {
      _dateNotifier.value = result.date!;
    }
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final note = _noteController.text.trim();
    final now = DateTime.now();
    final initialCreatedAt = widget.initial?.createdAt;
    final createdAt =
        (initialCreatedAt != null &&
            initialCreatedAt.millisecondsSinceEpoch > 0)
        ? initialCreatedAt
        : now;

    final entity = TransactionEntity(
      id: widget.initial?.id ?? 0,
      amount: amount,
      type: _typeNotifier.value,
      categoryId: _categoryIdNotifier.value!,
      note: note.isEmpty ? null : note,
      date: _dateNotifier.value,
      createdAt: createdAt,
    );

    context.read<TransactionsViewModel>().doIntent(
      SubmitTransactionEvent(entity),
    );
    Navigator.of(context).pop();
  }
}

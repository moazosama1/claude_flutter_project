import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/compact_date_picker_dialog.dart';
import '../../../../core/custom_widget/custom_dropdown_field.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/commitment_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../transactions/view/widgets/category_name_localization.dart';
import '../../../transactions/view_model/transactions_state.dart';
import '../../../transactions/view_model/transactions_view_model.dart';
import '../../view_model/commitments_events.dart';
import '../../view_model/commitments_state.dart';
import '../../view_model/commitments_view_model.dart';
import 'commitment_kind_helpers.dart';

/// Add/edit sheet for a commitment. G1 exposes only the fields that apply to
/// every kind (name, amount, frequency, start, endDate) — kind-specific
/// fields (jam'iya payout, installment count, goal target) get their own
/// panels in G2–G4. G1's kind selector still shows all four options but only
/// [CommitmentKind.rent] is fully functional right now.
class CommitmentFormSheet extends StatefulWidget {
  final CommitmentEntity? initial;

  const CommitmentFormSheet({super.key, this.initial});

  @override
  State<CommitmentFormSheet> createState() => _CommitmentFormSheetState();
}

class _CommitmentFormSheetState extends State<CommitmentFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final ValueNotifier<CommitmentKind> _kindNotifier;
  late final ValueNotifier<CommitmentFrequency> _frequencyNotifier;
  late final ValueNotifier<DateTime> _startDateNotifier;
  late final ValueNotifier<DateTime?> _endDateNotifier;
  late final ValueNotifier<int?> _categoryIdNotifier;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _amountController = TextEditingController(
      text: initial?.amount != null && initial!.amount > 0
          ? initial.amount.toString()
          : '',
    );
    _kindNotifier = ValueNotifier(initial?.kind ?? CommitmentKind.rent);
    _frequencyNotifier =
        ValueNotifier(initial?.frequency ?? CommitmentFrequency.monthly);
    _startDateNotifier = ValueNotifier(initial?.startDate ?? DateTime.now());
    _endDateNotifier = ValueNotifier(initial?.endDate);
    _categoryIdNotifier = ValueNotifier(
      initial?.categoryId != null && initial!.categoryId != 0
          ? initial.categoryId
          : null,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _kindNotifier.dispose();
    _frequencyNotifier.dispose();
    _startDateNotifier.dispose();
    _endDateNotifier.dispose();
    _categoryIdNotifier.dispose();
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
        // Commitments are outflows in G1 (rent/subscription), so we filter to
        // expense categories. Jam'iya's payout side lives in G2.
        final expenseCategories =
            categories.where((c) => c.type == TransactionType.expense).toList();

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
                        ? context.l10n.addCommitment
                        : context.l10n.editCommitment,
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingLarge),

                  // Kind picker.
                  ValueListenableBuilder<CommitmentKind>(
                    valueListenable: _kindNotifier,
                    builder: (context, kind, _) =>
                        CustomDropdownField<CommitmentKind>(
                      label: context.l10n.commitmentKind,
                      items: CommitmentKind.values,
                      value: kind,
                      onChanged: (v) {
                        if (v != null) _kindNotifier.value = v;
                      },
                      itemAsString: (k) => kindLabel(context, k),
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  TextFormField(
                    controller: _nameController,
                    maxLength: 60,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.commitmentName,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (raw) {
                      final v = raw?.trim() ?? '';
                      if (v.isEmpty) return context.l10n.categoryNameRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      labelText: context.l10n.amount,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (raw) {
                      final value = raw?.replaceAll(',', '.') ?? '';
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return context.l10n.amountMustBePositive;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  ValueListenableBuilder<CommitmentFrequency>(
                    valueListenable: _frequencyNotifier,
                    builder: (context, freq, _) =>
                        CustomDropdownField<CommitmentFrequency>(
                      label: context.l10n.frequency,
                      items: CommitmentFrequency.values,
                      value: freq,
                      onChanged: (v) {
                        if (v != null) _frequencyNotifier.value = v;
                      },
                      itemAsString: (f) => frequencyLabel(context, f),
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  ValueListenableBuilder<int?>(
                    valueListenable: _categoryIdNotifier,
                    builder: (context, selectedId, _) {
                      final selected = expenseCategories
                          .where((c) => c.id == selectedId)
                          .cast<CategoryEntity?>()
                          .firstWhere((c) => true, orElse: () => null);
                      return CustomDropdownField<CategoryEntity>(
                        label: context.l10n.category,
                        items: expenseCategories,
                        value: selected,
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
                    valueListenable: _startDateNotifier,
                    builder: (context, date, _) => _DateRow(
                      label: context.l10n.startDate,
                      date: date,
                      onPick: _pickStartDate,
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingMedium),

                  ValueListenableBuilder<DateTime?>(
                    valueListenable: _endDateNotifier,
                    builder: (context, date, _) => _DateRow(
                      label: context.l10n.endDateOptional,
                      date: date,
                      onPick: _pickEndDate,
                      onClear: date == null
                          ? null
                          : () => _endDateNotifier.value = null,
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingLarge),

                  BlocSelector<CommitmentsViewModel, CommitmentsState, bool>(
                    selector: (state) => state.mutation.isLoading,
                    builder: (context, isLoading) =>
                        CustomElevatedButtonLoading(
                      isExpanded: true,
                      isLoading: isLoading,
                      onPressed: () => _onSave(context),
                      textButton: context.l10n.save,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickStartDate() async {
    final result = await showCompactDatePicker(
      context,
      _startDateNotifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (result != null && !result.isCleared && result.date != null) {
      _startDateNotifier.value = result.date!;
    }
  }

  Future<void> _pickEndDate() async {
    final result = await showCompactDatePicker(
      context,
      _endDateNotifier.value ?? _startDateNotifier.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (result != null) {
      if (result.isCleared) {
        _endDateNotifier.value = null;
      } else if (result.date != null) {
        _endDateNotifier.value = result.date;
      }
    }
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));
    final entity = CommitmentEntity(
      id: widget.initial?.id ?? 0,
      name: _nameController.text.trim(),
      kind: _kindNotifier.value,
      amount: amount,
      frequency: _frequencyNotifier.value,
      startDate: _startDateNotifier.value,
      endDate: _endDateNotifier.value,
      categoryId: _categoryIdNotifier.value!,
      // Kind-specific fields are added in G2–G4.
      totalInstallments: widget.initial?.totalInstallments,
      lastPaidDate: widget.initial?.lastPaidDate,
      payoutMonth: widget.initial?.payoutMonth,
      payoutAmount: widget.initial?.payoutAmount,
      targetAmount: widget.initial?.targetAmount,
      targetDate: widget.initial?.targetDate,
      notes: widget.initial?.notes,
    );
    context
        .read<CommitmentsViewModel>()
        .doIntent(SubmitCommitmentEvent(entity));
    Navigator.of(context).pop();
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Future<void> Function() onPick;
  final VoidCallback? onClear;

  const _DateRow({
    required this.label,
    required this.date,
    required this.onPick,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: onClear,
                )
              : const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          date == null
              ? '—'
              : DateFormatter.format(date!, pattern: 'd MMM yyyy'),
          style: context.bodyLarge,
        ),
      ),
    );
  }
}

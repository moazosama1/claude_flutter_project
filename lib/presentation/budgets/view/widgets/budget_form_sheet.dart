import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_dropdown_field.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/budget_entity.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../transactions/view/widgets/category_name_localization.dart';
import '../../view_model/budgets_events.dart';
import '../../view_model/budgets_state.dart';
import '../../view_model/budgets_view_model.dart';

/// Bottom sheet for setting or editing a category's monthly budget limit.
/// Form-local state uses ValueNotifier per the rulebook — no setState.
///
/// In add mode ([initial] null) the category dropdown lists only expense
/// categories that don't yet have a budget. In edit mode the category is
/// fixed and only the limit is editable.
class BudgetFormSheet extends StatefulWidget {
  final BudgetEntity? initial;
  final CategoryEntity? fixedCategory;

  const BudgetFormSheet({super.key, this.initial, this.fixedCategory});

  @override
  State<BudgetFormSheet> createState() => _BudgetFormSheetState();
}

class _BudgetFormSheetState extends State<BudgetFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _limitController;
  late final ValueNotifier<int?> _categoryIdNotifier;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _limitController = TextEditingController(
      text: widget.initial != null
          ? widget.initial!.monthlyLimit.toString()
          : '',
    );
    _categoryIdNotifier = ValueNotifier(
      widget.initial?.categoryId ?? widget.fixedCategory?.id,
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    _categoryIdNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BudgetsViewModel, BudgetsState, List<CategoryEntity>>(
      selector: (state) => _isEdit
          ? (widget.fixedCategory != null
                ? [widget.fixedCategory!]
                : const [])
          : state.budgetableCategories,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEdit ? context.l10n.editBudget : context.l10n.setBudget,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppMeasurements.paddingLarge),
                ValueListenableBuilder<int?>(
                  valueListenable: _categoryIdNotifier,
                  builder: (context, selectedId, _) {
                    final selected = categories
                        .where((c) => c.id == selectedId)
                        .cast<CategoryEntity?>()
                        .firstWhere((c) => true, orElse: () => null);
                    return CustomDropdownField<CategoryEntity>(
                      label: context.l10n.category,
                      items: categories,
                      value: selected,
                      onChanged: _isEdit
                          ? null
                          : (v) => _categoryIdNotifier.value = v?.id,
                      itemAsString: (c) =>
                          localizeCategoryName(context, c.name),
                      validator: (v) =>
                          v == null ? context.l10n.categoryRequired : null,
                    );
                  },
                ),
                const SizedBox(height: AppMeasurements.paddingMedium),
                TextFormField(
                  controller: _limitController,
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
                    labelText: context.l10n.monthlyLimit,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (raw) {
                    final value = raw?.replaceAll(',', '.') ?? '';
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return context.l10n.limitMustBePositive;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppMeasurements.paddingLarge),
                BlocSelector<BudgetsViewModel, BudgetsState, bool>(
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
        );
      },
    );
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final limit = double.parse(_limitController.text.replaceAll(',', '.'));
    final entity = BudgetEntity(
      id: widget.initial?.id ?? 0,
      categoryId: _categoryIdNotifier.value!,
      monthlyLimit: limit,
    );

    context.read<BudgetsViewModel>().doIntent(SubmitBudgetEvent(entity));
    Navigator.of(context).pop();
  }
}

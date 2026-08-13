import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/custom_widget/custom_tab_bar.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';
import '../../../../domain/entities/category_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../view_model/categories_events.dart';
import '../../view_model/categories_state.dart';
import '../../view_model/categories_view_model.dart';
import 'category_presets.dart';

/// Add/edit sheet for a category. Form-local state uses ValueNotifier
/// (rulebook: no setState). Icon + color pickers are inline grids drawn
/// from [kCategoryIcons] and [kCategoryColors].
class CategoryFormSheet extends StatefulWidget {
  final CategoryEntity? initial;

  const CategoryFormSheet({super.key, this.initial});

  @override
  State<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final ValueNotifier<TransactionType> _typeNotifier;
  late final ValueNotifier<int> _iconNotifier;
  late final ValueNotifier<String> _colorNotifier;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _typeNotifier = ValueNotifier(initial?.type ?? TransactionType.expense);
    _iconNotifier = ValueNotifier(
      initial?.iconCodePoint ?? kCategoryIcons.first.codePoint,
    );
    _colorNotifier = ValueNotifier(initial?.colorHex ?? kCategoryColors.first);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeNotifier.dispose();
    _iconNotifier.dispose();
    _colorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    ? context.l10n.addCategory
                    : context.l10n.editCategory,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppMeasurements.paddingLarge),

              // Type toggle (income/expense).
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

              TextFormField(
                controller: _nameController,
                maxLength: 40,
                style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: context.l10n.categoryName,
                  border: const OutlineInputBorder(),
                ),
                validator: (raw) {
                  final v = raw?.trim() ?? '';
                  if (v.isEmpty) return context.l10n.categoryNameRequired;
                  if (v.length > 40) return context.l10n.categoryNameTooLong;
                  return null;
                },
              ),

              const SizedBox(height: AppMeasurements.paddingLarge),

              Text(
                context.l10n.pickIcon,
                style: context.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppMeasurements.paddingSmall),
              ValueListenableBuilder<int>(
                valueListenable: _iconNotifier,
                builder: (context, selectedCode, _) => Wrap(
                  spacing: AppMeasurements.paddingSmall,
                  runSpacing: AppMeasurements.paddingSmall,
                  children: [
                    for (final icon in kCategoryIcons)
                      _IconOption(
                        icon: icon,
                        selected: icon.codePoint == selectedCode,
                        onTap: () => _iconNotifier.value = icon.codePoint,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppMeasurements.paddingLarge),

              Text(
                context.l10n.pickColor,
                style: context.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppMeasurements.paddingSmall),
              ValueListenableBuilder<String>(
                valueListenable: _colorNotifier,
                builder: (context, selectedHex, _) => Wrap(
                  spacing: AppMeasurements.paddingSmall,
                  runSpacing: AppMeasurements.paddingSmall,
                  children: [
                    for (final hex in kCategoryColors)
                      _ColorOption(
                        hex: hex,
                        selected: hex == selectedHex,
                        onTap: () => _colorNotifier.value = hex,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppMeasurements.paddingLarge),

              BlocSelector<CategoriesViewModel, CategoriesState, bool>(
                selector: (state) => state.mutation.isLoading,
                builder: (context, isLoading) => CustomElevatedButtonLoading(
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
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final entity = CategoryEntity(
      id: widget.initial?.id ?? 0,
      name: _nameController.text.trim(),
      iconCodePoint: _iconNotifier.value,
      colorHex: _colorNotifier.value,
      type: _typeNotifier.value,
    );
    context.read<CategoriesViewModel>().doIntent(SubmitCategoryEvent(entity));
    Navigator.of(context).pop();
  }
}

class _IconOption extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _IconOption({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
      child: Container(
        width: AppMeasurements.pickerChipSize,
        height: AppMeasurements.pickerChipSize,
        decoration: BoxDecoration(
          color: selected
              ? context.primaryColor.withValues(alpha: 0.15)
              : context.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppMeasurements.radiusMedium),
          border: Border.all(
            color: selected
                ? context.primaryColor
                : context.onSurface.withValues(alpha: 0.1),
            width: selected ? 2 : 1,
          ),
        ),
        child: Icon(
          icon,
          size: AppMeasurements.pickerChipIconSize,
          color: selected
              ? context.primaryColor
              : context.onSurface.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final String hex;
  final bool selected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.hex,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = parseCategoryHex(hex);
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: AppMeasurements.pickerChipSize,
        height: AppMeasurements.pickerChipSize,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? context.onSurface : Colors.transparent,
            width: AppMeasurements.pickerSelectionBorder,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: AppMeasurements.paddingExtraSmall,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: selected
            ? Icon(
                Icons.check_rounded,
                color: context.onPrimary,
                size: AppMeasurements.pickerChipIconSize,
              )
            : null,
      ),
    );
  }
}

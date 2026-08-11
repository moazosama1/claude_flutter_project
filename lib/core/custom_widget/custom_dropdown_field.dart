import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initialize_project/core/constants/app_colors.dart';
import '../extensions/theme_extension.dart';
import '../responsive/app_measurements.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? label;
  final String? hintText;
  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String Function(T) itemAsString;
  final String? Function(T?)? validator;
  final FocusNode? focusNode;
  final TextStyle? selectedValueStyle;

  const CustomDropdownField({
    super.key,
    this.label,
    this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemAsString,
    this.validator,
    this.focusNode,
    this.selectedValueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Column(
                children: [
                  Text(
                    label!,
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppMeasurements.paddingSmall),
                ],
              )
            : const SizedBox.shrink(),

        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              FocusScope.of(context).nextFocus();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: DropdownButtonFormField<T>(
              key: ValueKey(value),
              initialValue: value,
              focusNode: focusNode,
              validator: validator,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: context.onSurface,
              ),

              style: context.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.onSurface,
              ),
              dropdownColor: Color.alphaBlend(
                context.primaryColor.withValues(alpha: 0.05),
                context.surfaceColor,
              ),
              selectedItemBuilder: (context) {
                final selectedStyle =
                    selectedValueStyle ??
                    context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onSurface,
                    );

                return items
                    .map(
                      (item) => Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          itemAsString(item),
                          style: selectedStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList();
              },

              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: context.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.onSurface.withValues(alpha: 0.5),
                ),
                filled: true,
                fillColor: Color.alphaBlend(
                  context.primaryColor.withValues(alpha: 0.05),
                  context.surfaceColor,
                ),

                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.outlineVariant,
                    width: 1.1,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: context.primaryColor,
                    width: 1.8,
                  ),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                    width: 1.1,
                  ),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.red,
                    width: 1.8,
                  ),
                ),
              ),

              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemAsString(item),
                    style: context.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.onSurface,
                    ),
                  ),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

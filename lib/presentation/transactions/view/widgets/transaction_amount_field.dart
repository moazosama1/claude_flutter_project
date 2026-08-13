import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';

class TransactionAmountField extends StatelessWidget {
  final TextEditingController controller;

  const TransactionAmountField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      style: context.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
        if (parsed > 1000000) {
          return context.l10n.amountTooLarge;
        }
        return null;
      },
    );
  }
}

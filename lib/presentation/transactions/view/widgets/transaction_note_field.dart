import 'package:flutter/material.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';

class TransactionNoteField extends StatelessWidget {
  final TextEditingController controller;

  const TransactionNoteField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      maxLength: 200,
      style: context.bodyMedium,
      decoration: InputDecoration(
        labelText: '${context.l10n.note} (${context.l10n.optional})',
        border: const OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }
}

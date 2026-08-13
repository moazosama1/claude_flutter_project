import 'package:flutter/material.dart';

import '../../../../core/custom_widget/custom_dialog.dart';
import '../../../../core/custom_widget/custom_elevated_button_loading.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/responsive/app_measurements.dart';

/// Shows the "are you sure?" confirmation before deleting a transaction.
/// Returns `true` if the user confirms, `false` or `null` otherwise.
Future<bool?> showDeleteTransactionDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogCtx) => CustomDialog(
      showCloseButton: false,
      header: Text(
        dialogCtx.l10n.deleteTransaction,
        style: dialogCtx.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(dialogCtx.l10n.deleteConfirm, style: dialogCtx.bodyMedium),
          const SizedBox(height: AppMeasurements.paddingLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(dialogCtx).pop(false),
                child: Text(dialogCtx.l10n.cancel),
              ),
              const SizedBox(width: AppMeasurements.paddingSmall),
              CustomElevatedButtonLoading(
                isLoading: false,
                onPressed: () => Navigator.of(dialogCtx).pop(true),
                textButton: dialogCtx.l10n.deleteTransaction,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

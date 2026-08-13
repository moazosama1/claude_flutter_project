import 'package:flutter/material.dart';

import '../extensions/l10n_extension.dart';
import '../extensions/theme_extension.dart';
import '../responsive/app_measurements.dart';
import 'custom_elevated_button_loading.dart';

/// Reusable error-state view. Icon + message + optional retry button.
class ErrorStateView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorStateView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: context.errorColor,
            size: AppMeasurements.iconLarge,
          ),
          const SizedBox(height: AppMeasurements.paddingMedium),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(color: context.errorColor),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppMeasurements.paddingMedium),
            CustomElevatedButtonLoading(
              isLoading: false,
              onPressed: onRetry,
              textButton: context.l10n.done,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:initialize_project/generated/l10n.dart';
import 'package:toastification/toastification.dart';

void customToastification(
  BuildContext context,
  ToastificationType type,
  String? message,
) {
  final defaultMessage =
      message ??
      (type == ToastificationType.success
          ? AppLocalizations.of(context).success
          : AppLocalizations.of(context).error);

  toastification.show(
    context: context,
    title: Text(defaultMessage),
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 3),
    alignment: Alignment.bottomRight,
  );
}

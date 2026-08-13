import 'package:flutter/widgets.dart';

import '../../../../core/extensions/theme_extension.dart';

/// How a category's spending compares to its budget limit.
enum BudgetStatus { under, near, over }

/// under: < 70% of limit, near: 70–99%, over: >= 100%.
BudgetStatus statusFor(double ratio) {
  if (ratio >= 1.0) return BudgetStatus.over;
  if (ratio >= 0.7) return BudgetStatus.near;
  return BudgetStatus.under;
}

/// Resolves the accent colour for a status from the active theme.
Color budgetStatusColor(BuildContext context, BudgetStatus status) {
  switch (status) {
    case BudgetStatus.under:
      return context.successColor;
    case BudgetStatus.near:
      return context.warningColor;
    case BudgetStatus.over:
      return context.errorColor;
  }
}

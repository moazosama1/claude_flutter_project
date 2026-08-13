import 'package:flutter/widgets.dart';

import '../../../../core/extensions/l10n_extension.dart';

/// The data source seeds category rows with stable English identifiers
/// (Food, Transport, Bills, Salary, Shopping, Other). The UI renders them
/// via [localize] so the visible label follows the app locale.
///
/// Any custom category the user adds later — outside the seed set — will
/// fall through to its raw stored name.
String localizeCategoryName(BuildContext context, String storedName) {
  switch (storedName) {
    case 'Food':
      return context.l10n.categoryFood;
    case 'Transport':
      return context.l10n.categoryTransport;
    case 'Bills':
      return context.l10n.categoryBills;
    case 'Salary':
      return context.l10n.categorySalary;
    case 'Shopping':
      return context.l10n.categoryShopping;
    case 'Other':
      return context.l10n.categoryOther;
    default:
      return storedName;
  }
}

import 'package:flutter/widgets.dart';

import '../../../../core/extensions/l10n_extension.dart';
import '../../../../domain/entities/commitment_entity.dart';

/// Localized display label for a [CommitmentKind]. Kept as a top-level
/// function (not on the enum) because the enum lives in the pure-Dart
/// domain layer with no BuildContext access.
String kindLabel(BuildContext context, CommitmentKind kind) {
  switch (kind) {
    case CommitmentKind.rent:
      return context.l10n.kindRent;
    case CommitmentKind.jamia:
      return context.l10n.kindJamia;
    case CommitmentKind.installment:
      return context.l10n.kindInstallment;
    case CommitmentKind.goal:
      return context.l10n.kindGoal;
  }
}

String frequencyLabel(BuildContext context, CommitmentFrequency f) {
  switch (f) {
    case CommitmentFrequency.weekly:
      return context.l10n.freqWeekly;
    case CommitmentFrequency.monthly:
      return context.l10n.freqMonthly;
    case CommitmentFrequency.quarterly:
      return context.l10n.freqQuarterly;
    case CommitmentFrequency.yearly:
      return context.l10n.freqYearly;
  }
}

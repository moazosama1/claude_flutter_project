import 'package:flutter/cupertino.dart';

import '../../generated/l10n.dart';

extension L10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
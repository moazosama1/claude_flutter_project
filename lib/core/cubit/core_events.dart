import 'dart:ui';

sealed class CoreEvents {}

class LoadLocaleCoreEvent extends CoreEvents {}

class ToggleLocaleCoreEvent extends CoreEvents {}

class ChangeLocaleCoreEvent extends CoreEvents {
  final Locale locale;

  ChangeLocaleCoreEvent(this.locale);
}

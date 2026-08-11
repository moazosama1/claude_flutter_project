

import 'package:initialize_project/generated/l10n.dart';

abstract class Validations {

  static String? validateEmail(String? val) {
    final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (val == null) {
      return AppLocalizations().emailIsRequired;
    } else if (val.trim().isEmpty) {
      return AppLocalizations().emailIsRequired;
    } else if (emailRegex.hasMatch(val) == false) {
      return AppLocalizations().enterValidEmail;
    } else {
      return null;
    }
  }

  static String? validatePassword(String? val) {
    final RegExp passwordRegex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[#?!@$%^&*-]).{8,}$',
    );
    if (val == null) {
      return AppLocalizations().passwordIsRequired;
    } else if (val.isEmpty) {
      return AppLocalizations().passwordIsRequired;
    } else if (val.length < 8 || !passwordRegex.hasMatch(val)) {
      return AppLocalizations().passwordNotMatched;
    } else {
      return null;
    }
  }

  static String? validateConfirmPassword(String? val, String? password) {
    if (val == null || val.isEmpty) {
      return AppLocalizations().passwordIsRequired;
    } else if (val != password) {
      return AppLocalizations().passwordNotMatched;
    } else {
      return null;
    }
  }

  static String? validateUsername(String? val) {
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9,.-]+$');
    if (val == null) {
      return AppLocalizations().thisFieldIsRequired;
    } else if (val.isEmpty) {
      return AppLocalizations().thisFieldIsRequired;
    } else if (!usernameRegex.hasMatch(val)) {
      return AppLocalizations().enterValidUsername;
    } else {
      return null;
    }
  }

  static String? validateFullName(String? val) {
    if (val == null || val.isEmpty) {
      return AppLocalizations().thisFieldIsRequired;
    } else {
      return null;
    }
  }

  static String? validatePhoneNumber(String? val) {
    final regex = RegExp(r'^(?:\+2)?01[0125][0-9]{8}$'); 

    if (val == null || val.trim().isEmpty) {
      return AppLocalizations().thisFieldIsRequired;
    } else if (int.tryParse(val.trim()) == null) {
      return AppLocalizations().enterNumbersOnly;
    } else if (!regex.hasMatch(val.trim())) {
      return AppLocalizations().enterValidEgyptianPhoneNumber;
    } else {
      return null;
    }
  }

  static String? validateAddress(String? val) {
    final RegExp addressRegex = RegExp(r"^[\p{L}\d\s,.\-\/#]+$", unicode: true);

    if (val == null || val.trim().isEmpty) {
      return AppLocalizations().pleaseEnterAddress;
    }

    if (!addressRegex.hasMatch(val.trim())) {
      return AppLocalizations().pleaseEnterValidAddress;
    }

    return null;
  }
}

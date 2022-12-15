import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class FormError {
  String message(BuildContext context);
}

class FieldRequiredError implements FormError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.fieldRequiredError;
  }
}

class InvalidEmailError implements FormError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.enterValidEmail;
  }
}

class PasswordLengthError implements FormError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.passwordLengthError;
  }
}

class PasswordMatchError implements FormError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.passwordMatchError;
  }
}

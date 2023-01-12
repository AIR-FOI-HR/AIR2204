import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class UserError {
  String message(BuildContext context);
}

class UserDataError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.userDataError;
  }
}

class UserNoDataAvailable implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.userNoDataAvailable;
  }
}

class FailedUpdateError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.failedUpdateError;
  }
}

class WrongCurrentPasswordError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.wrongCurrentPassword;
  }
}

class PasswordChangeError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.wrongCurrentPassword;
  }
}

class AddContactError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.addContactError;
  }
}

class InvalidVcardError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.invalidNFCTagError;
  }
}

class ContactPermissionError implements UserError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.contactPermissionError;
  }
}

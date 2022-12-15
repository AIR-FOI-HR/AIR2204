import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AuthError {
  String message(BuildContext context);
}

class LoginInvalidEmailError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.enterValidEmail;
  }
}

class EmailInUseError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.emailAlreadyInUse;
  }
}

class UserNotFoundError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.noMatchingEmail;
  }
}

class WrongPasswordError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.wrongPassword;
  }
}

class EmptyCredentialError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.emptyCredentialError;
  }
}

class DefaultLoginError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.defaultLoginError;
  }
}

class SignupValidateError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.signUpValidateError;
  }
}

class GoogleCredentialError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.googleCredentialError;
  }
}

class OperationNotAllowedError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.operationNotAllowed;
  }
}

class UserDisabledError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.userDisabledError;
  }
}

class GoogleUserNotFoundError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.googleUserNotFound;
  }
}

class EmailValidateError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.emailValidateError;
  }
}

class TooManyRequestsError implements AuthError {
  @override
  String message(BuildContext context) {
    return AppLocalizations.of(context)!.tooManyRequestsError;
  }
}

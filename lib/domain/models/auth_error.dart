import 'package:flutter/material.dart';

abstract class AuthError {
  String message(BuildContext context);
}

class LoginInvalidEmailError implements AuthError {
  @override
  String message(BuildContext context) {
    return "Please enter a valid email";
  }
}

class EmailInUseError implements AuthError {
  @override
  String message(BuildContext context) {
    return "This email is already in use";
  }
}

class UserNotFoundError implements AuthError {
  @override
  String message(BuildContext context) {
    return "There is no user matching that email";
  }
}

class WrongPasswordError implements AuthError {
  @override
  String message(BuildContext context) {
    return "The provided password is incorrect or the user has no password";
  }
}

class EmptyCredentialError implements AuthError {
  @override
  String message(BuildContext context) {
    return "You must provide an email and a password";
  }
}

class DefaultLoginError implements AuthError {
  @override
  String message(BuildContext context) {
    return "Something went wrong with the log-in process";
  }
}

class SignupValidateError implements AuthError {
  @override
  String message(BuildContext context) {
    return "Please check all input fields";
  }
}

class GoogleCredentialError implements AuthError {
  @override
  String message(BuildContext context) {
    return 'This account exists with a different sign in provider';
  }
}

class OperationNotAllowedError implements AuthError {
  @override
  String message(BuildContext context) {
    return 'This operation is not allowed';
  }
}

class UserDisabledError implements AuthError {
  @override
  String message(BuildContext context) {
    return 'The user has been disabled';
  }
}

class GoogleUserNotFoundError implements AuthError {
  @override
  String message(BuildContext context) {
    return 'The user is not found';
  }
}

class EmailValidateError implements AuthError {
  @override
  String message(BuildContext context) {
    return 'There has been an error with email validation';
  }
}

class TooManyRequestsError implements AuthError {
  @override
  String message(BuildContext context) {
    return "There have been too many requests, try again later";
  }
}

import 'package:flutter/material.dart';

abstract class FormError {
  String message(BuildContext context);
}

class FieldRequiredError implements FormError {
  @override
  String message(BuildContext context) {
    //tu se trenutno ne koristi context ali bude kad pristupamo stringovima (local)
    return "This field is required";
  }
}

class InvalidEmailError implements FormError {
  @override
  String message(BuildContext context) {
    return "Please enter a valid email";
  }
}

class PasswordLengthError implements FormError {
  @override
  String message(BuildContext context) {
    return "Password must be at least 6 characters long";
  }
}

class PasswordMatchError implements FormError {
  @override
  String message(BuildContext context) {
    return "Passwords must match";
  }
}

part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool loading;
  final bool error;
  final String userId;
  final bool canResendEmail;
  final bool isEmailVerified;

  final AuthError? validateError;
  final AuthError? loginErrorMessage;
  final AuthError? signupErrorMessage;
  final AuthError? resetErrorMessage;

  final FormError? emailError;
  final FormError? passwordError;
  final FormError? repeatPasswordError;
  final FormError? companyUrlError;
  final FormError? phoneNumberError;
  final String? password;
  final bool resetEmail;
  final bool isChecked;

  const AuthenticationState(
      {this.isEmailVerified = false,
      this.canResendEmail = false,
      this.loading = false,
      this.error = false,
      this.userId = "",
      this.emailError,
      this.passwordError,
      this.repeatPasswordError,
      this.companyUrlError,
      this.phoneNumberError,
      this.password,
      this.resetEmail = false,
      this.isChecked = false,
      this.loginErrorMessage,
      this.signupErrorMessage,
      this.resetErrorMessage,
      this.validateError});

  AuthenticationState copyWith(
      {bool? loading,
      bool? error,
      String? userId,
      bool? canResendEmail,
      bool? isEmailVerified,
      FormError? Function()? emailError,
      FormError? Function()? passwordError,
      FormError? Function()? repeatPasswordError,
      FormError? Function()? companyUrlError,
      FormError? Function()? phoneNumberError,
      AuthError? Function()? loginErrorMessage,
      AuthError? Function()? signupErrorMessage,
      AuthError? Function()? resetErrorMessage,
      AuthError? Function()? validateError,
      String? password,
      bool? resetEmail,
      bool? isChecked}) {
    return AuthenticationState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        userId: userId ?? this.userId,
        canResendEmail: canResendEmail ?? this.canResendEmail,
        emailError: emailError != null ? emailError() : this.emailError,
        passwordError: passwordError != null ? passwordError() : this.passwordError,
        repeatPasswordError: repeatPasswordError != null ? repeatPasswordError() : this.repeatPasswordError,
        companyUrlError: companyUrlError != null ? companyUrlError() : this.companyUrlError,
        phoneNumberError: phoneNumberError != null ? phoneNumberError() : this.phoneNumberError,
        password: password ?? this.password,
        resetEmail: resetEmail ?? this.resetEmail,
        isChecked: isChecked ?? this.isChecked,
        loginErrorMessage: loginErrorMessage != null ? loginErrorMessage() : this.loginErrorMessage,
        signupErrorMessage: signupErrorMessage != null ? signupErrorMessage() : this.signupErrorMessage,
        resetErrorMessage: resetErrorMessage != null ? resetErrorMessage() : this.resetErrorMessage,
        validateError: validateError != null ? validateError() : this.validateError);
  }

  @override
  List<Object?> get props => [
        loading,
        error,
        userId,
        isEmailVerified,
        canResendEmail,
        emailError,
        passwordError,
        repeatPasswordError,
        password,
        resetEmail,
        isChecked,
        loginErrorMessage,
        signupErrorMessage,
        resetErrorMessage,
        validateError,
        companyUrlError,
        phoneNumberError
      ];
}

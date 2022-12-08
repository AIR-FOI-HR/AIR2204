part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool loading;
  final dynamic error;
  final String userId;
  final bool canResendEmail;
  final bool isEmailVerified;

  final FormError? emailError;
  final FormError? passwordError;
  final FormError? repeatPasswordError;
  final String? password;
  final bool resetEmail;
  final bool isChecked;

  const AuthenticationState({
    this.isEmailVerified = false,
    this.canResendEmail = false,
    this.loading = true,
    this.error,
    this.userId = "",
    this.emailError,
    this.passwordError,
    this.repeatPasswordError,
    this.password,
    this.resetEmail = false,
    this.isChecked = false,
  });

  // AuthenticationState copyWith({
  //   bool? loading,
  //   dynamic error,
  //   String? userId,
  //   bool? canResendEmail,
  //   bool? isEmailVerified,
  //   FormError? emailError,
  //   FormError? passwordError,
  // }) {
  //   return AuthenticationState(
  //       loading: loading ?? this.loading,
  //       error: error ?? this.error,
  //       isEmailVerified: isEmailVerified ?? this.isEmailVerified,
  //       userId: userId ?? this.userId,
  //       canResendEmail: canResendEmail ?? this.canResendEmail,
  //       emailError: emailError ,
  //       passwordError: passwordError ?? this.passwordError);
  // }

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
        isChecked
      ];
}

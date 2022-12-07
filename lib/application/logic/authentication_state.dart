part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool loading;
  final dynamic error;
  final String userId;
  final bool canResendEmail;
  final bool isEmailVerified;
  const AuthenticationState({
    this.isEmailVerified = false,
    this.canResendEmail = false,
    this.loading = true,
    this.error,
    this.userId = "",
  });

  @override
  List<Object?> get props => [loading, error, userId, isEmailVerified, canResendEmail];
}

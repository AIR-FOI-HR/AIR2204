part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final bool guestLogin;

  const AuthState(
    this.guestLogin,
  );

  @override
  List<Object?> get props => [
        guestLogin,
      ];
}

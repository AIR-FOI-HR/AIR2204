import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState(false));

  void guestLoginToggle() {
    final guestLogin = !state.guestLogin;
    emit(AuthState(guestLogin));
  }
}

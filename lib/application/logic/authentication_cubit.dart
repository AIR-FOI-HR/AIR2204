import 'dart:async';

import 'package:deep_conference/domain/repositories/authentication_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/form_error.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationCubit(this.authenticationRepository) : super(const AuthenticationState());

  void isChecked(bool? newValue) {
    emit(state.copyWith(isChecked: newValue));
  }

  void isEmailVerified(Timer? timer) {
    if (!authenticationRepository.isEmailVerified()) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(timer),
      );
    } else {
      emit(AuthenticationState(isEmailVerified: true, userId: state.userId));
    }
  }

  void checkEmailVerified(Timer? timer) async {
    if (authenticationRepository.getCurrentUser() != null) {
      await authenticationRepository.reloadUser();
      if (authenticationRepository.isEmailVerified()) {
        timer?.cancel();
        emit(AuthenticationState(isEmailVerified: true, userId: state.userId));
      }
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await authenticationRepository.sendVerificationEmail();
      emit(AuthenticationState(canResendEmail: false, userId: state.userId));
      await Future.delayed(const Duration(seconds: 5));
      emit(AuthenticationState(canResendEmail: true, userId: state.userId));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(error: e.message, userId: state.userId));
      emit(state.copyWith(error: () => null));
    }
  }

  void signOut() {
    authenticationRepository.signOut();
    emit(const AuthenticationState(userId: ""));
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(loading: true));
    final emailValidate = _emailValidate(email);
    if(emailValidate != null){
      emit(state.copyWith(loading: false, error: () =>  'Please enter a valid email'));
      emit(state.copyWith(error: () => null));
      return;
    }
    try {
      await authenticationRepository.sendPasswordResetEmail(email);
      emit(const AuthenticationState(resetEmail: true));
      emit(state.copyWith(resetEmail: false));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error:() => e.message, loading: false));
      emit(state.copyWith(error: () => null));
    }
  }

  FormError? _emailValidate(String email) {
    if (email.isEmpty) {
      return FieldRequiredError();
    }
    if (!EmailValidator.validate(email)) {
      return InvalidEmailError();
    }
    return null;
  }

  void onEmailChanged(String email) {
    FormError? emailValidate = _emailValidate(email);
    emit(state.copyWith(emailError: () => emailValidate));
  }

  FormError? _passwordValidate(String password) {
    if (password.isEmpty) {
      return FieldRequiredError();
    }
    if (password.length < 6) {
      return PasswordLengthError();
    }
    return null;
  }

  void onPasswordChanged(String password) {
    FormError? passwordValidate = _passwordValidate(password);
    emit(state.copyWith(password: password, passwordError: () => passwordValidate));  
  }

  FormError? _repeatPasswordValidate(String repeatPassword) {
    if (repeatPassword.isEmpty) {
      return FieldRequiredError();
    }
    if (state.password != repeatPassword) {
      return PasswordMatchError();
    }
    return null;
  }

  void onRepeatPasswordChanged(String repeatPassword) {
    FormError? repeatPasswordValidate = _repeatPasswordValidate(repeatPassword);
    emit(state.copyWith(repeatPasswordError: () => repeatPasswordValidate));
  }

  Future<void> signUp(String repeatPassword, String email, String password) async {
     emit(state.copyWith(loading: true));
    final passwordValidate = _passwordValidate(password);
    final emailValidate = _emailValidate(email);
    final repeatPasswordValidate = _repeatPasswordValidate(repeatPassword);

    if (emailValidate != null || passwordValidate != null || repeatPasswordValidate != null) {
      emit(state.copyWith(loading: false, error: () =>  'Please check all input fields'));
      emit(state.copyWith(error: () => null));
      return;
    }
    try {
      await authenticationRepository.createUser(email, password);
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(error:() => e.message, loading: false));
      emit(state.copyWith(error: () => null));
    }
  }

  Future<void> signIn(TextEditingController emailController, TextEditingController passwordController) async {
    emit(const AuthenticationState(loading: true));
    try {
      await authenticationRepository.signIn(emailController.text.trim(), passwordController.text.trim());
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(error: e.message));
       emit(state.copyWith(error: () => null));
    }
  }

  Future<void> googleSignIn() async {
    emit(const AuthenticationState(loading: true));
    try {
      await authenticationRepository.signInGoogle();
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      String content = "An unknown error has occured";
      switch (e.code) {
        case 'account-exists-with-different-credential':
          content = 'This account exists with a different sign in provider';
          break;
        case 'invalid-credential':
          content = 'Unknown error has occurred';
          break;
        case 'operation-not-allowed':
          content = 'This operation is not allowed';
          break;
        case 'user-disabled':
          content = 'The user you tried to log into was disabled';
          break;
        case 'user-not-found':
          content = 'The user you tried to log into was not found';
          break;
      }
      emit(AuthenticationState(error: content));
    }
  }
}

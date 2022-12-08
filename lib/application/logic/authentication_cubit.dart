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
    emit(AuthenticationState(
        isChecked: newValue!,
        loading: false,
        password: state.password,
        emailError: state.emailError,
        passwordError: state.passwordError,
        repeatPasswordError: state.repeatPasswordError));
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
      emit(AuthenticationState(loading: false, canResendEmail: false, userId: state.userId));
      await Future.delayed(const Duration(seconds: 5));
      emit(AuthenticationState(loading: false, canResendEmail: true, userId: state.userId));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(error: e.message, userId: state.userId));
    }
  }

  void signOut() {
    authenticationRepository.signOut();
    emit(const AuthenticationState(loading: false, userId: ""));
  }

  Future<void> resetPassword(String email) async {
    emit(const AuthenticationState());
    try {
      await authenticationRepository.sendPasswordResetEmail(email);
      emit(const AuthenticationState(loading: false, resetEmail: true));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(loading: false, error: e.message));
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
    emit(AuthenticationState(
        isChecked: state.isChecked,
        password: state.password,
        passwordError: state.passwordError,
        repeatPasswordError: state.repeatPasswordError,
        emailError: emailValidate,
        loading: false));
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
    emit(AuthenticationState(
        isChecked: state.isChecked,
        password: password,
        emailError: state.emailError,
        repeatPasswordError: state.repeatPasswordError,
        passwordError: passwordValidate,
        loading: false));
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
    emit(AuthenticationState(
        isChecked: state.isChecked,
        password: state.password,
        emailError: state.emailError,
        passwordError: state.passwordError,
        repeatPasswordError: repeatPasswordValidate,
        loading: false));
  }

  Future<void> signUp(String repeatPassword, String email, String password) async {
    emit(AuthenticationState(password: state.password));
    //pozovem metode za svaki field i ak je bilo koja od njih != null onda something went wrong
    final passwordValidate = _passwordValidate(password);
    final emailValidate = _emailValidate(email);
    final repeatPasswordValidate = _repeatPasswordValidate(repeatPassword);

    if (emailValidate != null || passwordValidate != null || repeatPasswordValidate != null) {
      emit(AuthenticationState(password: state.password, loading: false, error: 'Please check all input fields'));
      return;
    }
    try {
      await authenticationRepository.createUser(email, password);
      emit(AuthenticationState(loading: false, userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(loading: false, error: e.message));
    }
  }

  Future<void> signIn(TextEditingController emailController, TextEditingController passwordController) async {
    emit(const AuthenticationState());
    try {
      await authenticationRepository.signIn(emailController.text.trim(), passwordController.text.trim());
      emit(AuthenticationState(loading: false, userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(loading: false, error: e.message));
    }
  }

  Future<void> googleSignIn() async {
    emit(const AuthenticationState());
    try {
      await authenticationRepository.signInGoogle();
      emit(AuthenticationState(loading: false, userId: authenticationRepository.getUserId()));
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
      emit(AuthenticationState(loading: false, error: content));
    }
  }
}

import 'dart:async';

import 'package:deep_conference/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationCubit(this.authenticationRepository) : super(const AuthenticationState());

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

  Future<void> resetPassword(TextEditingController emailController) async {
    emit(const AuthenticationState());
    try {
      await authenticationRepository.sendPasswordResetEmail(emailController.text.trim());
      emit(const AuthenticationState(loading: false));
    } on FirebaseAuthException catch (e) {
      emit(AuthenticationState(loading: false, error: e.message));
    }
  }

  Future<void> signUp(GlobalKey<FormState> formKey, TextEditingController emailController,
      TextEditingController passwordController) async {
    emit(const AuthenticationState());
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      emit(const AuthenticationState(loading: false, error: 'Something went wrong :('));
      return;
    }
    try {
      await authenticationRepository.createUser(emailController.text.trim(), passwordController.text.trim());
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

import 'dart:async';

import 'package:deep_conference/domain/repositories/authentication_repository.dart';
import 'package:deep_conference/domain/repositories/user_repository.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/auth_error.dart';
import '../../domain/models/form_error.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  AuthenticationCubit(this.authenticationRepository, this.userRepository) : super(const AuthenticationState());

  void initState() {
    if (authenticationRepository.getCurrentUser() != null) {
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } else {
      emit(const AuthenticationState());
    }
  }

  void isChecked(bool? newValue) {
    emit(state.copyWith(isChecked: newValue));
  }

  void isEmailVerified() {
    if (state.userId.isEmpty) {
      return;
    }
    if (!authenticationRepository.isEmailVerified()) {
      sendVerificationEmail();
      Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (state.userId.isNotEmpty) {
          await authenticationRepository.reloadUser();
          if (authenticationRepository.isEmailVerified()) {
            timer.cancel();
            emit(AuthenticationState(isEmailVerified: true, userId: state.userId));
          }
        } else {
          timer.cancel();
        }
      });
    } else {
      emit(AuthenticationState(isEmailVerified: true, userId: state.userId));
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await authenticationRepository.sendVerificationEmail();
      emit(AuthenticationState(canResendEmail: false, userId: state.userId));
      await Future.delayed(const Duration(seconds: 5));
      emit(AuthenticationState(canResendEmail: true, userId: state.userId));
    } on FirebaseAuthException catch (e) {
      final AuthError? validateError;
      if (e.code == "too-many-requests") {
        validateError = TooManyRequestsError();
      } else {
        validateError = EmailValidateError();
      }
      emit(state.copyWith(error: true, validateError: () => validateError, loading: false));
    }
  }

  void signOut() {
    authenticationRepository.signOut();
    emit(const AuthenticationState(userId: ""));
  }

  Future<void> resetPassword(String email) async {
    emit(state.copyWith(loading: true));
    final emailValidate = _emailValidate(email);
    if (emailValidate != null) {
      emit(state.copyWith(loading: false, error: true, resetErrorMessage: () => LoginInvalidEmailError()));
      return;
    }
    try {
      await authenticationRepository.sendPasswordResetEmail(email);
      emit(const AuthenticationState(resetEmail: true));
      emit(state.copyWith(resetEmail: false));
    } on FirebaseAuthException catch (e) {
      final AuthError? resetError = _checkAuthError(e, null, null);
      emit(state.copyWith(error: true, resetErrorMessage: () => resetError, loading: false));
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

  FormError? _repeatPasswordValidate(String repeatPassword, String? password) {
    if (repeatPassword.isEmpty) {
      return FieldRequiredError();
    }
    if (password != repeatPassword) {
      return PasswordMatchError();
    }
    return null;
  }

  void onRepeatPasswordChanged(String repeatPassword) {
    FormError? repeatPasswordValidate = _repeatPasswordValidate(repeatPassword, state.password);
    emit(state.copyWith(repeatPasswordError: () => repeatPasswordValidate));
  }

  FormError? _companyUrlValidate(String companyUrl) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(companyUrl) && companyUrl.isNotEmpty) {
      return CompanyUrlError();
    }
    return null;
  }

  void onCompanyUrlChanged(String companyUrl) {
    FormError? companyUrlValidate = _companyUrlValidate(companyUrl);
    emit(state.copyWith(companyUrlError: () => companyUrlValidate));
  }

  FormError? _phoneNumberValidate(String phoneNumber) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(phoneNumber) && phoneNumber.isNotEmpty) {
      return PhoneNumberError();
    }
    return null;
  }

  void onPhoneNumberChanged(String phoneNumber) {
    FormError? phoneNumberValidate = _phoneNumberValidate(phoneNumber);
    emit(state.copyWith(phoneNumberError: () => phoneNumberValidate));
  }

  Future<void> signUp(String repeatPassword, String email, String password, String firstName, String lastName,
      String companyUrl, String phoneNumber) async {
    emit(state.copyWith(loading: true));
    final passwordValidate = _passwordValidate(password);
    final emailValidate = _emailValidate(email);
    final repeatPasswordValidate = _repeatPasswordValidate(repeatPassword, password);
    final companyUrlValidate = _companyUrlValidate(companyUrl);
    final phoneNumberValidate = _phoneNumberValidate(phoneNumber);

    if (emailValidate != null ||
        passwordValidate != null ||
        repeatPasswordValidate != null ||
        companyUrlValidate != null ||
        phoneNumberValidate != null) {
      emit(state.copyWith(error: true, signupErrorMessage: () => SignupValidateError(), loading: false));
      return;
    }

    try {
      await authenticationRepository.createUser(email, password);
      await userRepository.writeUserData(email, firstName, lastName, companyUrl, phoneNumber);
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      final AuthError? signupError = _checkAuthError(e, email, password);
      emit(state.copyWith(error: true, loginErrorMessage: () => signupError, loading: false));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthenticationState(loading: true));
    try {
      await authenticationRepository.signIn(email, password);
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      final AuthError? loginError = _checkAuthError(e, email, password);
      emit(state.copyWith(error: true, loginErrorMessage: () => loginError, loading: false));
    }
  }

  AuthError? _checkAuthError(FirebaseAuthException e, String? email, String? password) {
    if ((email != null && email.isEmpty) || (password != null && password.isEmpty)) {
      return EmptyCredentialError();
    }
    if (e.code == "invalid-email") {
      return LoginInvalidEmailError();
    } else if (e.code == "user-not-found") {
      return UserNotFoundError();
    } else if (e.code == "email-already-in-use") {
      return EmailInUseError();
    } else if (e.code == "wrong-password") {
      return WrongPasswordError();
    } else {
      return DefaultLoginError();
    }
  }

  Future<void> googleSignIn() async {
    emit(const AuthenticationState(loading: true));
    try {
      final String? userEmail = await authenticationRepository.signInGoogle();
      if (userEmail != null) {
        await userRepository.writeUserData(userEmail, "", "", "", "");
      }
      emit(AuthenticationState(userId: authenticationRepository.getUserId()));
    } on FirebaseAuthException catch (e) {
      final AuthError? loginError = _checkGoogleAuthError(e);
      emit(state.copyWith(error: true, loginErrorMessage: () => loginError, loading: false));
    }
  }

  AuthError? _checkGoogleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return GoogleCredentialError();
      case 'invalid-credential':
        return DefaultLoginError();
      case 'operation-not-allowed':
        return OperationNotAllowedError();
      case 'user-disabled':
        return UserDisabledError();
      case 'user-not-found':
        return GoogleUserNotFoundError();
      default:
        return DefaultLoginError();
    }
  }
}

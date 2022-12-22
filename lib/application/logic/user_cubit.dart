import 'package:deep_conference/domain/models/user_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/auth_error.dart';
import '../../domain/models/form_error.dart';
import '../../domain/models/users.dart';
import '../../domain/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(const UserState());
  final UserRepository userRepository;

  void initState() async {
    emit(state.copyWith(
        repeatPasswordError: () => null,
        passwordError: () => null,
        phoneNumberError: () => null,
        companyUrlError: () => null,
        error: () => null));
  }

  void getUserData() async {
    //TODO: implement loading state
    try {
      final AppUser? user = await userRepository.getUserData();
      if (user != null) {
        emit(UserState(
          userData: true,
          email: user.email,
          firstName: user.firstName,
          lastName: user.lastName,
          companyUrl: user.companyUrl,
          phoneNumber: user.phoneNumber,
        ));
      } else {
        //emit(UserState(error: UserNoDataAvailable()));
      }
    } on Exception {
      emit(UserState(error: UserDataError()));
    }
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
    emit(state.copyWith(companyUrlError: () => companyUrlValidate, error: () => null));
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

    emit(state.copyWith(phoneNumberError: () => phoneNumberValidate, error: () => null));
  }

  Future<void> writeUserData(
      String email, String firstName, String lastName, String companyUrl, String phoneNumber) async {
    FormError? companyUrlValidate = _companyUrlValidate(companyUrl);
    FormError? phoneNumberValidate = _phoneNumberValidate(phoneNumber);

    if (companyUrlValidate != null || phoneNumberValidate != null) {
      emit(state.copyWith(
          companyUrlError: () => companyUrlValidate,
          phoneNumberError: () => phoneNumberValidate,
          error: () => SignupValidateError()));
      return;
    }

    try {
      await userRepository.writeUserData(email, firstName, lastName, companyUrl, phoneNumber);
      emit(const UserState(userUpdated: true));
      getUserData();
    } on Exception {
      emit(state.copyWith(error: () => FailedUpdateError()));
    }
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
    emit(state.copyWith(currentPassword: password, passwordError: () => passwordValidate));
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
    FormError? repeatPasswordValidate = _repeatPasswordValidate(repeatPassword, state.currentPassword);
    emit(state.copyWith(repeatPasswordError: () => repeatPasswordValidate));
  }

  Future<void> changeUserPassword(String currentPassword, String newPassword, String repeatPassword) async {
    emit(state.copyWith(loading: true));
    final repeatPasswordValidate = _repeatPasswordValidate(repeatPassword, newPassword);
    final passwordValidate = _passwordValidate(newPassword);

    if (passwordValidate != null || repeatPasswordValidate != null) {
      emit(state.copyWith(error: () => SignupValidateError(), loading: false));
      return;
    }

    try {
      dynamic e;
      e = await userRepository.reauthenticateUser(currentPassword);
      if (e != null) {
        emit(state.copyWith(error: () => WrongCurrentPasswordError(), loading: false));
        return;
      }
      e = await userRepository.changePassword(newPassword);
      if (e != null) {
        emit(state.copyWith(error: () => PasswordChangeError(), loading: false));
        return;
      }
      emit(const UserState(userUpdated: true));
      getUserData();
    } on Exception {
      emit(state.copyWith(error: () => PasswordChangeError(), loading: false));
    }
  }

  void checkAuthProvider() {
    List<String> providers = userRepository.checkAuthProvider();
    if (providers.contains('google.com')) {
      emit(state.copyWith(googleProvider: true));
    }
    if (providers.contains('password')) {
      emit(state.copyWith(passwordProvider: true));
    }
  }
}

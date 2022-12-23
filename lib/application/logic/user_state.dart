part of 'user_cubit.dart';

class UserState extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String companyUrl;
  final String phoneNumber;
  final bool userData;
  final bool userUpdated;
  final dynamic error;
  final bool loading;
  final String currentPassword;
  final List<MyProvider> providers;

  final FormError? phoneNumberError;
  final FormError? passwordError;
  final FormError? repeatPasswordError;
  final FormError? companyUrlError;

  const UserState(
      {this.email = "",
      this.firstName = "",
      this.lastName = "",
      this.companyUrl = "",
      this.phoneNumber = "",
      this.userData = false,
      this.error,
      this.userUpdated = false,
      this.loading = false,
      this.currentPassword = "",
      this.phoneNumberError,
      this.passwordError,
      this.providers = const [],
      this.repeatPasswordError,
      this.companyUrlError});

  UserState copyWith(
      {String? email,
      String? firstName,
      String? lastName,
      String? companyUrl,
      String? phoneNumber,
      bool? userUpdated,
      bool? userData,
      bool? loading,
      List<MyProvider>? providers,
      String? currentPassword,
      dynamic Function()? error,
      FormError? Function()? phoneNumberError,
      FormError? Function()? passwordError,
      FormError? Function()? repeatPasswordError,
      FormError? Function()? companyUrlError}) {
    return UserState(
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyUrl: companyUrl ?? this.companyUrl,
      providers: providers ?? this.providers,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userUpdated: userUpdated ?? this.userUpdated,
      currentPassword: currentPassword ?? this.currentPassword,
      userData: userData ?? this.userData,
      loading: loading ?? this.loading,
      error: error != null ? error() : this.error,
      phoneNumberError: phoneNumberError != null ? phoneNumberError() : this.phoneNumberError,
      passwordError: passwordError != null ? passwordError() : this.passwordError,
      repeatPasswordError: repeatPasswordError != null ? repeatPasswordError() : this.repeatPasswordError,
      companyUrlError: companyUrlError != null ? companyUrlError() : this.companyUrlError,
    );
  }

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        companyUrl,
        phoneNumber,
        userData,
        currentPassword,
        error,
        loading,
        phoneNumberError,
        companyUrlError,
        passwordError,
        repeatPasswordError,
        userUpdated,
        providers
      ];
}

part of 'user_cubit.dart';

class UserState extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String companyUrl;
  final String phoneNumber;
  final bool userData;

  const UserState({
    this.email = "",
    this.firstName = "",
    this.lastName = "",
    this.companyUrl = "",
    this.phoneNumber = "",
    this.userData = false,
  });

  @override
  List<Object> get props => [email, firstName, lastName, companyUrl, phoneNumber, userData];
}

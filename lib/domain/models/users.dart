import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String companyUrl;
  final String phoneNumber;

  const AppUser({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.companyUrl,
    required this.phoneNumber,
  });

  static AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
        email: json['email'] ?? "",
        firstName: json['firstName'] ?? "",
        lastName: json['lastName'] ?? "",
        companyUrl: json['companyUrl'] ?? "",
        phoneNumber: json['phoneNumber'] ?? "");
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'companyUrl': companyUrl,
      };

  @override
  List<Object?> get props => [email, firstName, lastName, companyUrl, phoneNumber];
}

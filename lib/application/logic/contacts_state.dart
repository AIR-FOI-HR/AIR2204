part of 'contacts_cubit.dart';

class ContactsState extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final bool contactAdded;

  const ContactsState({
    this.firstName = "",
    this.lastName = "",
    this.phoneNumber = "",
    this.contactAdded = false,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, contactAdded];
}

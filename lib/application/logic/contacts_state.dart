part of 'contacts_cubit.dart';

class ContactsState extends Equatable {
  final bool contactAdded;
  final dynamic error;

  const ContactsState({this.contactAdded = false, this.error});

  @override
  List<Object?> get props => [contactAdded, error];
}

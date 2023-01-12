part of 'contacts_cubit.dart';

class ContactsState extends Equatable {
  final bool contactAddedAndroid;
  final bool contactAddedIOS;

  final dynamic error;

  const ContactsState({this.contactAddedAndroid = false, this.contactAddedIOS = false, this.error});

  @override
  List<Object?> get props => [contactAddedAndroid, contactAddedIOS, error];
}

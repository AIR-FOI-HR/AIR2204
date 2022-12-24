import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  Future<void> addContact(String? firstName, String? lastName, String? phoneNumber) async {
    emit(const ContactsState());

    final PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      final Contact contact = Contact.fromVCard(
        'BEGIN:VCARD\n'
        'VERSION:3.0\n'
        'N:$lastName;$firstName;;;\n'
        'TEL;TYPE=HOME:$phoneNumber\n'
        'END:VCARD',
      );
      try {
        await FlutterContacts.insertContact(contact);
        emit(ContactsState(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, contactAdded: true));
      } on Exception {
        // execption when adding a contact
      }
    } else {
      //emit permission not granted state
    }
  }
}

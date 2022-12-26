import 'package:android_intent_plus/android_intent.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/user_error.dart';

part 'contacts_state.dart';

class ContactsCubit extends Cubit<ContactsState> {
  ContactsCubit() : super(const ContactsState());

  String userDataToVCard(String? firstName, String? lastName, String? phoneNumber, String? email) {
    return 'BEGIN:VCARD\n'
        'VERSION:3.0\n'
        'N:$lastName;$firstName;;;\n'
        'TEL;TYPE=HOME:$phoneNumber\n'
        'EMAIL:$email\n'
        'END:VCARD';
  }

  Future<void> addContactIOS(String? firstName, String? lastName, String? phoneNumber, String? email) async {
    emit(const ContactsState());

    final PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      final Contact contact = Contact.fromVCard(userDataToVCard(firstName, lastName, phoneNumber, email));
      try {
        await FlutterContacts.insertContact(contact);
        emit(const ContactsState(contactAdded: true));
      } on Exception {
        emit(const ContactsState(error: AddContactError));
      }
    } else {
      emit(const ContactsState(error: ContactPermissionError));
    }
  }

  Future<void> addContactAndroid(String? firstName, String? lastName, String? phoneNumber, String? email) async {
    emit(const ContactsState());

    final PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus.isGranted) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.INSERT',
        type: 'vnd.android.cursor.dir/contact',
        arguments: <String, dynamic>{
          'name': '$firstName $lastName',
          'email': '$email',
          'phone': '$phoneNumber',
        },
      );

      try {
        await intent.launch();
        emit(const ContactsState(contactAdded: true));
      } on Exception {
        emit(const ContactsState(error: AddContactError));
      }
    } else {
      emit(const ContactsState(error: ContactPermissionError));
    }
  }
}

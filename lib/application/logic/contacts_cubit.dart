import 'dart:io';

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

  bool isValidVcard(String vCard) {
    bool isValid = false;
    if (vCard.substring(0, 11) == "BEGIN:VCARD" && vCard.substring(vCard.length - 9, vCard.length) == "END:VCARD") {
      isValid = true;
    }
    return isValid;
  }

  Future<void> addContact(String vCard) async {
    try {
      if (!isValidVcard(vCard)) {
        emit(ContactsState(error: InvalidVcardError()));
        return;
      }
      Contact contact = Contact.fromVCard(vCard);
      final PermissionStatus permissionStatus = await Permission.contacts.request();
      if (permissionStatus.isGranted) {
        if (Platform.isAndroid) {
          await _addContactAndroid(contact);
        } else if (Platform.isIOS) {
          await _addContactIOS(contact);
        } else {
          emit(const ContactsState(error: ContactPermissionError));
        }
      }
    } on Exception {
      emit(ContactsState(error: AddContactError()));
    }
  }

  Future<void> _addContactIOS(Contact contact) async {
    emit(const ContactsState());

    try {
      await FlutterContacts.insertContact(contact);
      emit(const ContactsState(contactAddedIOS: true));
    } on Exception {
      emit(ContactsState(error: AddContactError()));
    }
  }

  Future<void> _addContactAndroid(Contact contact) async {
    emit(const ContactsState());

    String phoneNumber = "";
    String email = "";
    if (contact.phones.isNotEmpty) {
      phoneNumber = contact.phones[0].number;
    }
    if (contact.emails.isNotEmpty) {
      email = contact.emails[0].address;
    }

    AndroidIntent intent = AndroidIntent(
      action: 'android.intent.action.INSERT',
      type: 'vnd.android.cursor.dir/contact',
      arguments: <String, dynamic>{
        'name': '${contact.name.first} ${contact.name.last}',
        'email': email,
        'phone': phoneNumber,
      },
    );

    try {
      await intent.launch();
      emit(const ContactsState(contactAddedAndroid: true));
    } on Exception {
      emit(ContactsState(error: AddContactError()));
    }
  }
}

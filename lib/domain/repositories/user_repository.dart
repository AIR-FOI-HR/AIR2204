import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deep_conference/constants/my_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/users.dart';

class UserRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const UserRepository({required this.auth, required this.firestore});

  Future<AppUser?> getUserData() async {
    final DocumentReference<Map<String, dynamic>> userQuery =
        firestore.collection(MyCollections.users).doc(auth.currentUser!.uid);
    final AppUser? userData = await userQuery.get().then((snapshot) {
      if (snapshot.data() != null) {
        return AppUser.fromJson(snapshot.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
    return userData;
  }

  Future<void> writeUserData(
      String email, String firstName, String lastName, String companyUrl, String phoneNumber) async {
    final AppUser user = AppUser(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      companyUrl: companyUrl,
    );
    final Map<String, dynamic> json = user.toJson();
    final docUser = firestore.collection(MyCollections.users).doc(auth.currentUser!.uid);
    await docUser.set(json);
  }
}

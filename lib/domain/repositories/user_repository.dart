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

  List<String> checkAuthProvider() {
    List<String> providers = [];
    User? user = auth.currentUser;
    for (var i = 0; i < user!.providerData.length; i++) {
      providers.add(user.providerData[i].providerId);
    }
    return providers;
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
    final docUser = firestore.collection(MyCollections.users).doc(auth.currentUser!.uid);
    await docUser.set(user.toJson());
  }

  Future<dynamic> reauthenticateUser(String currentPassword) async {
    try {
      final User? user = auth.currentUser;
      final cred = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }

  Future<dynamic> changePassword(String newPassword) async {
    try {
      final User? user = auth.currentUser;
      await user!.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      return e;
    }
  }
}

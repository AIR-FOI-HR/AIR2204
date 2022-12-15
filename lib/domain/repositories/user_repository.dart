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

  //all user data strings should be nullable, so we only set the fields that user actually provided
  Future<void> writeUserData(String firstName) async {
    final docRef = firestore.collection(MyCollections.users).doc(auth.currentUser!.uid);
    await docRef.set({'firstName': firstName});
  }
}

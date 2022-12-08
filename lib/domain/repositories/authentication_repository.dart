import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../constants/my_collections.dart';

class AuthenticationRepository {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const AuthenticationRepository({required this.googleSignIn, required this.auth, required this.firestore});

  void signOut() {
    auth.signOut();
    googleSignIn.signOut();
  }

  bool isEmailVerified() {
    return auth.currentUser!.emailVerified;
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  String getUserId() {
    return auth.currentUser!.uid;
  }

  Future<void>? reloadUser() {
    if (auth.currentUser != null) {
      return auth.currentUser?.reload();
    } else {
      return null;
    }
  }

  Future<void> sendVerificationEmail() async {
    final user = getCurrentUser();
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> createUser(String email, String password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);
    await createSavedItems();
  }

  Future<void> signIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signInGoogle() async {
    final googleSignInAccount = await googleSignIn.signIn();
    final googleSignInAuthentication = await googleSignInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult = await auth.signInWithCredential(credential);

    if (authResult.additionalUserInfo!.isNewUser) {
      if (authResult.user != null) {
        await createSavedItems();
      }
    }
  }

  Future<void> createSavedItems() async {
    final docRef = firestore.collection(MyCollections.savedItems).doc(auth.currentUser!.uid);
    final Map<String, dynamic> savedItems = {
      "savedItems": [],
    };
    await docRef.set(savedItems);
  }
}

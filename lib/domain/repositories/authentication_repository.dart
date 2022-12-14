import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    await auth.signInWithCredential(credential);
  }
}

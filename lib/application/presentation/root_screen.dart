import 'package:deep_conference/application/presentation/email_verification.dart';
import 'package:deep_conference/application/presentation/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({
    super.key,
  });
  @override
  State<RootScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const EmailVerificationScreen();
          } else {
            return const LoginScreen();
          }
        });
  }
}

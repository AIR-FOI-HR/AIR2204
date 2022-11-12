import 'package:expandable_attempt/screens/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/cubit/auth_cubit.dart';
import 'email_verification.dart';
import 'navigation.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const EmailVerificationScreen();
        } else if (BlocProvider.of<AuthCubit>(context).state.guestLogin ==
            true) {
          return const BottomNavigation();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}

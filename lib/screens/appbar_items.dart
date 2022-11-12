import 'dart:developer';

import 'package:expandable_attempt/screens/root_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Utilities/utils.dart';

class AppBarButtons extends StatefulWidget {
  const AppBarButtons({super.key});

  @override
  State<AppBarButtons> createState() => _AppBarButtonsState();
}

class _AppBarButtonsState extends State<AppBarButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: MaterialButton(
            onPressed: () => {
              Navigator.of(context).pushNamed('/mySchedule').then(
                    (_) => setState(() {}),
                  )
            },
            child: const Icon(
              Icons.directions_bike,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class AppBarActions extends StatelessWidget {
  AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = FirebaseAuth.instance.currentUser!.email;
          return Row(
            children: [
              Text('User: $user'),
              MaterialButton(
                onPressed: () {
                  logOut();
                },
                child: const Icon(
                  Icons.lock_open,
                  size: 20,
                ),
              ),
            ],
          );
        } else {
          return MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const RootScreen(guestLogin: false)),
              );
            },
            child: const Icon(
              Icons.login,
              size: 20,
            ),
          );
        }
      },
    );
  }
}

void logOut() {
  Utils.showSnackBar('Logged Out');
  FirebaseAuth.instance.signOut();
}

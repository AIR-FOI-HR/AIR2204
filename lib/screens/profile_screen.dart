import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_attempt/cubits/cubit/auth_cubit.dart';
import 'package:expandable_attempt/data/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'appbar_items.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.title,
    required this.color,
  });

  final String title;
  final MaterialAccentColor color;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<AppUser> readUser() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((snapshot) => AppUser.fromJson(snapshot.data()!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: widget.color,
        centerTitle: true,
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          const AppBarActions(),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state.guestLogin == false) {
            return FutureBuilder<AppUser>(
              future: readUser(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final AppUser user = snapshot.data!;
                  return Column(
                    children: [
                      Text('Email: ${user.email}'),
                      Text('Name: ${user.firstName} ${user.lastName}'),
                      Text('Company: ${user.companyUrl}'),
                      Text('Phone number: ${user.phoneNumber}'),
                    ],
                  );
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Please log in to view personal schedule',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
              },
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Please log in to view personal schedule',
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

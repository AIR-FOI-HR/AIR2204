import 'dart:async';
import 'package:deep_conference/application/presentation/schedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Utilities/utils.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_icons.dart';
import '../../constants/nav_bar_items.dart';
import '../logic/navigation_cubit.dart';
import 'bottom_navigation.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(
      () {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      },
    );
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } on FirebaseAuthException catch (e) {
      e.code == 'too-many-requests'
          ? Utils.showSnackBar('You pressed the button too many times. Try again later.')
          : Utils.showSnackBar(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return Scaffold(
        bottomNavigationBar: const BottomNavBar(),
        body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            //when you make a new functionality screen, return it where appropriate
            if (state.navbarItem == NavbarItem.schedule) {
              return const ScheduleScreen();
            } else if (state.navbarItem == NavbarItem.profile) {
              return const ScheduleScreen();
            } else if (state.navbarItem == NavbarItem.mySchedule) {
              return const ScheduleScreen();
            } else {
              return const ScheduleScreen();
            }
          },
        ),
      );
    } else {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(MyIcons.authBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Text('A verification email has been sent',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(overflow: TextOverflow.visible),
                    textAlign: TextAlign.center),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: canResendEmail ? MyColors.color772DFF : MyColors.color3A3A3A,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60)),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                  child: Text(
                    "Resend Email",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: MyColors.color772DFF, decoration: TextDecoration.underline),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}

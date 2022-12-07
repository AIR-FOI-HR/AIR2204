import 'dart:async';
import 'package:deep_conference/application/logic/authentication_cubit.dart';
import 'package:deep_conference/application/presentation/schedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/my_colors.dart';
import '../../constants/my_icons.dart';
import '../../constants/nav_bar_items.dart';
import '../logic/navigation_cubit.dart';
import 'auth_widgets.dart';
import 'bottom_navigation.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationCubit>().isEmailVerified(timer);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //return Text('here', style: Theme.of(context).textTheme.bodyLarge);
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(builder: (context, authState) {
      if (authState.isEmailVerified) {
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
                children: [
                  Text('A verification email has been sent',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(overflow: TextOverflow.visible),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  AuthButtonWidget(
                    label: 'Resend Email',
                    onPressed: authState.canResendEmail
                        ? () => context.read<AuthenticationCubit>().sendVerificationEmail()
                        : () {},
                    backgroundColor:
                        authState.canResendEmail ? MyColors.color772DFF : MyColors.color772DFF.withAlpha(60),
                  ),
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: MyColors.colorFFFFFF, decoration: TextDecoration.underline),
                    ),
                    onPressed: () => context.read<AuthenticationCubit>().signOut(),
                  )
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}

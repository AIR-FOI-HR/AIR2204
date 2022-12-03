import 'package:deep_conference/application/presentation/bottom_navigation.dart';
import 'package:deep_conference/application/presentation/login_screen.dart';
import 'package:deep_conference/application/presentation/personal_schedule.dart';
import 'package:deep_conference/application/presentation/schedule_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/nav_bar_items.dart';
import '../logic/navigation_cubit.dart';

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
                    return const PersonalSchedule();
                  } else {
                    return const ScheduleScreen();
                  }
                },
              ),
            );
          } else {
            return const LoginScreen();
          }
        });
  }
}

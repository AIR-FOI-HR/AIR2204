import 'package:deep_conference/application/presentation/schedule_screen.dart';
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
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return Container(
            clipBehavior: Clip.hardEdge,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(color: Theme.of(context).colorScheme.secondary, spreadRadius: 0, blurRadius: 20),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: state.index,
              unselectedItemColor: Theme.of(context).colorScheme.shadow,
              selectedItemColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Schedule',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 24,
                  ),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.schedule,
                  ),
                  label: 'My Schedule',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  context.read<NavigationCubit>().getNavBarItem(NavbarItem.schedule);
                } else if (index == 1) {
                  context.read<NavigationCubit>().getNavBarItem(NavbarItem.profile);
                } else if (index == 2) {
                  context.read<NavigationCubit>().getNavBarItem(NavbarItem.mySchedule);
                }
              },
            ),
          );
        },
      ),
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
            return Container();
          }
        },
      ),
    );
  }
}

import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/nav_bar_items.dart';
import '../cubits/cubit/navigation_cubit.dart';
import 'home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.index,
            showUnselectedLabels: false,
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Schedule',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: 'Profile',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.schedule,
                ),
                label: 'My Schedule',
              ),
            ],
            onTap: (index) {
              if (index == 0) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.schedule);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.profile);
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(context)
                    .getNavBarItem(NavbarItem.mySchedule);
              }
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
        if (state.navbarItem == NavbarItem.schedule) {
          return const HomeScreen(
              color: Colors.deepPurpleAccent, title: 'Schedule');
        } else if (state.navbarItem == NavbarItem.profile) {
          return const HomeScreen(
              color: Colors.deepPurpleAccent, title: 'Schedule');
        } else if (state.navbarItem == NavbarItem.mySchedule) {
          return MySchedule(color: Colors.cyanAccent, title: 'Schedule');
        } //else if (state.navbarItem == NavbarItem.login) {
        //return LoginWidget();
        // }
        return Container();
      }),
    );
  }
}

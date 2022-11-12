import 'package:expandable_attempt/cubits/cubit/saved_cubit.dart';
import 'package:expandable_attempt/screens/login_screen.dart';
import 'package:expandable_attempt/screens/my_schedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/nav_bar_items.dart';
import '../cubits/cubit/navigation_cubit.dart';
import '../data/models/schedule_item_model.dart';
import 'home_screen.dart';
import 'item_detail.dart';

class RootScreen extends StatefulWidget {
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
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Schedule',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
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
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.schedule);
              } else if (index == 1) {
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.profile);
              } else if (index == 2) {
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavbarItem.mySchedule);
              }
            },
          );
        },
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(builder: (context, state) {
        if (state.navbarItem == NavbarItem.schedule) {
          return HomeScreen(color: Colors.deepPurpleAccent, title: 'Schedule');
        } else if (state.navbarItem == NavbarItem.profile) {
          return HomeScreen(color: Colors.deepPurpleAccent, title: 'Schedule');
          ;
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

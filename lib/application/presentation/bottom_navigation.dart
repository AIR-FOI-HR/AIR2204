import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/my_colors.dart';
import '../../constants/nav_bar_items.dart';
import '../logic/navigation_cubit.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.hardEdge,
          height: 50,
          decoration: const BoxDecoration(
            color: MyColors.color3A3A3A,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(24),
              topLeft: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(color: MyColors.color3A3A3A, spreadRadius: 0, blurRadius: 20),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: state.navbarItem == NavbarItem.schedule
                    ? IconButton(
                        icon: const Icon(Icons.home, color: MyColors.colorD9D9D9),
                        onPressed: () => onNavButtonPressed(NavbarItem.schedule),
                      )
                    : IconButton(
                        icon: const Icon(Icons.home, color: MyColors.color9B9A9B),
                        onPressed: () => onNavButtonPressed(NavbarItem.schedule),
                      ),
              ),
              Expanded(
                child: state.navbarItem == NavbarItem.profile
                    ? IconButton(
                        icon: const Icon(Icons.person, color: MyColors.colorD9D9D9),
                        onPressed: () => onNavButtonPressed(NavbarItem.profile),
                      )
                    : IconButton(
                        icon: const Icon(Icons.person, color: MyColors.color9B9A9B),
                        onPressed: () => onNavButtonPressed(NavbarItem.profile),
                      ),
              ),
              Expanded(
                child: state.navbarItem == NavbarItem.mySchedule
                    ? IconButton(
                        icon: const Icon(Icons.schedule, color: MyColors.colorD9D9D9),
                        onPressed: () => onNavButtonPressed(NavbarItem.mySchedule),
                      )
                    : IconButton(
                        icon: const Icon(Icons.schedule, color: MyColors.color9B9A9B),
                        onPressed: () => onNavButtonPressed(NavbarItem.mySchedule),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  void onNavButtonPressed(NavbarItem item) {
    context.read<NavigationCubit>().getNavBarItem(item);
  }
}

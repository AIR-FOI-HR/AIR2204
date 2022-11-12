//import 'dart:html';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/nav_bar_items.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavbarItem.schedule, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.schedule:
        emit(NavigationState(NavbarItem.schedule, 0));
        break;
      case NavbarItem.profile:
        emit(NavigationState(NavbarItem.profile, 1));
        break;
      case NavbarItem.mySchedule:
        emit(NavigationState(NavbarItem.mySchedule, 2));
        break;
      //možda treba maknuti, nemoj zaboraviti maknuti onda i iz navbaritems.dart
      case NavbarItem.login:
        emit(NavigationState(NavbarItem.login, 3));
        break;
    }
  }
}

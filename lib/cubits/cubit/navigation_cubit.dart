import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/nav_bar_items.dart';
part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.schedule, 0));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.schedule:
        emit(const NavigationState(NavbarItem.schedule, 0));
        break;
      case NavbarItem.profile:
        emit(const NavigationState(NavbarItem.profile, 1));
        break;
      case NavbarItem.mySchedule:
        emit(const NavigationState(NavbarItem.mySchedule, 2));
        break;
      //možda treba maknuti, nemoj zaboraviti maknuti onda i iz navbaritems.dart
      case NavbarItem.login:
        emit(const NavigationState(NavbarItem.login, 3));
        break;
    }
  }
}

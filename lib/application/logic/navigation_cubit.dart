import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/nav_bar_items.dart';
part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NavbarItem.schedule));

  void getNavBarItem(NavbarItem navbarItem) {
    switch (navbarItem) {
      case NavbarItem.schedule:
        emit(const NavigationState(NavbarItem.schedule));
        break;
      case NavbarItem.profile:
        emit(const NavigationState(NavbarItem.profile));
        break;
      case NavbarItem.mySchedule:
        emit(const NavigationState(NavbarItem.mySchedule));
        break;
    }
  }
}

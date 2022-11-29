part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final NavbarItem navbarItem;

  const NavigationState(this.navbarItem);

  @override
  List<Object?> get props => [navbarItem];
}

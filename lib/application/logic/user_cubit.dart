import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/users.dart';
import '../../domain/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this.userRepository) : super(const UserState());
  final UserRepository userRepository;

  void getUserData() async {
    try {
      final AppUser? user = await userRepository.getUserData();
      if (user != null) {
        emit(UserState(
            userData: true,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            companyUrl: user.companyUrl,
            phoneNumber: user.phoneNumber));
      } else {
        emit(const UserState());
      }
    } on Exception {
      // TODO
    }
  }
  //FOR USER DATA EDITING SCREEN
  // void writeUserData(String firstName) async {
  //   try {
  //     await userRepository.writeUserData(firstName);
  //   } on Exception {
  //     // TODO
  //   }
  //   ;
  // }
}

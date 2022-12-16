import 'package:deep_conference/domain/models/user_error.dart';
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
          phoneNumber: user.phoneNumber,
        ));
      } else {
        emit(UserState(error: UserNoDataAvailable()));
      }
    } on Exception {
      emit(UserState(error: UserDataError()));
    }
  }

  //FOR USER DATA EDITING SCREEN
  // Future<void> writeUserData(
  //     String email, String firstName, String lastName, String companyUrl, String phoneNumber) async {
  //   final AppUser user = AppUser(
  //     email: email,
  //     firstName: firstName,
  //     lastName: lastName,
  //     phoneNumber: phoneNumber,
  //     companyUrl: companyUrl,
  //   );
  //   final Map<String, dynamic> json = user.toJson();
  //   final docUser = firestore.collection(MyCollections.users).doc(auth.currentUser!.uid);
  //   await docUser.set(json);
  // }
}

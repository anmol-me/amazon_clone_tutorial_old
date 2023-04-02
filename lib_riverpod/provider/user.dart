import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/users.dart';

final userProvider = Provider((ref) => UserNotifier());

final userNotifierProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());

// final userDataFuture = FutureProvider((ref) => UserNotifier().checkToken());

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
          User(
            id: '',
            name: '',
            email: '',
            password: '',
            address: '',
            type: '',
            token: '',
            // cart: [],
          ),
        );

  void setUser(String user) {
    state = User.fromJson(user);
  }

  String getUserAsJson() {
    return state.toJson();
  }

  User userData() {
    return state;
  }

  // bool checkToken() {
  //   log('check: ${state.token}');
  //
  //   if (state.token != '') {
  //     print('true: ${state.token}');
  //     return true;
  //   } else {
  //     print('false: ${state.token}');
  //     return false;
  //   }
  // }
  //
  bool isTokenPresent() {
    log('check: ${state.token}');

    if (state.token != '') {
      print('true: ${state.token}');
      return true;
    } else {
      print('false: ${state.token}');
      return false;
    }
  }
}

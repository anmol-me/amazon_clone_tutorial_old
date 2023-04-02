import 'dart:convert';
import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/error_handling.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../lib_riverpod/utilities.dart';
import '../../../../lib/constants/global_variables.dart' as gv;

import '../../../common_elements/e_bottom_bar.dart';
import '../../../models/users.dart';
import '../../../provider/user.dart';

final authServiceProvider = Provider((ref) {
  return AuthService(ref);
});

class AuthService {
  final ProviderRef ref;

  AuthService(this.ref);

  //
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        // cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('${gv.uri}/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context: context,
            content: 'Account Created, Login with same credentials',
          );
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: '$e');
      log(e.toString());
    }
  }

  ///
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {

      log('SignIn: 1');

      http.Response res = await http.post(
        // Uri.parse('${gv.uri}/api/signin'),
        Uri.parse('http://192.168.1.34:3000/api/signin'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      log('SignIn: 2');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // log(res.body);
          // ref.read(userProvider).setUser(res.body);
          ref.read(userNotifierProvider.notifier).setUser(res.body);

          await prefs.setString(
            'x-auth-token',
            jsonDecode(res.body)['token'],
          );
          Navigator.of(context).pushReplacementNamed(
            BottomBar.routeNamed,
            // (route) => false,
          );
        },
      );

      log('SignIn: 3');
    } catch (e) {
      showSnackBar(context: context, content: '$e');
      log(e.toString());
    }
  }

  ///
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
          Uri.parse('http://192.168.1.34:3000/tokenIsValid'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token!,
          });

      var response = jsonDecode(tokenRes.body);

      // Getting user data
      if (response == true) {
        http.Response userRes = await http.get(
            Uri.parse('http://192.168.1.34:3000/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            });

        // ref.read(userProvider).setUser(userRes.body);
        ref.read(userNotifierProvider.notifier).setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context: context, content: '$e');
      log(e.toString());
    }
  }
}

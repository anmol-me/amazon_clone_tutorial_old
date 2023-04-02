import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/error_handling.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:flutter_amazon_clone_tutorial_master/models/order.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../provider/user.dart';
import '../../../utilities.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices {

  /// Fetch Orders
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    // final user = ref.watch(userProvider);
    final user = ref.watch(userNotifierProvider);
    List<Order> orderList = [];
    try {
      http.Response res =
      await http.get(Uri.parse('$uri/api/orders/me'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(
              Order.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return orderList;
  }

  /// Log Out
  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');

      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeNamed,
            (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/error_handling.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_amazon_clone_tutorial_master/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/user.dart';
import '../../../utilities.dart';

final homeServicesProvider = Provider((ref) {
  return HomeServices(ref);
});

class HomeServices {
  final ProviderRef ref;

  HomeServices(this.ref);

  /// Fetch Deals
  Future<Product> fetchDealOfTheDay({
    required BuildContext context,
  }) async {
    final user = ref.watch(userNotifierProvider);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );

    try {
      log('Deal: token = ${user.token}');

      http.Response res =
      await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return product;
  }

  /// Fetch Category Products
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final user = ref.watch(userNotifierProvider);

    List<Product> productList = [];
    try {
      http.Response res = await http
          .get(Uri.parse('$uri/api/products?category=$category'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
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
    return productList;
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/error_handling.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:flutter_amazon_clone_tutorial_master/features/admin/models/sales.dart';
import 'package:flutter_amazon_clone_tutorial_master/models/order.dart';
import 'package:flutter_amazon_clone_tutorial_master/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../provider/user.dart';
import '../../../utilities.dart';

final productListProvider = StateProvider.autoDispose<List<Product>?>((ref) {
  List<Product>? productList;
  return productList;
});

final adminServicesProvider = Provider((ref) {
  return AdminServices(ref);
});

class AdminServices {
  final ProviderRef ref;

  AdminServices(this.ref);

  // Used by AddProduct
  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final user = ref.watch(userNotifierProvider);

    try {
      final cloudinary = CloudinaryPublic('df1fo8j5e', 's7zy4s5o');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }

      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imageUrls,
        category: category,
        price: price,
      );

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: product.toJson(),
      );

      log('RESPONSE: ${res.body}');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
              context: context, content: 'Product Added Successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  /// get all the products
  Future<List<Product>?> fetchAllProducts(BuildContext context) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = ref.watch(userNotifierProvider);

    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                // json is converted to String as required by fromJson
                jsonEncode(
                  jsonDecode(res.body)[i],
                  // Map[i]
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return ref.read(productListProvider.notifier).update((state) => productList);
    // return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = ref.watch(userNotifierProvider);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = ref.watch(userNotifierProvider);

    List<Order> orderList = [];
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/get-orders'), headers: {
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

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = ref.watch(userNotifierProvider);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = ref.watch(userNotifierProvider);

    List<Sales> sales = [];
    int totalEarning = 0;
    try {
      http.Response res =
          await http.get(Uri.parse('$uri/admin/analytics'), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': user.token,
      });

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };
  }
}

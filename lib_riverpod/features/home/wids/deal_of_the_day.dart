import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/models/product.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../account/wids/orders.dart';
import '../services/class_home_services.dart';

class DealOfTheDay extends ConsumerWidget {
  const DealOfTheDay({super.key});

  // fetchDealOfDay(ref) async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // fetchDealOfDay(ref);

    // final product = ref.watch(homeServicesProvider).fetchDealOfTheDay(context: context);

    final list = ref.watch(listProvider);

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10, top: 15),
            child: const Text(
              'Deal of the Day',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Image.network(
            'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
            height: 235,
            fit: BoxFit.fitHeight,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            child: const Text(
              '\$100',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
            child: const Text(
              'Rivaan',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: list
                  .map(
                    (e) => Image.network(
                      e,
                      fit: BoxFit.fitWidth,
                      width: 100,
                      height: 100,
                    ),
                  )
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ).copyWith(left: 15),
            alignment: Alignment.topLeft,
            child: Text(
              'See all deals',
              style: TextStyle(
                color: Colors.cyan[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

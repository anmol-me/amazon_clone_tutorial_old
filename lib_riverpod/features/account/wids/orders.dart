import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'single_product.dart';

class Orders extends ConsumerWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final orders = ref.watch(provider);
    final list = ref.watch(listProvider);

    // List list = [
    //   'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
    //   'https://cdn.pixabay.com/photo/2022/07/31/18/09/embroidery-7356523_960_720.jpg',
    //   'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
    //   'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
    // ];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: const Text(
                'Your Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Text(
                'See all',
                style: TextStyle(
                  color: GlobalVariables.selectedNavBarColor,
                ),
              ),
            ),
          ],
        ),
        // display orders
        Container(
          height: 170,
          padding: const EdgeInsets.only(
            left: 10,
            top: 20,
            right: 0,
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // itemCount: orders!.length,
            itemCount: list.length,
            itemBuilder: (context, index) {
              // ref.read(imageProvider.notifier).update((state) => state = list[index]);

              return ProviderScope(
                overrides: [
                  imageProvider.overrideWithValue(list[index]),
                ],
                child: GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(
                    //   context,
                    //   OrderDetailScreen.routeName,
                    //   arguments: orders![index],
                    // );
                  },
                  // child: SingleProduct(
                  //   image: orders![index].products[0].images[0],
                  // ),
                  // child: SingleProduct(
                  //     image: orders![index].products[0].images[0],
                  //     ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

final imageProvider = Provider<String>((ref) => throw UnimplementedError());

final listProvider = Provider(
  (ref) => [
    'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
    'https://cdn.pixabay.com/photo/2022/07/31/18/09/embroidery-7356523_960_720.jpg',
    'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
    'https://cdn.pixabay.com/photo/2022/07/31/19/56/girl-7356696_960_720.jpg',
  ],
);

import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/account/screens/account_screen.dart';
import '../features/home/screens/home_page.dart';

final pageProvider = StateProvider((ref) => 0);

class BottomBar extends ConsumerWidget {
  static const String routeNamed = '/actual-home';

  const BottomBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(pageProvider);

    double bottomBarWidth = 42;
    double bottomBarBorderWidth = 5;

    List<Widget> displayPages = [
      const HomePage(),
      const AccountScreen(),
      const Text('3'),
      // const CartScreen(),
    ];

    return Scaffold(
      body: displayPages[page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: page,
        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: (page) {
          ref.read(pageProvider.notifier).update((state) => page);
        },
        items: [
          // HOME
          BottomNavigationBarItem(
            label: '',
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.home_outlined,
              ),
            ),
          ),
          // ACCOUNT
          BottomNavigationBarItem(
            label: '',
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: const Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ),
          // CART
          BottomNavigationBarItem(
            icon: Container(
              width: bottomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: badge.Badge(
                elevation: 0,
                // badgeContent: Text(userCartLen.toString()),
                badgeContent: const Text('2'),
                badgeColor: Colors.white,
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

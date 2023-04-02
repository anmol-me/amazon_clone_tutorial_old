import 'package:flutter/material.dart';

import 'common_elements/e_bottom_bar.dart';
import 'features/admin/pages/add_product_page.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_page.dart';

Route<dynamic> onGeneratedRoutes(RouteSettings routeSettings) {
  switch (routeSettings.name) {

    /// Auth Screen
    case AuthScreen.routeNamed:
      return MaterialPageRoute(builder: (_) => const AuthScreen());

  /// Home Screen
    case HomePage.routeNamed:
      return MaterialPageRoute(builder: (_) => const HomePage());

  /// BottomBar
    case BottomBar.routeNamed:
      return MaterialPageRoute(builder: (_) => const BottomBar());

  /// AddProduct
    case AddProductPage.routeNamed:
      return MaterialPageRoute(builder: (_) => const AddProductPage());

    /// Default
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(child: Text('Screen does not exist!')),
        ),
      );
  }
}

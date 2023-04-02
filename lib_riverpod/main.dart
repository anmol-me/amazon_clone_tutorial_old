import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import './features/auth/screens/auth_screen.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';

import 'common_elements/e_bottom_bar.dart';
import 'features/admin/pages/admin_page.dart';
import 'features/auth/services/auth_service.dart';
import 'provider/user.dart';
import 'router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("***** This is my App *****");
    ref.read(authServiceProvider).getUserData(context);
    final userToken = ref.read(userNotifierProvider.notifier).isTokenPresent();
    final user = ref.read(userNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      onGenerateRoute: (settings) => onGeneratedRoutes(settings),
      home: user.token.isNotEmpty
          ? user.type == 'user'
              ? const BottomBar()
              : const AdminPage()
          : const AuthScreen(),
      // home: ref.watch(userDataFuture).when(
      //       error: (e, s) => Text(e.toString()),
      //       loading: () => const Text('Loading...'),
      //       data: (user) =>
      //           user == null ? const HomeScreen() : const AuthScreen(),
      // home: userProvider.,
      // ),
    );
  }
}

// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   ConsumerState createState() => _MyAppState();
// }
//
// class _MyAppState extends ConsumerState<MyApp> {
//
//   @override
//   void initState() {
//     ref.read(authServiceProvider).getUserData(context);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print("***** This is my App *****");
//     // ref.read(authServiceProvider).getUserData(context);
//     final userProvider = ref.watch(userNotifierProvider);
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Amazon Clone',
//       theme: ThemeData(
//         scaffoldBackgroundColor: GlobalVariables.backgroundColor,
//         colorScheme: const ColorScheme.light(
//           primary: GlobalVariables.secondaryColor,
//         ),
//         appBarTheme: const AppBarTheme(
//           elevation: 0,
//           iconTheme: IconThemeData(
//             color: Colors.black,
//           ),
//         ),
//       ),
//       onGenerateRoute: (settings) => onGeneratedRoutes(settings),
//       home: userProvider.checkToken() ? const HomeScreen() : const AuthScreen(),
//       // home: ref.watch(userDataFuture).when(
//       //       error: (e, s) => Text(e.toString()),
//       //       loading: () => const Text('Loading...'),
//       //       data: (user) =>
//       //           user == null ? const HomeScreen() : const AuthScreen(),
//       // home: userProvider.,
//       // ),
//     );
//   }
// }

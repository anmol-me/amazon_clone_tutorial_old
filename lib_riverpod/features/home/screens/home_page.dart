import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../provider/user.dart';
import '../../auth/screens/auth_screen.dart';
import '../wids/address_box.dart';
import '../wids/carousel_img.dart';
import '../wids/deal_of_the_day.dart';
import '../wids/top_cat.dart';

class HomePage extends ConsumerWidget {
  static const routeNamed = '/home-screen';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userNotifierProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text Field
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.only(top: 5),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search amazon.in',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Mic Icon after TextField
              Container(
                color: Colors.transparent,
                height: 42,
                margin: const EdgeInsets.only(left: 10),
                child: const Icon(
                  Icons.mic,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeNamed);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // Text('Welcome ${userNotifier.userData().name}'),
            AddressBox(),
            SizedBox(height: 10),
            TopCat(),
            SizedBox(height: 10),
            CarouselImage(),
            DealOfTheDay(),
          ],
        ),
      ),
    );
  }
}

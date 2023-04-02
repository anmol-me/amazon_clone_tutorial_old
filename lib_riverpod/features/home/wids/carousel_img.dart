import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
      ),
      items: GlobalVariables.carouselImages
          .map(
            (img) => Builder(
              builder: (context) => Image.network(
                img,
                fit: BoxFit.cover,
                height: 200,
              ),
            ),
          )
          .toList(),
    );
  }
}

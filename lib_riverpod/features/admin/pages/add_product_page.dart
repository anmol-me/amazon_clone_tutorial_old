import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone_tutorial_master/common/widgets/custom_button.dart';
import 'package:flutter_amazon_clone_tutorial_master/common/widgets/custom_textfield.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/global_variables.dart';
import 'package:flutter_amazon_clone_tutorial_master/constants/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../services/admin_services.dart';

// enum ProductCategories {
//   mobiles,
//   essentials,
//   appliances,
//   books,
//   fashion,
// }

final productCategoriesListProvider = StateProvider((ref) {
  return [
    'Mobiles',
    'Essentials',
    'Appliances',
    'Books',
    'Fashion',
  ];
});

final productsCategoriesProvider = StateProvider((ref) {
  final productCategoriesList = ref.watch(productCategoriesListProvider);

  return productCategoriesList[0];
});

final imagesProvider = StateProvider<List<File>>((ref) => []);

final newProductImagesProvider = Provider<File?>((ref) => null);

class AddProductPage extends HookConsumerWidget {
  static const String routeNamed = '/add-product';

  const AddProductPage({super.key});

  void selectImage(WidgetRef ref) async {
    var pickedImage = await pickImages();
    ref.read(imagesProvider.notifier).update((state) => pickedImage);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addProductFormKey = GlobalKey<FormState>();
    final imageLoader = ref.watch(imagesProvider);
    final productCategories = ref.watch(productsCategoriesProvider);
    print(productCategories);
    final productCategoriesList = ref.watch(productCategoriesListProvider);

    final productNameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final priceController = useTextEditingController();
    final quantityController = useTextEditingController();

    void sellProduct() {
      if (addProductFormKey.currentState!.validate() &&
          imageLoader.isNotEmpty) {
        ref.watch(adminServicesProvider).sellProduct(
              context: context,
              name: productNameController.text,
              description: descriptionController.text,
              price: double.parse(priceController.text),
              quantity: double.parse(quantityController.text),
              category: productCategories,
              images: imageLoader,
            );
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Add Product',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                imageLoader.isNotEmpty
                    ? CarouselSlider(
                        items: imageLoader.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: () => selectImage(ref),
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Select Product Images',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: productNameController,
                  hintText: 'Product Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description',
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: priceController,
                  hintText: 'Price',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: quantityController,
                  hintText: 'Quantity',
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String?>(
                    value: productCategories,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (newCategory) {
                      ref.read(productsCategoriesProvider.notifier).update(
                            (state) => newCategory!,
                          );
                    },
                    items: productCategoriesList.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Sell',
                  onTap: sellProduct,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../products_card/product.dart';
import 'product_description.dart';
import 'product_images.dart';
import 'top_rounded_container.dart';

class Body extends StatelessWidget {
  final VoidCallback goToProfile;

  List following;
  bool isAdmin;
  final Product product;

  Body({
    Key? key,
    required this.goToProfile,
    required this.following,
    required this.isAdmin,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView(
        children: [
          ProductImages(product: product),
          TopRoundedContainer(
            color: Color.fromARGB(255, 245, 245, 247),
            child: ProductDescription(
              goToProfile: goToProfile,
              following: following,
              product: product,
              isAdmin: isAdmin,
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

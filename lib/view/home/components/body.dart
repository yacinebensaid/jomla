import 'package:flutter/material.dart';

import 'explore_more_products.dart';
import 'explore_more_services.dart';
import 'new_products.dart';
import 'onsale_product.dart';
import 'popular_product.dart';
import 'services.dart';

import '../../../size_config.dart';
import 'categories_scroll.dart';
import 'discount_banner.dart';

class Body extends StatefulWidget {
  final VoidCallback goToExplore;
  const Body({Key? key, required this.goToExplore}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void goToExplore() {
    widget.goToExplore();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HomeBanner(),
            SizedBox(height: getProportionateScreenHeight(10)),
            Categories(goToExplore: goToExplore),
            SizedBox(height: getProportionateScreenHeight(5)),
            const PopularProducts(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const SpecialOffers(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const OnSaleProducts(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const NewProducts(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const ExploreMoreProducts(),
            SizedBox(height: getProportionateScreenHeight(90)),
          ],
        ),
      ),
    );
  }
}

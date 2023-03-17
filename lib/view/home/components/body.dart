import 'package:flutter/material.dart';
import 'package:jomla/view/home/components/popular_product.dart';
import 'search_field.dart';
import 'special_offers.dart';

import '../../../size_config.dart';
import 'categories_scroll.dart';
import 'discount_banner.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SearchField(),
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            const HomeBanner(),
            const Categories(),
            const PopularProducts(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const SpecialOffers(),
            SizedBox(height: getProportionateScreenHeight(90)),
          ],
        ),
      ),
    );
  }
}

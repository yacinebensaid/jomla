import 'package:flutter/material.dart';
import 'package:jomla/view/favourite/components/fav_products.dart';

import '../../../size_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            const FavProducts()
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'adding_newproduct_view.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(20)),
          AddProductPage(),
        ],
      ),
    );
  }
}

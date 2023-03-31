import 'package:flutter/material.dart';
import '../../../size_config.dart';
import 'categories.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(5)),
            const Categories(),
            SizedBox(height: getProportionateScreenHeight(80)),
          ],
        ),
      ),
    );
  }
}

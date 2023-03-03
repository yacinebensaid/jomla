import 'package:flutter/material.dart';
import 'package:jomla/view/subcat_details/components/card_rows.dart';
import '../../../size_config.dart';
import 'subcat_header.dart';

class Body extends StatelessWidget {
  final String maincat;

  const Body({Key? key, required this.maincat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            const HomeHeader(),
            SizedBox(height: getProportionateScreenHeight(5)),
            CardRows(maincat: maincat)
          ],
        ),
      ),
    );
  }
}

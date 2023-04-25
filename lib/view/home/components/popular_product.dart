import 'package:flutter/material.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_card.dart';
import 'package:jomla/view/products_card/loading_row.dart';
import '../../../constants/routes.dart';
import '../../products_card/product.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: getProductsForPopular(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...List.generate(
                  products.length,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 7),
                      child: ProductCard(
                          product: products[index],
                          press: () => Navigator.pushNamed(context, detailsRout,
                              arguments: ProductDetailsArguments(
                                product: products[index],
                              ))),
                    ); // here by default width and height is 0
                  },
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return LoadingRow();
      },
    );
  }
}

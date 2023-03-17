import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/product.dart';
import '../../../size_config.dart';

class FavProducts extends StatelessWidget {
  const FavProducts({super.key});

  Future<List<dynamic>> productGetter() async {
    List<dynamic> products = await getProductsForFavourite();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: productGetter(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          int numOfRows = (products.length / 2).ceil();

          return Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numOfRows,
                itemBuilder: (context, index) {
                  int startIndex = index * 2;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (startIndex < products.length)
                        ProductCard(
                          product: products[startIndex],
                          press: () => Navigator.pushNamed(
                            context,
                            detailsRout,
                            arguments: ProductDetailsArguments(
                              product: products[startIndex],
                            ),
                          ),
                        ),
                      if (startIndex + 1 < products.length)
                        ProductCard(
                          product: products[startIndex + 1],
                          press: () => Navigator.pushNamed(
                            context,
                            detailsRout,
                            arguments: ProductDetailsArguments(
                              product: products[startIndex + 1],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_card.dart';
import 'package:jomla/view/products_card/loading_row.dart';
import '../../../constants/routes.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'section_title.dart';

class OnSaleProducts extends StatelessWidget {
  const OnSaleProducts({super.key});

  Future<List<dynamic>> productGetter() async {
    List<dynamic> products = await getProductsForOnSale();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: productGetter(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SectionTitle(title: 'On sale', press: () {}),
              ),
              SizedBox(height: getProportionateScreenWidth(20)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      products.length,
                      (index) {
                        if (products[index].section == 'on_sale') {
                          return Padding(
                            padding: const EdgeInsets.only(right: 7),
                            child: ProductCard(
                                product: products[index],
                                press: () =>
                                    Navigator.pushNamed(context, detailsRout,
                                        arguments: ProductDetailsArguments(
                                          product: products[index],
                                        ))),
                          );
                        }

                        return const SizedBox
                            .shrink(); // here by default width and height is 0
                      },
                    ),
                    SizedBox(width: getProportionateScreenWidth(20)),
                  ],
                ),
              )
            ],
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return LoadingRow();
      },
    );
  }
}

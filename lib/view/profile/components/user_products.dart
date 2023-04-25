import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/product.dart';
import '../../../size_config.dart';

class UserProducts extends StatelessWidget {
  String uid;
  UserProducts({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Product>>(
      future: ProductService.searchProductByUser(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          List<Product> products = snapshot.data!;
          final cardWidth = getProportionateScreenWidth(
              160); // Width of each ProductCard widget
          final spacingWidth = getProportionateScreenWidth(
              20); // Space between each ProductCard widget
          final availableWidth = screenWidth -
              spacingWidth; // Width available for ProductCard widgets after accounting for spacing
          final numOfCards = (availableWidth / cardWidth)
              .floor(); // Calculate number of ProductCard widgets that can fit in a row
          final numOfRows = (products.length / numOfCards)
              .ceil(); // Calculate number of rows needed to display all products

          return Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              SizedBox(
                width: SizeConfig.screenWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: numOfRows,
                  itemBuilder: (context, rowIndex) {
                    final startIndex = rowIndex * numOfCards;
                    final endIndex = startIndex + numOfCards;
                    final rowProducts = products.sublist(
                        startIndex,
                        endIndex > products.length
                            ? products.length
                            : endIndex);

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: getProportionateScreenWidth(20),
                        horizontal: spacingWidth,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: rowProducts.map((product) {
                          return ProductCard(
                            product: product,
                            press: () => Navigator.pushNamed(
                              context,
                              detailsRout,
                              arguments: ProductDetailsArguments(
                                product: product,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Text("${snapshot.error}");
        }
      },
    );
  }
}

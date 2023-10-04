import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/utilities/loading_user_products.dart';

class FavProducts extends StatelessWidget {
  const FavProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width > 500
        ? 500
        : MediaQuery.of(context).size.width;

    return Center(
      child: SizedBox(
        width: 600,
        child: FutureBuilder<List>(
          future: getProductsForFavourite(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return UserProductsLoading();
            } else if (snapshot.hasData) {
              List<Product> products = snapshot.data! as List<Product>;
              const cardWidth = 160; // Width of each ProductCard widget
              const spacingWidth =
                  20.0; // Space between each ProductCard widget
              final availableWidth = screenWidth -
                  spacingWidth; // Width available for ProductCard widgets after accounting for spacing
              final numOfCards = (availableWidth / cardWidth)
                  .floor(); // Calculate number of ProductCard widgets that can fit in a row
              final numOfRows = (products.length / numOfCards)
                  .ceil(); // Calculate number of rows needed to display all products

              return ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: numOfRows,
                itemBuilder: (context, rowIndex) {
                  final startIndex = rowIndex * numOfCards;
                  final endIndex = startIndex + numOfCards;
                  final rowProducts = products.sublist(startIndex,
                      endIndex > products.length ? products.length : endIndex);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: spacingWidth,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: rowProducts.map((product) {
                        return ProductCard(
                          product: product,
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            } else {
              return DonthaveProducts();
            }
          },
        ),
      ),
    );
  }
}

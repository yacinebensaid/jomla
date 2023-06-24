import 'package:flutter/material.dart';
import 'package:jomla/view/products_card/loading_card.dart';
import '../../../size_config.dart';

class UserProductsLoading extends StatelessWidget {
  UserProductsLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    List<ProductCardShimmer> products = const [
      ProductCardShimmer(),
      ProductCardShimmer(),
      ProductCardShimmer(),
      ProductCardShimmer(),
      ProductCardShimmer(),
      ProductCardShimmer()
    ];
    final cardWidth =
        getProportionateScreenWidth(160); // Width of each ProductCard widget
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
              final rowProducts = products.sublist(startIndex,
                  endIndex > products.length ? products.length : endIndex);

              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: getProportionateScreenWidth(20),
                  horizontal: spacingWidth,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: rowProducts.map((product) {
                    return product;
                  }).toList(),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 60,
        )
      ],
    );
  }
}

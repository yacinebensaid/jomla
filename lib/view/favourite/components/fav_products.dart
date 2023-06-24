import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/profile/components/loading_user_products.dart';
import '../../../size_config.dart';

class FavProducts extends StatelessWidget {
  final VoidCallback goToProfile;

  final List following;
  final bool isAdmin;
  const FavProducts(
      {super.key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List>(
      future: getProductsForFavourite(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return UserProductsLoading();
        } else if (snapshot.hasData) {
          List<Product> products = snapshot.data! as List<Product>;
          final cardWidth = 160.w; // Width of each ProductCard widget
          final spacingWidth = 20.w; // Space between each ProductCard widget
          final availableWidth = screenWidth -
              spacingWidth; // Width available for ProductCard widgets after accounting for spacing
          final numOfCards = (availableWidth / cardWidth)
              .floor(); // Calculate number of ProductCard widgets that can fit in a row
          final numOfRows = (products.length / numOfCards)
              .ceil(); // Calculate number of rows needed to display all products

          return SizedBox(
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
                    vertical: 20.h,
                    horizontal: spacingWidth,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: rowProducts.map((product) {
                      return ProductCard(
                          product: product,
                          press: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => DetailsScreen(
                                      goToProfile: goToProfile,
                                      following: following,
                                      isAdmin: isAdmin,
                                      product: product,
                                    ))));
                          });
                    }).toList(),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text(
              'You did not like any product',
              style: TextStyle(
                fontSize: 24.w,
                color: Colors.grey,
              ),
            ),
          );
        }
      },
    );
  }
}

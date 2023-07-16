import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/utilities/loading_user_products.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_row.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget ProductsColumn({required productsList, required context}) {
  final screenWidth = MediaQuery.of(context).size.width;

  return FutureBuilder<List<Product>>(
    future: productsList,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List<Product> products = snapshot.data!;
        final cardWidth = 160.w; // Width of each ProductCard widget
        final spacingWidth = 20.w; // Space between each ProductCard widget
        final availableWidth = screenWidth -
            spacingWidth; // Width available for ProductCard widgets after accounting for spacing
        final numOfCards = (availableWidth / cardWidth)
            .floor(); // Calculate number of ProductCard widgets that can fit in a row
        final numOfRows = (products.length / numOfCards)
            .ceil(); // Calculate number of rows needed to display all products

        return Column(
          children: [
            SizedBox(height: 20.h),
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
                      vertical: 20.h,
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
              ),
            ),
          ],
        );
      } else {
        return UserProductsLoading();
      }
    },
  );
}

Widget ProductRows({required getProducts, required title}) {
  return Padding(
    padding: EdgeInsets.only(left: 10.w),
    child: FutureBuilder<List<Product>>(
      future: getProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingRow();
        } else if (snapshot.hasData) {
          List<Product> products = snapshot.data!;
          if (products.isNotEmpty) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SectionTitle(title: title, press: () {}),
                ),
                SizedBox(height: 10.h),
                SingleChildScrollView(
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
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return SizedBox.shrink();
          }
        } else {
          return SizedBox.shrink();
        }
      },
    ),
  );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            AppLocalizations.of(context)!.seemore,
            style: TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
      ],
    );
  }
}

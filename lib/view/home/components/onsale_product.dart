// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_card.dart';
import 'package:jomla/view/products_card/loading_row.dart';

import '../../../constants/routes.dart';
import '../../../size_config.dart';
import '../../products_card/product.dart';
import 'section_title.dart';

class OnSaleProducts extends StatelessWidget {
  final VoidCallback goToProfile;

  List following;
  bool isAdmin;
  OnSaleProducts(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

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
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SectionTitle(title: 'On sale', press: () {}),
              ),
              SizedBox(height: 20.h),
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
                                press: () => Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: ((context) => DetailsScreen(
                                              goToProfile: goToProfile,
                                              following: following,
                                              isAdmin: isAdmin,
                                              product: products[index],
                                            )))),
                              ));
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

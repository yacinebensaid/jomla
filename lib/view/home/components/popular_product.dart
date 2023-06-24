import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/body.dart';
import 'package:jomla/view/products_card/loading_row.dart';
import '../../products_card/product.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  final VoidCallback goToProfile;

  List following;
  bool isAdmin;
  PopularProducts(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  _PopularProductsState createState() => _PopularProductsState();
  void refreshProducts() {
    _PopularProductsState instance = _PopularProductsState();
    instance._refreshProducts();
  }
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<List<Product>> _getProductsForPopular;
  @override
  void initState() {
    _getProductsForPopular = getProductsForPopular();
    super.initState();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _getProductsForPopular = getProductsForPopular();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _getProductsForPopular,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<dynamic> products = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SectionTitle(title: 'Popular', press: () {}),
              ),
              SizedBox(height: 20.h),
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
                            press: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => DetailsScreen(
                                      goToProfile: widget.goToProfile,
                                      following: widget.following,
                                      isAdmin: widget.isAdmin,
                                      product: products[index],
                                    )),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const LoadingRow();
        }

        return const LoadingRow();
      },
    );
  }
}

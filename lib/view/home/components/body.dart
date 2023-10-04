import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jomla/services/providers.dart';

import 'package:jomla/view/products_card/product.dart';
import 'package:provider/provider.dart';

import 'categories_scroll.dart';
import 'discount_banner.dart';
import 'following_products.dart';
import 'new_products.dart';
import 'onsale_product.dart';
import 'popular_product.dart';
import 'services.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<Product>> _getProductsPopular;
  late Future<List<Product>> _getProductsOnSale;
  late Future<List<Product>> _getProductsNew;
  String usertype = 'normal';

  @override
  void initState() {
    super.initState();
    _getProductsPopular = getProductsForPopular();
    _getProductsOnSale = getProductsForOnSale();
    _getProductsNew = getProductsForNew();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    usertype = Provider.of<UserDataInitializer>(context).getUserData != null
        ? Provider.of<UserDataInitializer>(context).getUserData!.user_type
        : 'normal';
  }

  Future<void> _onRefresh() async {
    setState(() {
      _getProductsPopular = getProductsForPopular();
      _getProductsOnSale = getProductsForOnSale();
      _getProductsNew = getProductsForNew();
    });
  }

  // Rest of the code...
  Widget phoneChild() {
    return Container(
      color: const Color.fromARGB(255, 225, 238, 238),
      child: Column(
        children: [
          buildCarousel(context),
          const BuildCategories(),
          const SizedBox(
            height: 5,
          ),
          PopularProducts(
            products: _getProductsPopular,
          ),
          const SizedBox(
            height: 3,
          ),
          const Services(),
          const SizedBox(
            height: 3,
          ),
          OnSaleProducts(
            products: _getProductsOnSale,
          ),
          const SizedBox(
            height: 3,
          ),
          NewProducts(
            products: _getProductsNew,
          ),
          const SizedBox(
            height: 3,
          ),
          if (Provider.of<UserDataInitializer>(context).getUserData != null
              ? Provider.of<UserDataInitializer>(context, listen: false)
                  .getUserData!
                  .following
                  .isNotEmpty
              : false)
            const FollowingProducts()
        ],
      ),
    );
  }

  Widget webChild() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          buildCarousel(context),
          const SizedBox(height: 10),
          const BuildCategories(),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      PopularProducts(
                        products: _getProductsPopular,
                      ),
                      const Divider(),
                      OnSaleProducts(
                        products: _getProductsOnSale,
                      ),
                      const Divider(),
                      NewProducts(
                        products: _getProductsNew,
                      ),
                      const Divider(),
                      if (Provider.of<UserDataInitializer>(context)
                                  .getUserData !=
                              null
                          ? Provider.of<UserDataInitializer>(context,
                                  listen: false)
                              .getUserData!
                              .following
                              .isNotEmpty
                          : false)
                        const FollowingProducts(),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(
                width: 1,
                thickness: 1,
                color:
                    Colors.grey, // Choose the color you prefer for the divider
              ),
              const Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Services(),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: kIsWeb ? webChild() : phoneChild(),
        ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

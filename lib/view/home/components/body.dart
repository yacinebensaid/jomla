// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jomla/services/providers.dart';

import 'package:jomla/view/products_card/product.dart';
import 'package:provider/provider.dart';

import 'categories_scroll.dart';
import 'discount_banner.dart';
import 'explore_more_products.dart';
import 'following_products.dart';
import 'new_products.dart';
import 'onsale_product.dart';
import 'popular_product.dart';
import 'services.dart';

class Body extends StatefulWidget {
  final Future<List<Product>> productsPopular;
  final Future<List<Product>> productsOnSale;
  final Future<List<Product>> productsNew;

  final void Function(bool isAppBarTransparent) updateAppBarState;

  const Body({
    Key? key,
    required this.productsPopular,
    required this.updateAppBarState,
    required this.productsOnSale,
    required this.productsNew,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _scrollController = ScrollController();

  bool _isAppBarTransparent = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset <= kToolbarHeight) {
      if (!_isAppBarTransparent) {
        setState(() {
          _isAppBarTransparent = true;
        });
        widget.updateAppBarState(true);
      }
    } else {
      if (_isAppBarTransparent) {
        setState(() {
          _isAppBarTransparent = false;
        });
        widget.updateAppBarState(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            buildCarousel(context),
            Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 247),
                ),
                child: Column(children: [
                  const SizedBox(height: 10),
                  buildCategories(
                    context,
                  ),
                  const Divider(),
                  PopularProducts(
                    products: widget.productsPopular,
                  ),
                  const Divider(),
                  Services(),
                  const Divider(),
                  OnSaleProducts(
                    products: widget.productsOnSale,
                  ),
                  const Divider(),
                  NewProducts(
                    products: widget.productsNew,
                  ),
                  const Divider(),
                  if (Provider.of<UserDataInitializer>(context, listen: false)
                      .getFollowing
                      .isNotEmpty)
                    FollowingProducts(),
                  const ExploreMoreProducts(),
                ])),
          ],
        ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

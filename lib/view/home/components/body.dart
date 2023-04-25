import 'package:flutter/material.dart';
import 'package:jomla/view/explore/components/section_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'explore_more_products.dart';
import 'new_products.dart';
import 'onsale_product.dart';
import 'popular_product.dart';
import 'services.dart';
import '../../../size_config.dart';
import 'categories_scroll.dart';
import 'discount_banner.dart';

class Body extends StatefulWidget {
  final void Function(bool isAppBarTransparent) updateAppBarState;

  final VoidCallback toExplore;

  const Body(
      {Key? key, required this.toExplore, required this.updateAppBarState})
      : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void toExplore() {
    widget.toExplore();
  }

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
    return SafeArea(
        child: SingleChildScrollView(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          buildCarousel(context),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(children: [
                const SizedBox(height: 10),
                buildCategories(context, toExplore),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: SectionTitle(
                    title: AppLocalizations.of(context)!.popularproducts,
                    press: () {},
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: const PopularProducts(),
                ),
                const Divider(),
                const SpecialOffers(),
                const Divider(),
                const OnSaleProducts(),
                const Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: SectionTitle(title: 'New', press: () {}),
                ),
                const NewProducts(),
                const Divider(),
                const ExploreMoreProducts(),
                const SizedBox(height: 20),
              ]))
        ],
      ),
    ));
  }
}

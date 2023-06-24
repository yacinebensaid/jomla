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
  final List following;
  final String? userType;
  final bool isAdmin;
  final VoidCallback goToProfile;
  final void Function(bool isAppBarTransparent) updateAppBarState;

  final VoidCallback toExplore;

  const Body({
    Key? key,
    required this.userType,
    required this.toExplore,
    required this.following,
    required this.updateAppBarState,
    required this.isAdmin,
    required this.goToProfile,
  }) : super(key: key);

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
                  buildCategories(context, toExplore, widget.isAdmin,
                      widget.following, widget.goToProfile),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: PopularProducts(
                      goToProfile: widget.goToProfile,
                      following: widget.following,
                      isAdmin: widget.isAdmin,
                    ),
                  ),
                  const Divider(),
                  Services(
                    userType: widget.userType,
                    following: widget.following,
                    isAdmin: widget.isAdmin,
                    goToProfile: widget.goToProfile,
                  ),
                  const Divider(),
                  OnSaleProducts(
                    goToProfile: widget.goToProfile,
                    isAdmin: widget.isAdmin,
                    following: widget.following,
                  ),
                  const Divider(),
                  NewProducts(
                    goToProfile: widget.goToProfile,
                    isAdmin: widget.isAdmin,
                    following: widget.following,
                  ),
                  const Divider(),
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

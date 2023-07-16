import 'package:flutter/material.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/search/search.dart';
import 'package:provider/provider.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin<HomeView> {
  @override
  bool get wantKeepAlive => true;

  bool _isAppBarTransparent = true;

  void _updateAppBarState(bool isAppBarTransparent) {
    setState(() {
      _isAppBarTransparent = isAppBarTransparent;
    });
  }

  late Future<List<Product>> _getProductsPopular;
  late Future<List<Product>> _getProductsOnSale;
  late Future<List<Product>> _getProductsNew;
  @override
  void initState() {
    _getProductsPopular = getProductsForPopular();
    _getProductsOnSale = getProductsForOnSale();
    _getProductsNew = getProductsForNew();
    super.initState();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _getProductsPopular = getProductsForPopular();
      _getProductsOnSale = getProductsForOnSale();
      _getProductsNew = getProductsForNew();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfig().init(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Scaffold(
              body: Body(
                updateAppBarState: _updateAppBarState,
                productsPopular: _getProductsPopular,
                productsOnSale: _getProductsOnSale,
                productsNew: _getProductsNew,
              ),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              height: 55,
              width: SizeConfig.screenWidth,
              color: Colors.transparent.withOpacity(0.0),
              child: AppBar(
                elevation: 0,
                backgroundColor: _isAppBarTransparent
                    ? Colors.transparent.withOpacity(0.0)
                    : const Color.fromARGB(255, 28, 26, 26),
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Provider.of<HomeFunc>(context, listen: false).opendrawer();
                  },
                ),
                actions: [
                  IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    style: IconButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showSearch(
                          context: context, delegate: CustumSearchDeligate());
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

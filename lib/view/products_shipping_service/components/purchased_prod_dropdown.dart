// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/purchased/components/purchased.dart';

import '../../../../constants/routes.dart';
import 'shipping_products_card.dart';

class PurchasedProducts extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  PurchasedProducts(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  _PurchasedProductsState createState() => _PurchasedProductsState();
}

class _PurchasedProductsState extends State<PurchasedProducts> {
  late Future<List<PurchasedProduct>> _productsFuture = productsGetter();
  List<PurchasedProduct> _products = [];
  List<String> _checkedProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = productsGetter();
  }

  Future<List<PurchasedProduct>> productsGetter() async {
    List<PurchasedProduct> products = await populateDemoCarts();
    return products;
  }

  bool _isChecked(String reference) {
    return _checkedProducts.contains(reference);
  }

  void _onCheckboxChanged(bool? isChecked, String reference) {
    setState(() {
      if (isChecked!) {
        _checkedProducts.add(reference);
      } else {
        _checkedProducts.remove(reference);
      }
    });
    print(_checkedProducts);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<PurchasedProduct>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              _products = snapshot.data!;
              return StatefulBuilder(
                builder: (context, setState) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _products.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        Checkbox(
                          value: _isChecked(_products[index].purchaseID),
                          onChanged: (isChecked) => _onCheckboxChanged(
                              isChecked, _products[index].purchaseID),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Product _product = await getProductsByReference(
                                _products[index].reference);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => DetailsScreen(
                                      goToProfile: widget.goToProfile,
                                      following: widget.following,
                                      isAdmin: widget.isAdmin,
                                      product: _product,
                                    ))));
                          },
                          child: PurchasedCard(purchasedProd: _products[index]),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.youdonthaveproducts,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.grey,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

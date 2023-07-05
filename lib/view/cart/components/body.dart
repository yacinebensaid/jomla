import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:jomla/services/crud/pcf_service.dart';

import 'cart_card.dart';

class Body extends StatefulWidget {
  final VoidCallback goToProfile;
  final List following;
  final bool isAdmin;
  final List<CartProduct> products;
  final void Function(List<String> checkedProducts) oncheckedProducts;
  final void Function() reloadPage;
  const Body(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile,
      required this.oncheckedProducts,
      required this.reloadPage,
      required this.products})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> allCheckedProducts = [];

  bool isCheckedProduct(String _product) {
    return allCheckedProducts.contains(_product);
  }

  Stream<List<CartProduct>>? _cartProductsFuture;
  Future<void> _reloadCartProducts() async {
    widget.reloadPage();
  }

  late List<CartProduct> products;

  @override
  void initState() {
    super.initState();
    _reloadCartProducts();
    products = widget.products;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _reloadCartProducts,
        child: LayoutBuilder(builder: (context, constraints) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Stack(
                    children: [
                      Hero(
                        tag:
                            'product_${products[index].reference}', // Provide a unique tag for each product
                        child: CartCard(
                          reloadPage: _reloadCartProducts,
                          product: products[index],
                          goToProfile: widget.goToProfile,
                          following: widget.following,
                          isAdmin: widget.isAdmin,
                        ),
                      ),
                      Positioned(
                        left: 10,
                        top: 6,
                        child: Checkbox(
                          value: isCheckedProduct(products[index].reference),
                          onChanged: (value) {
                            List<String> _allCheckedProducts =
                                allCheckedProducts;
                            if (_allCheckedProducts
                                .contains(products[index].reference)) {
                              setState(() {
                                _allCheckedProducts
                                    .remove(products[index].reference);
                              });
                              widget.oncheckedProducts(_allCheckedProducts);
                            } else {
                              setState(() {
                                _allCheckedProducts
                                    .add(products[index].reference);
                              });
                              widget.oncheckedProducts(_allCheckedProducts);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        }));
  }
}

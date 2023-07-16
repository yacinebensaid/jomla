import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:provider/provider.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  final void Function(Map<String, CartProduct> checkedProducts)
      oncheckedProducts;
  const Body({
    Key? key,
    required this.oncheckedProducts,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Map<String, CartProduct> allCheckedProducts;

  bool isCheckedProduct(String _product) {
    return allCheckedProducts.containsKey(_product);
  }

  Stream<List<CartProduct>>? _cartProductsFuture;
  Future<void> _reloadCartProducts() async {
    setState(() {
      _cartProductsFuture = UserPCFService.getCart(); // Reload the future
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadCartProducts();
    allCheckedProducts =
        Provider.of<CheckedCartProducts>(context, listen: false).getChackeMap;
  }

  Widget donthaveproduct() {
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _reloadCartProducts,
        child: StreamBuilder<List<CartProduct>>(
            stream: _cartProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                    body: const Center(
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  if (snapshot.data!.isNotEmpty) {
                    return LayoutBuilder(builder: (context, constraints) {
                      List<CartProduct> products = snapshot.data!;
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
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 6,
                                    child: Checkbox(
                                      value: isCheckedProduct(
                                          products[index].reference),
                                      onChanged: (value) {
                                        setState(() {
                                          if (value!) {
                                            allCheckedProducts[products[index]
                                                .reference] = products[index];
                                          } else {
                                            allCheckedProducts.remove(
                                                products[index].reference);
                                          }
                                        });
                                        widget.oncheckedProducts(
                                            allCheckedProducts);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    });
                  } else {
                    return donthaveproduct();
                  }
                } else {
                  return donthaveproduct();
                }
              } else {
                return donthaveproduct();
              }
            }));
  }
}

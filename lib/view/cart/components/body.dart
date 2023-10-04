import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/cart/components/check_out_card.dart';
import 'package:provider/provider.dart';
import 'cart_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                if (snapshot.data != null) {
                  if (snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        Expanded(
                          child: LayoutBuilder(builder: (context, constraints) {
                            List<CartProduct> products = snapshot.data!;
                            List selectedItems = [];
                            allCheckedProducts.forEach((key, value) {
                              selectedItems.add(key);
                            });
                            print(selectedItems);
                            allCheckedProducts = {};
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  if (selectedItems
                                      .contains(products[index].reference)) {
                                    allCheckedProducts[products[index]
                                        .reference] = products[index];
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Stack(
                                      children: [
                                        Hero(
                                          tag:
                                              'product_${products[index].reference}', // Provide a unique tag for each product
                                          child: CartCard(
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
                                                  allCheckedProducts[
                                                          products[index]
                                                              .reference] =
                                                      products[index];
                                                } else {
                                                  allCheckedProducts.remove(
                                                      products[index]
                                                          .reference);
                                                }
                                              });
                                              Provider.of<CheckedCartProducts>(
                                                      context,
                                                      listen: false)
                                                  .updateCheckedProducts(
                                                      newCheckedMap:
                                                          allCheckedProducts);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                        ),
                        if (allCheckedProducts.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: const Offset(0, -1),
                                ),
                              ],
                            ),
                            child: CheckoutCard(
                              checkedProducts: allCheckedProducts.length,
                            ),
                          )
                      ],
                    );
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

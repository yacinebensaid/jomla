/*import 'package:flutter/material.dart';
import 'package:jomla/view/product_datails/details_view.dart';
import 'package:jomla/view/products_card/product.dart';
import 'package:jomla/view/purchased/components/purchased.dart';
import 'package:jomla/view/purchased/components/purchased_card.dart';
import '../../../../constants/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StorableProducts extends StatefulWidget {
  final void Function(List) updateTotalPrice;
  List checkedProducts;
  StorableProducts(
      {Key? key, required this.updateTotalPrice, required this.checkedProducts})
      : super(key: key);

  @override
  _PurchasedProductsState createState() => _PurchasedProductsState();
}

class _PurchasedProductsState extends State<StorableProducts> {
  late Future<List<PurchasedProduct>> _productsFuture = productsGetter();
  List<PurchasedProduct> _products = [];

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
    return widget.checkedProducts.contains(reference);
  }

  void _onCheckboxChanged(bool? isChecked, String reference) {
    setState(() {
      if (isChecked!) {
        widget.checkedProducts.add(reference);
        widget.updateTotalPrice(widget.checkedProducts);
      } else {
        widget.checkedProducts.remove(reference);
        widget.updateTotalPrice(widget.checkedProducts);
      }
    });
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
                            /* Navigator.pushNamed(
                            context,
                            detailsRout,
                            arguments: ProductDetailsArguments(
                              product: await getProductsByReference(
                                  _products[index].reference),
                            ),
                          );*/
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
}*/

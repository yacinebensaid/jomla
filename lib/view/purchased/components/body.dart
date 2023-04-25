import 'package:flutter/material.dart';
import '../../../constants/routes.dart';
import '../../../size_config.dart';
import '../../product_datails/details_view.dart';
import '../../products_card/product.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'purchased.dart';
import 'purchased_card.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<PurchasedProduct>> productsGetter() async {
    List<PurchasedProduct> products = await populateDemoCarts();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<PurchasedProduct>>(
          future: productsGetter(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              List<PurchasedProduct> products = snapshot.data!;
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () async => Navigator.pushNamed(context, detailsRout,
                        arguments: ProductDetailsArguments(
                          product: await getProductsByReference(
                              products[index].reference),
                        )),
                    child: PurchasedCard(purchasedProd: products[index]),
                  ),
                ),
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

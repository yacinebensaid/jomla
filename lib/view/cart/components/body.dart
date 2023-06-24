// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:jomla/services/crud/pcf_service.dart';

import 'cart_card.dart';

class Body extends StatefulWidget {
  final VoidCallback goToProfile;
  final List following;
  final bool isAdmin;
  const Body(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> allCheckedProducts = [];
  void addOrRemoveProduct(String CheckedProduct) {
    if (allCheckedProducts.contains(CheckedProduct)) {
      setState(() {
        allCheckedProducts.remove(CheckedProduct);
      });
    } else {
      setState(() {
        allCheckedProducts.add(CheckedProduct);
      });
    }
  }

  bool isCheckedProduct(String _product) {
    return allCheckedProducts.contains(_product);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CartProduct>>(
      future: UserPCFService.getCart(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          List<CartProduct> products = snapshot.data!;
          return LayoutBuilder(builder: (context, constraints) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        children: [
                          Hero(
                            tag:
                                'product_${products[index].reference}', // Provide a unique tag for each product
                            child: CartCard(
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
                              value:
                                  isCheckedProduct(products[index].reference),
                              onChanged: (value) {
                                addOrRemoveProduct(products[index].reference);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          });
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
    );
  }
}

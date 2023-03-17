import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../constants/routes.dart';
import '../../../services/crud/PCF_service.dart';
import '../../../size_config.dart';
import '../../product_datails/details_view.dart';
import '../../products_card/product.dart';
import '../cart.dart';
import 'cart_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Cart>> productsGetter() async {
    List<Cart> products = await populateDemoCarts();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.cart,
              style: TextStyle(color: Colors.black),
            ),
            FutureBuilder<List>(
              future: populateDemoCarts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "number of items: ${snapshot.data!.length}",
                    style: Theme.of(context).textTheme.caption,
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
        FutureBuilder<List<Cart>>(
          future: productsGetter(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Cart> products = snapshot.data!;
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Dismissible(
                        key: Key(products[index].id.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection('UserPCF')
                                .doc(userUID)
                                .collection('cart')
                                .doc(products[index].reference)
                                .delete();
                            products.removeAt(index);
                          });
                        },
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE6E6),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              const Spacer(),
                              SvgPicture.asset("assets/icons/Trash.svg"),
                            ],
                          ),
                        ),
                        child: CartCard(cart: products[index]),
                      ),
                    ),
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

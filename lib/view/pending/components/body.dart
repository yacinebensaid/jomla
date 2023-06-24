// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:jomla/view/products_card/product.dart';

import '../../../size_config.dart';
import '../../product_datails/details_view.dart';
import 'loading_pp.dart';
import 'pending.dart';
import 'pending_card.dart';

class Body extends StatefulWidget {
  final VoidCallback goToProfile;

  final List following;
  final bool isAdmin;
  const Body({
    Key? key,
    required this.goToProfile,
    required this.following,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<PendingProduct>> productsGetter() async {
    List<PendingProduct> products = await populateDemoCarts();
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PendingProduct>>(
      future: productsGetter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadRowPending();
        } else if (snapshot.hasData) {
          List<PendingProduct> products = snapshot.data!;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () async {
                  Product product =
                      await getProductsByReference(products[index].reference);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => DetailsScreen(
                            goToProfile: widget.goToProfile,
                            following: widget.following,
                            isAdmin: widget.isAdmin,
                            product: product,
                          ))));
                },
                child: PendingCard(pendingProd: products[index]),
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
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/view/pending/components/loading_pp.dart';
import 'package:jomla/view/products_card/product.dart';
import '../../product_datails/details_view.dart';
import 'purchased.dart';
import 'purchased_card.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PurchasedProduct>>(
      future: populateDemoCarts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadRowPending();
        } else if (snapshot.hasData) {
          List<PurchasedProduct> products = snapshot.data!;
          return ListView.builder(
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
                      )),
                ));
              },
              child: PurchasedCard(purchasedProd: products[index]),
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

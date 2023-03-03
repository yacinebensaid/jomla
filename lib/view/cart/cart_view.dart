import 'package:flutter/material.dart';
import 'cart.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: const Body(),
      bottomNavigationBar: const CheckoutCard(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // Change background color
      centerTitle: true, // Center the title
      title: Column(
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
    );
  }
}

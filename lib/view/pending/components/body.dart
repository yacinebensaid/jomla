import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:jomla/services/crud/pcf_service.dart';

import 'pending_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
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
    return FutureBuilder<List<CartProduct>>(
      future: UserPCFService.getPending(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        } else if (snapshot.hasData) {
          if (snapshot.data != null) {
            if (snapshot.data!.isNotEmpty) {
              List<CartProduct> products = snapshot.data!;
              return LayoutBuilder(builder: (context, constraints) {
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: PendingCard(
                          product: products[index],
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
      },
    );
  }
}

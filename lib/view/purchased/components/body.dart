import 'package:flutter/material.dart';

import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/utilities/reusable.dart';

import 'purchased_card.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<CartProduct>> _getProductsFav;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductsFav = UserPCFService.getPurchased();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _getProductsFav = UserPCFService.getPurchased();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder<List<CartProduct>>(
        future: _getProductsFav,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              if (snapshot.data!.isNotEmpty) {
                List<CartProduct> products = snapshot.data!;
                return Center(
                  child: Container(
                    width: 500,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: PurchasedCard(
                                product: products[index],
                              ),
                            );
                          });
                    }),
                  ),
                );
              } else {
                return DonthaveProducts();
              }
            } else {
              return DonthaveProducts();
            }
          } else {
            return DonthaveProducts();
          }
        },
      ),
    );
  }
}

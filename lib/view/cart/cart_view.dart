import 'package:flutter/material.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Body(),
        bottomNavigationBar: const CheckoutCard(),
      ),
    );
  }
}

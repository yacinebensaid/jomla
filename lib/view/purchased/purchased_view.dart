import 'package:flutter/material.dart';
import 'components/body.dart';

class PurchasedScreen extends StatelessWidget {
  const PurchasedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}

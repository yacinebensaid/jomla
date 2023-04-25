import 'package:flutter/material.dart';

import 'stock_for_ecom.dart';
import 'header.dart';
import 'stock_for_markets.dart';
import 'why_use_storing.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          buildHeader(),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: const [
                WhyUseStoring(),
                StockEcom(),
                SizedBox(
                  height: 25,
                ),
                StockMarkets(),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

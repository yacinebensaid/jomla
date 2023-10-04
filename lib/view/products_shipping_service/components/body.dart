// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/var_lib.dart' as vars;

import 'purchased_prod_dropdown.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Map<String, dynamic>> cities = vars.get_cities();

  late String selectedCity;

  late int totalPrice;

  @override
  void initState() {
    super.initState();
    final firstCityMap = cities.first;
    selectedCity = firstCityMap['name'];
    totalPrice = firstCityMap['price'];
  }

  void _onCitySelected(String? city) {
    if (city != null) {
      final selectedCityMap = cities.firstWhere((c) => c['name'] == city);
      final price = selectedCityMap['price'];

      setState(() {
        selectedCity = city;
        totalPrice = price;
      });
    }
  }

  void totalShippingPrice() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Shipping to your clients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: PurchasedProducts(),
                      ),
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Select Purchased Products'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Starting from: $totalPrice',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

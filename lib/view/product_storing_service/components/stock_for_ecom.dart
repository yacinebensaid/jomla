/*import 'package:flutter/material.dart';
import 'package:jomla/size_config.dart';

import 'storable_products.dart';
import 'storage_subscription.dart';

class StockEcom extends StatefulWidget {
  const StockEcom({Key? key}) : super(key: key);

  @override
  State<StockEcom> createState() => _StockEcomState();
}

int _totalPrice = 0;
List _checkedProducts = [];

class _StockEcomState extends State<StockEcom> {
  late String selectedCity;

  late int totalPrice;
  void updateTotalPrice(List products) async {
    setState(() async {
      _checkedProducts = products;
      await totalStoringPrice(products).then((value) => _totalPrice = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey, width: 2.3)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'uStoock',
                    style: TextStyle(fontSize: 33, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color.fromARGB(255, 0, 59, 185)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'e-commerce',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '• Pay only for what you need.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text:
                                '• The ability to retrieve your products at any ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'time',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: ' and with the ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: 'quantity',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: ' you want.',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• We make sure your products stay safe and provide assurance for that.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Full support and help experience.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: getProportionateScreenWidth(220),
                  height: getProportionateScreenHeight(60),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    child: const Text('choose the products'),
                    onPressed: () async {
                      // Get the total price from StorableProducts
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(0),
                            content: SingleChildScrollView(
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: StorableProducts(
                                  updateTotalPrice: updateTotalPrice,
                                  checkedProducts: _checkedProducts,
                                ),
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  // Close the dialog and update the total price
                                  Navigator.of(context).pop();
                                  setState(() {
                                    updateTotalPrice([]);
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Apply'),
                                onPressed: () {
                                  // Close the dialog and update the total price
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              _totalPrice == 0
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child:
                          Text(_totalPrice == 0 ? '' : _totalPrice.toString()),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
*/
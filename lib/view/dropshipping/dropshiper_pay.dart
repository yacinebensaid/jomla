import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/size_config.dart';
import 'dart:math';
import 'package:jomla/view/cart/components/cart.dart';
import 'package:jomla/view/cart/components/cart_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DropshiperPay extends StatefulWidget {
  const DropshiperPay({super.key});

  @override
  State<DropshiperPay> createState() => _DropshiperPayState();
}

class _DropshiperPayState extends State<DropshiperPay> {
  late String orderReference;

  @override
  void initState() {
    super.initState();
    orderReference = generateRandomReference(8);
  }

  String generateRandomReference(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
  }

  void copyToClipboard() {
    Clipboard.setData(ClipboardData(text: orderReference));
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Copied to clipboard: $orderReference")));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'Last look before confirming',
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(27),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '1. Make sure to send the complete \'total\' amount.\n\n2. Products can be sold very quickly, please pay as soon as possible.\n\n3. If you do not pay before the time ends, the products will no longer be in your Pending section or Cart.\n\n4. If we do not recieve the complete amount, we will call you in order to send the rest.\n\n5. If you pay with CCP, you have to take a picture for the payment reciept and send it to us with the order reference.',
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              FutureBuilder<List<Cart>>(
                future: populateDemoCarts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    List<Cart> products = snapshot.data!;
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              orderReference,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                              onPressed: copyToClipboard,
                              child: const Text('Copy'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        /*Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(20),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: products.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) =>
                                CartCard(cart: products[index]),
                          ),
                        ),*/
                        const SizedBox(
                          height: 20,
                        ),
                        Text.rich(
                          TextSpan(
                            text: AppLocalizations.of(context)!.totalprice,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                              fontSize: 18,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    " ${snapshot.data!.fold<double>(0, (acc, cart) => acc + num.parse(cart.product.total_price))}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 270,
                          height: getProportionateScreenHeight(56),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              foregroundColor: kPrimaryColor,
                              backgroundColor: kPrimaryColor,
                            ),
                            onPressed: (() {
                              UserPCFService.moveItemsToPending();
                              Navigator.pop(context);
                            }),
                            child: Text(
                              'Confirm Checkout!',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

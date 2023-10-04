import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/providers.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/cart/components/cart_card.dart';
import 'package:jomla/view/product_datails/components/default_btn.dart';
import 'package:jomla/view/var_lib.dart' as vars;
import 'package:provider/provider.dart';

class FinalCheckout extends StatefulWidget {
  const FinalCheckout({super.key});

  @override
  State<FinalCheckout> createState() => _FinalCheckoutState();
}

class _FinalCheckoutState extends State<FinalCheckout> {
  late String orderReference;
  List<Map<String, dynamic>> cities = vars.get_cities();

  late String selectedCity;
  late int totalPrice;

  late TextEditingController addressController;
  late TextEditingController zipCodeController;
  late TextEditingController nameController;
  late TextEditingController phoneNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    orderReference = generateRandomReference(8);
    final firstCityMap = cities.first;
    selectedCity = firstCityMap['name'];
    totalPrice = firstCityMap['price'];
    addressController = TextEditingController();
    zipCodeController = TextEditingController();
    nameController = TextEditingController(
        text: AuthService.firebase().currentUser != null &&
                Provider.of<UserDataInitializer>(context, listen: false)
                        .getUserData !=
                    null
            ? Provider.of<UserDataInitializer>(context, listen: false)
                .getUserData!
                .name
            : null);
    phoneNumberController = TextEditingController(
        text: AuthService.firebase().currentUser != null &&
                Provider.of<UserDataInitializer>(context, listen: false)
                        .getUserData !=
                    null
            ? Provider.of<UserDataInitializer>(context, listen: false)
                .getUserData!
                .phoneNumber
            : null);
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
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Checkout',
      ),
      body: AuthService.firebase().currentUser != null
          ? Provider.of<CheckedCartProducts>(context, listen: false)
                  .getChackeMap
                  .isNotEmpty
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contact Informations',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: 'Full name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null; // Return null for valid input
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Phone number',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    return null; // Return null for valid input
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Address Informations',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'City: ',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    DropdownButton<String>(
                                      value: selectedCity,
                                      onChanged: _onCitySelected,
                                      items:
                                          List.generate(cities.length, (index) {
                                        return DropdownMenuItem<String>(
                                          value: cities[index]['name'],
                                          child: Text(
                                            '${index + 1}. ${cities[index]['name']}',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please enter your address';
                                    }
                                    return null; // Return null for valid input
                                  },
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  controller: zipCodeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'ZIP Code',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please enter your ZIP code';
                                    }
                                    // Add additional validation rules here if needed
                                    return null; // Return null for valid input
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Products',
                          style: TextStyle(
                            fontSize: 22,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (10),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: Provider.of<CheckedCartProducts>(
                                      context,
                                      listen: false)
                                  .getChackeMap
                                  .length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final values = Provider.of<CheckedCartProducts>(
                                        context,
                                        listen: false)
                                    .getChackeMap
                                    .values
                                    .toList();

                                return CartCard(
                                  finalCheckout: true,
                                  product: values[index],
                                );
                              },
                            )),
                        const SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Total products price: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 247, 132, 0),
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          " ${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice}",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text.rich(
                                TextSpan(
                                  text: 'Delivery price: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 247, 132, 0),
                                    fontSize: 18,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " ${totalPrice}",
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.center,
                                child: Text.rich(
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .totalprice,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                      fontSize: 22,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            " ${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice + totalPrice}",
                                        style: const TextStyle(
                                            fontSize: 22, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              : donthaveproduct()
          : const Center(
              child: LoginDialog(
              guest: false,
            )),
      bottomNavigationBar: Provider.of<CheckedCartProducts>(context,
                  listen: false)
              .getChackeMap
              .isNotEmpty
          ? Container(
              height: 75,
              child: Column(
                children: [
                  const Divider(
                    thickness: 0.5,
                    color: Colors.black,
                    height: 0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 250,
                    child: DefaultButton(
                      text: 'Confirm Checkout!',
                      press: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: SizedBox(
                                  height: 420,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Column(children: [
                                        PaymentDialog(
                                            context: context,
                                            name: 'CCP',
                                            image: 'assets/images/ccp.png'),
                                        PaymentDialog(
                                            context: context,
                                            name: 'Edahabia',
                                            image:
                                                'assets/images/baridimob.png'),
                                        PaymentDialog(
                                            context: context,
                                            name: 'Paypal',
                                            image: 'assets/images/paypal.jpg')
                                      ]),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'cancel',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          // The form is valid, proceed with checkout logic here
                        }
                      },
                    ),
                  ),
                ],
              ))
          : null,
    );
  }

  Widget PaymentDialog(
      {required String name,
      required String image,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () async {
        final internetConnectionStatus =
            Provider.of<InternetConnectionStatus>(context, listen: false);
        if (internetConnectionStatus == InternetConnectionStatus.connected) {
          if (name == 'CCP') {
            Navigator.of(context).pop();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Important Information',
                    style: TextStyle(
                      fontSize: 22,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          '1. Make sure to send the complete \'total\' amount.\n'
                          '2. Products can be sold very quickly, please pay as soon as possible.\n'
                          '3. If you do not pay before the time ends, the products will no longer be in your Pending section or Cart.\n'
                          '4. If we do not receive the complete amount, we will call you to send the rest.\n'
                          '5. If you pay with CCP, you have to take a picture of the payment receipt and send it to us with the order reference.',
                          style:
                              TextStyle(fontSize: 17, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 30),
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
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        UserPCFService.moveItemsToPending(context);
                        Navigator.pop(context);
                      },
                      child: Text('Done'),
                    ),
                  ],
                );
              },
            );
          } else if (name == 'Paypal') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => PaypalCheckout(
                sandboxMode: true,
                clientId:
                    "ARgEWatWZA7WinqLHjuKlDtX7CP-jjA3kACHPihnMqBKKhai65vxmnJD7Ne4GtAT_S_gSD3iJFyFejva",
                secretKey:
                    "EPrKMhdFzp3FQ-0v0-aP7VC7Tsnu3GD2QKyGny6VNW7D-OrGeI1IeXp199_ZOiX4zup95U3PKRWasfrc",
                returnURL: "success.snippetcoder.com",
                cancelURL: "cancel.snippetcoder.com",
                transactions: [
                  {
                    "amount": {
                      "total":
                          '${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice + totalPrice}',
                      "currency": "USD",
                      "details": {
                        "subtotal":
                            '${Provider.of<CheckedCartProducts>(context, listen: false).getTotalPrice}',
                        "shipping": '$totalPrice',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  print("onSuccess: $params");
                },
                onError: (error) {
                  print("onError: $error");
                  Navigator.pop(context);
                },
                onCancel: () {
                  print('cancelled:');
                },
              ),
            ));
          } else {}
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('you are not connected'),
            behavior: SnackBarBehavior.floating,
          ));
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

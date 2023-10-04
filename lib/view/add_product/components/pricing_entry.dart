import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jomla/utilities/show_error_dialog.dart';

//i want oneItemPriceController to be 30% higher than priceController0, so i want to set an onchange function that shows a validation warning once the user starts typing the price an he doesn't satisfy the condition
class PriceEntryForm extends StatefulWidget {
  final List<Map<String, String>>? pricingFromAdd;
  final void Function(List<Map<String, String>> _passpricingDetails)
      passpricingDetails;

  const PriceEntryForm({
    super.key,
    required this.passpricingDetails,
    required this.pricingFromAdd,
  });
  @override
  _PriceEntryFormState createState() => _PriceEntryFormState();
}

class _PriceEntryFormState extends State<PriceEntryForm> {
  final TextEditingController oneItemPriceController = TextEditingController();
  final TextEditingController fromController0 = TextEditingController();
  final TextEditingController toController0 = TextEditingController();
  final TextEditingController priceController0 = TextEditingController();
  final TextEditingController fromController1 = TextEditingController();
  final TextEditingController toController1 = TextEditingController();
  final TextEditingController priceController1 = TextEditingController();
  final TextEditingController fromController2 = TextEditingController();
  final TextEditingController toController2 = TextEditingController();
  final TextEditingController priceController2 = TextEditingController();
  late List controllers;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Added GlobalKey
  List<PricingForm> pricingLists = [];

  @override
  void initState() {
    super.initState();

    controllers = [
      {
        'from': fromController0,
        'to': toController0,
        'price': priceController0,
      },
      {
        'from': fromController1,
        'to': toController1,
        'price': priceController1,
      },
      {
        'from': fromController2,
        'to': toController2,
        'price': priceController2,
      },
    ];

    // Set initial values from pricingFromAdd if available
    if (widget.pricingFromAdd != null) {
      final Map<String, dynamic>? pricing =
          widget.pricingFromAdd!.isNotEmpty ? widget.pricingFromAdd![0] : null;

      if (pricing != null) {
        if (pricing.containsKey('price')) {
          final String priceValue = pricing['price'];
          oneItemPriceController.text = priceValue;
        }
      }

      for (int i = 1; i <= controllers.length; i++) {
        final Map<String, dynamic>? pricing = i < widget.pricingFromAdd!.length
            ? widget.pricingFromAdd![i]
            : null;
        if (pricing != null) {
          if (pricing.containsKey('from')) {
            final String fromValue = pricing['from'];
            controllers[i - 1]['from'].text = fromValue;
          }
          if (pricing.containsKey('to')) {
            final String toValue = pricing['to'];
            controllers[i - 1]['to'].text = toValue;
          }
          if (pricing.containsKey('price')) {
            final String priceValue = pricing['price'];
            controllers[i - 1]['price'].text = priceValue;
          }
        }
      }
    }

    fromController1.addListener(() {
      final int toController0Value = int.tryParse(toController0.text) ?? 2;
      if (fromController1.text.isNotEmpty) {
        fromController1.text = (toController0Value + 1).toString();
      }
    });

    fromController2.addListener(() {
      final int toController1Value = int.tryParse(toController1.text) ?? 2;
      fromController2.text = (toController1Value + 1).toString();
    });

    pricingLists = [
      PricingForm(
        formKey: _formKey,
        fromController: controllers[0]['from'],
        toController: controllers[0]['to'],
        priceController: controllers[0]['price'],
      )
    ];
  }

  List<Map<String, String>>? getPricingDetails() {
    List<Map<String, String>> pricingDetails = [];

    double previousPrice = double.infinity;
    if (oneItemPriceController.text == '') {
      showSucessDialog(context, 'Invalid Input', 'Enter the price of one item');
    }
    int price0 = int.tryParse(priceController0.text)!;
    double minOneItemPrice = price0 + ((price0 * 30) / 100);
    if (int.tryParse(oneItemPriceController.text)! < minOneItemPrice) {
      showSucessDialog(context, 'Invalid Input',
          'The one item price should be at least $minOneItemPrice');
    } else {
      pricingDetails.add({
        'from': '1',
        'to': '1',
        'price': oneItemPriceController.text,
      });
      for (int i = 0; i < pricingLists.length; i++) {
        String fromValue = controllers[i]['from'].text;
        String toValue = controllers[i]['to'].text;
        String priceValue = controllers[i]['price'].text;

        int from = int.tryParse(fromValue) ?? 0;
        int to = int.tryParse(toValue) ?? 0;
        double price = double.tryParse(priceValue) ?? 0;
        price = price.ceilToDouble();

        if (i == 0) {
          if (from <= 1) {
            showSucessDialog(context, 'Invalid Input',
                'The entered value $fromValue for From is not valid.');

            return []; // Empty list as an indication of invalid input
          }
          if (to <= from) {
            showSucessDialog(context, 'Invalid Input',
                'The entered value $toValue for To is not valid.');

            return []; // Empty list as an indication of invalid input
          }
        } else {
          int previousTo = int.tryParse(controllers[i - 1]['to'].text) ?? 0;
          int expectedFrom = previousTo + 1;

          if (from != expectedFrom) {
            showSucessDialog(context, 'Invalid Input',
                'The entered value $fromValue for From is not valid.');

            return []; // Empty list as an indication of invalid input
          }
          if (to <= from) {
            showSucessDialog(context, 'Invalid Input',
                'The entered value $toValue for To is not valid.');

            return []; // Empty list as an indication of invalid input
          }
        }

        if (price >= previousPrice) {
          showSucessDialog(context, 'Invalid Input',
              'The entered value $priceValue for Price is not valid.');

          return []; // Empty list as an indication of invalid input
        }
        previousPrice = price;

        pricingDetails.add({
          'from': fromValue,
          'to': toValue,
          'price': priceValue,
        });
      }

      widget.passpricingDetails(pricingDetails);
      Navigator.pop(context);
      return pricingDetails;
    }
    return null;
  }

  //i want always the fromController1 = toController0 + 1 and the fromController2 = toController1 + 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Entry Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                  'Enter the price in case of selling one item only, this must be at least 30% higher than the wholesale price'),
              Row(
                children: [
                  const Text('Price of 1 item:'),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 160,
                    child: TextFormField(
                      controller: oneItemPriceController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(5),
                        // Add more input formatters as needed to format the phone number
                      ],
                      decoration: InputDecoration(
                        hintText: 'Price (da)',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 3.0, horizontal: 4.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              /////////////////////
              Column(
                children: [
                  for (int i = 0; i < pricingLists.length; i++)
                    Row(
                      children: [
                        Expanded(flex: 11, child: pricingLists[i]),
                        if (i != 0)
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  pricingLists.removeAt(i);
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  if (pricingLists.length < 3)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          pricingLists.add(PricingForm(
                              formKey: _formKey,
                              fromController: controllers[pricingLists.length]
                                  ['from'],
                              toController: controllers[pricingLists.length]
                                  ['to'],
                              priceController: controllers[pricingLists.length]
                                  ['price']));
                        });
                      },
                    ),
                ],
              ),

              ////////////////////
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    List<Map<String, dynamic>>? pricingDetails =
                        getPricingDetails();
                    print(pricingDetails);
                  }
                },
                child: const Text('Get Pricing Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PricingForm extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final TextEditingController priceController;
  final GlobalKey<FormState> formKey;
  const PricingForm({
    super.key,
    required this.fromController,
    required this.toController,
    required this.priceController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: IntrinsicWidth(
            child: Row(children: [
              const Text('From'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: fromController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                    // Add more input formatters as needed to format the phone number
                  ],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 4.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text('To'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: toController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                    // Add more input formatters as needed to format the phone number
                  ],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 4.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    } else if (int.tryParse(value) != null &&
                        int.tryParse(value)! <=
                            int.tryParse(fromController.text)!) {
                      return 'To value must be greater than or equal to From value';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(':'),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: priceController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,

                    // Add more input formatters as needed to format the phone number
                  ],
                  decoration: InputDecoration(
                    hintText: 'Price (da)',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 4.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ShippingServicePage extends StatefulWidget {
  @override
  _ShippingServicePageState createState() => _ShippingServicePageState();
}

class _ShippingServicePageState extends State<ShippingServicePage> {
  String selectedCity = 'New York';
  int selectedSubscriptionIndex = 0;
  List<String> subscriptionTypes = [
    'Basic (1 shipment/month)',
    'Pro (5 shipments/month)',
    'Premium (10 shipments/month)',
  ];

  void _onCitySelected(String? city) {
    if (city != null) {
      setState(() {
        selectedCity = city;
      });
    }
  }

  void _onSubscriptionSelected(int? index) {
    setState(() {
      selectedSubscriptionIndex = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Service'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Shipping to your clients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedCity,
              onChanged: _onCitySelected,
              items: [
                DropdownMenuItem(
                  child: Text('New York'),
                  value: 'New York',
                ),
                DropdownMenuItem(
                  child: Text('Los Angeles'),
                  value: 'Los Angeles',
                ),
                DropdownMenuItem(
                  child: Text('Chicago'),
                  value: 'Chicago',
                ),
                DropdownMenuItem(
                  child: Text('Houston'),
                  value: 'Houston',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Shipping for your clients:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: subscriptionTypes.length,
            itemBuilder: (context, index) {
              final subscriptionType = subscriptionTypes[index];
              final isSelected = selectedSubscriptionIndex == index;
              return ListTile(
                title: Text(subscriptionType),
                leading: Radio(
                  value: index,
                  groupValue: selectedSubscriptionIndex,
                  onChanged: _onSubscriptionSelected,
                ),
                trailing: isSelected ? Icon(Icons.check) : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProductStoragePage extends StatefulWidget {
  @override
  _ProductStoragePageState createState() => _ProductStoragePageState();
}

class _ProductStoragePageState extends State<ProductStoragePage> {
  String _selectedStorageType = 'Basic';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Storage Service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose your storage plan:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStorageType('Basic', '10 products', '\$5/month'),
                _buildStorageType('Premium', '50 products', '\$10/month'),
                _buildStorageType(
                    'Ultimate', 'Unlimited products', '\$20/month'),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              child: Text('Subscribe'),
              onPressed: () {
                // Implement your subscription logic here
                print('Subscribing to $_selectedStorageType plan');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageType(String type, String capacity, String price) {
    bool isSelected = _selectedStorageType == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStorageType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              type,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              capacity,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(height: 10),
            Text(
              price,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jomla/view/add_product/adding_newproduct_view.dart';
import 'package:jomla/view/order_confirmation/all_orders_view.dart';

class StaffOrientationPage extends StatefulWidget {
  const StaffOrientationPage({Key? key}) : super(key: key);

  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<StaffOrientationPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Navigate to the 'Add Product' screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductPage()),
            );
          },
          child: const Text('Add Product'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Navigate to the 'Confirm Orders' screen
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserPendingOrdersPage()),
            );
          },
          child: const Text('Confirm Orders'),
        ),
      ],
    );
  }
}

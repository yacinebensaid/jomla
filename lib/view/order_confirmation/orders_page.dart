import 'package:flutter/material.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';

class UserOrdersPage extends StatefulWidget {
  final String userUID;
  final List<Map<String, dynamic>> orders;

  const UserOrdersPage({Key? key, required this.userUID, required this.orders})
      : super(key: key);

  @override
  State<UserOrdersPage> createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userUID),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: DataService.getUserDataForOrder(widget.userUID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final fullname = snapshot.data!.name;
                  final userPhonenumber = snapshot.data!.phoneNumber;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Name: $fullname',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Phone Number: $userPhonenumber',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.orders.length,
              itemBuilder: (context, index) {
                final order = widget.orders[index];
                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(order['reference']),
                        subtitle: Text('Quantity: ${order['quantity']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Price:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${order['total_price']}'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Confirm the order
                          UserPCFService.moveItemsToPurchased(
                              order['purchaseID'], order['uid']);

                          // Remove the corresponding order from the UI
                          setState(() {
                            widget.orders.removeAt(index);
                          });
                        },
                        child: const Text('Confirm Order'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

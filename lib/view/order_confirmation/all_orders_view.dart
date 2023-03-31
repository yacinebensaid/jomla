import 'package:flutter/material.dart';
import 'package:jomla/services/crud/pcf_service.dart';
import 'orders_page.dart';

class UserPendingOrdersPage extends StatefulWidget {
  const UserPendingOrdersPage({Key? key}) : super(key: key);

  @override
  _UserPendingOrdersPageState createState() => _UserPendingOrdersPageState();
}

class _UserPendingOrdersPageState extends State<UserPendingOrdersPage> {
  late Future<Map<String, List<Map<String, dynamic>>>> _allPendingOrders;

  @override
  void initState() {
    super.initState();
    _allPendingOrders = UserPCFService.getAllPendingOrders();
  }

  Future<void> _refresh() async {
    setState(() {
      _allPendingOrders = UserPCFService.getAllPendingOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
          future: _allPendingOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              final allPendingOrders = snapshot.data!;
              return ListView.builder(
                itemCount: allPendingOrders.length,
                itemBuilder: (context, index) {
                  final userUID = allPendingOrders.keys.toList()[index];
                  final pendingOrders = allPendingOrders[userUID]!;

                  if (pendingOrders.length == 0) {
                    // Skip this user if they have no pending orders
                    return SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserOrdersPage(
                            userUID: userUID,
                            orders: pendingOrders,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(userUID),
                        subtitle: Text('${pendingOrders.length} orders'),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text('No pending orders'),
              );
            }
          },
        ),
      ),
    );
  }
}

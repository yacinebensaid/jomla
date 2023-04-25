import 'package:flutter/material.dart';

import 'components/body.dart';

class ShippingServicePage extends StatefulWidget {
  const ShippingServicePage({Key? key}) : super(key: key);

  @override
  _ShippingServicePageState createState() => _ShippingServicePageState();
}

class _ShippingServicePageState extends State<ShippingServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

import 'package:flutter/material.dart';

import 'components/body.dart';

class StoringServicePage extends StatefulWidget {
  const StoringServicePage({Key? key}) : super(key: key);

  @override
  _StoringServicePageState createState() => _StoringServicePageState();
}

class _StoringServicePageState extends State<StoringServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent.withOpacity(0),
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

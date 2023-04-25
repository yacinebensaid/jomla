import 'package:flutter/material.dart';
import 'components/body.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const Body(),
      ),
    );
  }
}

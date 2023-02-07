import 'package:flutter/material.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _UsingJomlaState();
}

class _UsingJomlaState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('sale page'),
    );
  }
}

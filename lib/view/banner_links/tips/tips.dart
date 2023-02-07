import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _UsingJomlaState();
}

class _UsingJomlaState extends State<TipsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('tips'),
    );
  }
}

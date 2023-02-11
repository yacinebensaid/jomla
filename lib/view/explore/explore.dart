import 'package:flutter/material.dart';
import 'componants/body.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Body(),
    );
  }
}

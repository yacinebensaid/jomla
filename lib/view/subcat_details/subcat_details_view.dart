import 'package:flutter/material.dart';

import 'components/body.dart';

class SubcatView extends StatefulWidget {
  const SubcatView({super.key});

  @override
  State<SubcatView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubcatView> {
  @override
  Widget build(BuildContext context) {
    final MainCatKey agrs =
        ModalRoute.of(context)?.settings.arguments as MainCatKey;
    return Scaffold(
      body: Body(maincat: agrs.maincatvalue),
    );
  }
}

class MainCatKey {
  final String maincatvalue;

  MainCatKey({required this.maincatvalue});
}

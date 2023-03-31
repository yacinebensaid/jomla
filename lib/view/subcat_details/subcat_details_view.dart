import 'package:flutter/material.dart';
import 'package:jomla/view/entrypoint/appbar.dart';
import 'package:jomla/view/product_datails/components/custom_app_bar.dart';

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
      appBar: MyCustomAppBar(context: context),
      body: Body(maincat: agrs.maincatvalue),
    );
  }
}

class MainCatKey {
  final String maincatvalue;

  MainCatKey({required this.maincatvalue});
}

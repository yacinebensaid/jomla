// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/components/appbar.dart';

import 'components/body.dart';

class SubcatView extends StatefulWidget {
  String maincatvalue;
  SubcatView({Key? key, required this.maincatvalue}) : super(key: key);

  @override
  State<SubcatView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubcatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        context: context,
      ),
      body: Body(
        maincat: widget.maincatvalue,
      ),
    );
  }
}

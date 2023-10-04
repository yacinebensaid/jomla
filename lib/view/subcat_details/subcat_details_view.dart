// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/utilities/reusable.dart';

import 'components/body.dart';

class SubcatView extends StatefulWidget {
  final String maincatvalue;
  const SubcatView({Key? key, required this.maincatvalue}) : super(key: key);

  @override
  State<SubcatView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubcatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.pop(context),
        title: widget.maincatvalue,
      ),
      body: Body(
        maincat: widget.maincatvalue,
      ),
    );
  }
}

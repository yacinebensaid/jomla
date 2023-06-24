// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/components/appbar.dart';

import 'components/body.dart';

class SubcatView extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  String maincatvalue;
  bool isAdmin;
  SubcatView(
      {Key? key,
      required this.maincatvalue,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  State<SubcatView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SubcatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCustomAppBar(
        goToProfile: widget.goToProfile,
        following: widget.following,
        context: context,
        isAdmin: widget.isAdmin,
      ),
      body: Body(
        goToProfile: widget.goToProfile,
        following: widget.following,
        maincat: widget.maincatvalue,
        isAdmin: widget.isAdmin,
      ),
    );
  }
}

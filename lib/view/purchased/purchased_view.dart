// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'components/body.dart';

class PurchasedScreen extends StatelessWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  PurchasedScreen(
      {Key? key,
      required this.isAdmin,
      required this.following,
      required this.goToProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent.withOpacity(0),
          backgroundColor: Colors.transparent.withOpacity(0),
          title: Text('Purchased'),
        ),
        body: Body(
          goToProfile: goToProfile,
          following: following,
          isAdmin: isAdmin,
        ),
      ),
    );
  }
}

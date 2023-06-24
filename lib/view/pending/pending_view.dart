// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'components/body.dart';

class PendingScreen extends StatelessWidget {
  final VoidCallback goToProfile;

  List following;
  bool isAdmin;
  PendingScreen({
    Key? key,
    required this.goToProfile,
    required this.following,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent.withOpacity(0),
          backgroundColor: Colors.transparent.withOpacity(0),
          title: Text('Pending'),
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

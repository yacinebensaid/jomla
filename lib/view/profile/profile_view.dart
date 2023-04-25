import 'package:flutter/material.dart';
import 'components/body.dart';

class ProfileScreen extends StatelessWidget {
  String uid;
  ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(uid: uid),
    );
  }
}

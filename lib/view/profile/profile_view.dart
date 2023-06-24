// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/normal_user.dart/body_normal_user.dart';

class ProfileScreen extends StatelessWidget {
  String userType;
  bool fromNav;
  List following;
  bool isAdmin;
  final VoidCallback goToProfile;

  String uid;
  ProfileScreen({
    Key? key,
    required this.userType,
    required this.fromNav,
    required this.following,
    required this.isAdmin,
    required this.goToProfile,
    required this.uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: userType == 'normal'
            ? NormalBody(
                goToProfile: goToProfile,
                fromNav: fromNav,
                onBackButtonPressed: () => Navigator.pop(context),
                uid: uid,
                following: following,
                isAdmin: isAdmin,
              )
            : Body(
                goToProfile: goToProfile,
                fromNav: fromNav,
                onBackButtonPressed: () => Navigator.pop(context),
                uid: uid,
                following: following,
                isAdmin: isAdmin,
              ),
      ),
    );
  }
}

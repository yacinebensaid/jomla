import 'package:flutter/material.dart';
import 'user_infos.dart';
import 'user_products.dart';

class Body extends StatefulWidget {
  final VoidCallback goToProfile;
  bool fromNav;
  VoidCallback onBackButtonPressed;
  List following;
  bool isAdmin;
  final String uid;

  Body({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.uid,
    required this.fromNav,
    required this.onBackButtonPressed,
    required this.goToProfile,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: const Color.fromARGB(255, 240, 240, 240),
              child: UserInfos(
                fromNav: widget.fromNav,
                onBackButtonPressed: widget.onBackButtonPressed,
                following: widget.following,
                uid: widget.uid,
              )),
          Container(
            color: Color(0xFFF5F6F9),
            child: UserProducts(
              goToProfile: widget.goToProfile,
              following: widget.following,
              uid: widget.uid,
              isAdmin: widget.isAdmin,
            ),
          )
        ],
      ),
    );
  }
}

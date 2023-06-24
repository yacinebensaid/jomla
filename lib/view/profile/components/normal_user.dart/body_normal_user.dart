// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'normal_user_infos.dart';
import 'under_infos.dart';

class NormalBody extends StatefulWidget {
  bool fromNav;
  VoidCallback onBackButtonPressed;
  List following;
  final VoidCallback goToProfile;
  bool isAdmin;
  final String uid;

  NormalBody({
    Key? key,
    required this.fromNav,
    required this.onBackButtonPressed,
    required this.following,
    required this.goToProfile,
    required this.isAdmin,
    required this.uid,
  }) : super(key: key);

  @override
  State<NormalBody> createState() => _BodyState();
}

class _BodyState extends State<NormalBody> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: Color.fromARGB(255, 255, 255, 255),
              child: NormalUserInfos(
                fromNav: widget.fromNav,
                onBackButtonPressed: widget.onBackButtonPressed,
                uid: widget.uid,
              )),
          Divider(
            color: Colors.grey,
            thickness: 0.2.h,
          ),
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: UnderInfos(
              goToProfile: widget.goToProfile,
              following: widget.following,
              isAdmin: widget.isAdmin,
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'components/body.dart';

class ExploreView extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  ExploreView({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.goToProfile,
  }) : super(key: key);

  @override
  State<ExploreView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(
        goToProfile: widget.goToProfile,
        following: widget.following,
        isAdmin: widget.isAdmin,
      ),
    );
  }
}

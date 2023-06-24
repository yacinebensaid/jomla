// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:jomla/view/subcat_details/components/card_rows.dart';

import '../../../size_config.dart';

class Body extends StatefulWidget {
  final VoidCallback goToProfile;
  List following;
  bool isAdmin;
  final String maincat;

  Body({
    Key? key,
    required this.isAdmin,
    required this.maincat,
    required this.following,
    required this.goToProfile,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // Implement the refresh action here
          // For example, you can call setState to trigger a rebuild of the CardRows widget
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenWidth(20)),
              CardRows(
                goToProfile: widget.goToProfile,
                maincat: widget.maincat,
                following: widget.following,
                isAdmin: widget.isAdmin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

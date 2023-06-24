// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'components/body.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  List following;
  final VoidCallback goToProfile;
  String userType;
  bool isAdmin;
  CartScreen({
    Key? key,
    required this.following,
    required this.userType,
    required this.isAdmin,
    required this.goToProfile,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Body(
          goToProfile: widget.goToProfile,
          following: widget.following,
          isAdmin: widget.isAdmin,
        ),
        bottomNavigationBar: CheckoutCard(
          goToProfile: widget.goToProfile,
          following: widget.following,
          userType: widget.userType,
          isAdmin: widget.isAdmin,
        ),
      ),
    );
  }
}

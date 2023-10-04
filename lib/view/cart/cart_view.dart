// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';

import 'package:jomla/utilities/reusable.dart';
import 'components/body.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        title: 'Cart',
        onBackButtonPressed: null,
      ),
      body: AuthService.firebase().currentUser != null
          ? const Body()
          : const Center(
              child: LoginDialog(
              guest: false,
            )),
    );
  }
}

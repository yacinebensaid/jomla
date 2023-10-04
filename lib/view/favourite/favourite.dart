// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/utilities/reusable.dart';

import 'components/body.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({
    Key? key,
  }) : super(key: key);

  @override
  State<FavouriteView> createState() => _FarouriteViewState();
}

class _FarouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Favorite',
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

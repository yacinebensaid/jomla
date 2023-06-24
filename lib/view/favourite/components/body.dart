// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:jomla/view/favourite/components/fav_products.dart';

class Body extends StatelessWidget {
  final VoidCallback goToProfile;

  final List following;
  final bool isAdmin;
  const Body({
    Key? key,
    required this.isAdmin,
    required this.following,
    required this.goToProfile,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FavProducts(
        goToProfile: goToProfile,
        following: following,
        isAdmin: isAdmin,
      ),
    );
  }
}

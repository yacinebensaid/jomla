// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          shadowColor: Colors.transparent.withOpacity(0),
          backgroundColor: Colors.transparent.withOpacity(0),
          title: const Text('Favourite'),
        ),
        body: Body(),
      ),
    );
  }
}

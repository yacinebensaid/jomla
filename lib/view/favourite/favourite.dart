import 'package:flutter/material.dart';
import 'components/body.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FarouriteViewState();
}

class _FarouriteViewState extends State<FavouriteView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Scaffold(
        body: Body(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../size_config.dart';
import 'components/body.dart';

class HomeView extends StatefulWidget {
  final VoidCallback goToExplore;
  const HomeView({super.key, required this.goToExplore});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void goToExplore() {
    widget.goToExplore();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(goToExplore: goToExplore),
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
    );
  }
}


// we gonna make an alert popup to confirm the logout
//the buildcontext is a function for building widgits, and context is a pre declared widgits

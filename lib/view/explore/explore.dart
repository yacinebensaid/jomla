import 'package:flutter/material.dart';
import 'package:jomla/view/components/appbar.dart';
import 'components/body.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

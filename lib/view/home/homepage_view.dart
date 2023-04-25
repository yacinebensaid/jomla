import 'package:flutter/material.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/view/search/search.dart';

import '../../size_config.dart';
import 'components/body.dart';

class HomeView extends StatefulWidget {
  final VoidCallback goToExplore;
  final VoidCallback opendrawer;

  const HomeView(
      {Key? key, required this.goToExplore, required this.opendrawer})
      : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void goToExplore() {
    widget.goToExplore();
  }

  void opendrawer() {
    widget.opendrawer();
  }

  bool _isAppBarTransparent = true;

  void _updateAppBarState(bool isAppBarTransparent) {
    setState(() {
      _isAppBarTransparent = isAppBarTransparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        Scaffold(
          body: Body(
            toExplore: goToExplore,
            updateAppBarState: _updateAppBarState,
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        Container(
          height: 75,
          width: SizeConfig.screenWidth,
          color: Colors.transparent.withOpacity(0.0),
          child: AppBar(
            elevation: 0,
            backgroundColor: _isAppBarTransparent
                ? Colors.transparent.withOpacity(0.0)
                : const Color.fromARGB(255, 28, 26, 26),
            leading: IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                opendrawer();
              },
            ),
            actions: [
              IconButton(
                padding: const EdgeInsets.only(right: 10),
                style: IconButton.styleFrom(foregroundColor: Colors.white),
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustumSearchDeligate());
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}

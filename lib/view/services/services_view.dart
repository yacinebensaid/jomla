import 'package:flutter/material.dart';
import 'package:jomla/size_config.dart';

import 'components/body.dart';

class ServicesView extends StatefulWidget {
  final VoidCallback opendrawer;

  const ServicesView({Key? key, required this.opendrawer}) : super(key: key);
  @override
  State<ServicesView> createState() => _ServicesViewState();
}

class _ServicesViewState extends State<ServicesView> {
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
    return Stack(children: [
      Scaffold(
        body: Body(
          updateAppBarState: _updateAppBarState,
        ),
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
                /*showSearch(context: context, delegate: CustumSearchDeligate());*/
              },
            ),
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {},
            ),
          ],
        ),
      )
    ]);
  }
}

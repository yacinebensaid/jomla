import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/view/search/search.dart';
import 'package:provider/provider.dart';

class Appbar extends AppBar {
  final void Function() onTapDrawer;
  Appbar({super.key, required this.onTapDrawer}) : super(toolbarHeight: 45);

  @override
  State<Appbar> createState() => _AppbarState();
}

class _AppbarState extends State<Appbar> {
  UserData? userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (UserDataInitializer().userDataStream != null) {
      UserDataInitializer().userDataStream!.listen((event) {
        userData = event;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    super.didChangeDependencies();
    if (UserDataInitializer().userDataStream != null) {
      UserDataInitializer().userDataStream!.listen((event) {
        userData = event;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      shadowColor: Color.fromARGB(255, 169, 231, 205),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 91, 199, 245),
              Color.fromARGB(
                  255, 169, 231, 205), // Start color (your blue color)
              // End color (lighter color)
            ],
            begin: Alignment
                .centerLeft, // You can adjust the gradient's start point
            end: Alignment
                .centerRight, // You can adjust the gradient's end point
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          widget.onTapDrawer();
        },
      ),
      actions: buildAppBarActions(context, kIsWeb, userData),
    );
  }

  List<Widget> buildAppBarActions(
    BuildContext context,
    bool isWeb,
    UserData? userData,
  ) {
    final actions = <Widget>[];

    if (isWeb) {
      actions.addAll([
        buildIconButton(
          Icons.home,
          'Home',
          () => Provider.of<HomeFunc>(context, listen: false)
              .onTapNavigation(context, 0),
        ),
        buildIconButton(
          Icons.shopping_cart,
          'Cart',
          () => Provider.of<HomeFunc>(context, listen: false)
              .onTapNavigation(context, 1),
        ),
        buildIconButton(
          Icons.explore,
          'Explore',
          () => Provider.of<HomeFunc>(context, listen: false)
              .onTapNavigation(context, 2),
        ),
      ]);

      if (userData != null) {
        actions.add(
          buildIconButton(
            Icons.notifications,
            'Notifications',
            () {},
          ),
        );
      }

      actions.add(
        buildIconButton(
          Icons.person,
          'Profile',
          () => Provider.of<HomeFunc>(context, listen: false)
              .onTapNavigation(context, 3),
        ),
      );
    } else {
      actions.add(
        IconButton(
          padding: const EdgeInsets.only(right: 10),
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustumSearchDeligate(),
            );
          },
        ),
      );
    }

    return actions;
  }

  IconButton buildIconButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }
}

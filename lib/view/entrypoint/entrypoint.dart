import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jomla/constants/const_routs.dart';
import 'package:jomla/constants/routes.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/size_config.dart';

import 'package:jomla/view/components/appbar.dart';

import 'package:provider/provider.dart';
import '../components/drawer.dart';

class EntryPoint extends StatefulWidget {
  final Widget child;
  const EntryPoint({super.key, required this.child});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? uid;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (AuthService.firebase().currentUser != null) {
      uid = AuthService.firebase().currentUser!.uid;
    }
  }

  void onTapped(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/cart');
        break;
      case 2:
        Provider.of<UserDataInitializer>(context, listen: false).getUserType ==
                'market'
            ? GoRouter.of(context).go('/add')
            : GoRouter.of(context).go('/explore');

        break;
      case 3:
        Provider.of<UserDataInitializer>(context, listen: false).getUserType ==
                'market'
            ? GoRouter.of(context).go('/explore')
            : GoRouter.of(context).go('/profile/${uid}');

        break;
      case 4:
        if (Provider.of<UserDataInitializer>(context, listen: false)
                .getUserType ==
            'market') GoRouter.of(context).go('/profile/${uid}');
        break;
      default:
        MyAppRouter().router.namedLocation(RoutsConst.loginRout);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HomeFunc>(context)
        .initialize(page_Controller: pageController, scaffoldKey: _scaffoldKey);
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        //key: _scaffoldKey,
        appBar: _selectedIndex == 1
            ? MyCustomAppBar(
                context: context,
              )
            : null,
        drawer: NavigationDrawer(),
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'cart',
            ),
            if (Provider.of<UserDataInitializer>(context, listen: false)
                    .getUserType ==
                'market')
              const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'add',
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'explore',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: 'profile',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Colors.grey,
          onTap: ((value) {
            onTapped(context, value);
          }),
        ));
  }
}


/*class EntryPoint extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  EntryPoint({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('EntryPoint'));

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {

  
}*/






/*int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); */


/*Stack(children: [
            PageView(
              controller: pageController,
              children: [
                HomeView(
                  opendrawer: opendrawer,
                  goToExplore: goToExplore,
                ), // pass the function here
                CartScreen(),
                Provider.of<UserDataInitializer>(context, listen: false)
                            .getUserType ==
                        'market'
                    ? AddProductPage()
                    : ExploreView(),
                Provider.of<UserDataInitializer>(context, listen: false)
                            .getUserType ==
                        'market'
                    ? ExploreView()
                    : ProfileScreen(
                        fromNav: true,
                        uid: Provider.of<UserDataInitializer>(context,
                                        listen: false)
                                    .getUSER !=
                                null
                            ? Provider.of<UserDataInitializer>(context,
                                    listen: false)
                                .getUSER!
                                .uid
                            : null,
                      ),
                if (Provider.of<UserDataInitializer>(context, listen: false)
                        .getUserType ==
                    'market')
                  ProfileScreen(
                    fromNav: true,
                    uid: Provider.of<UserDataInitializer>(context, listen: false)
                                .getUSER !=
                            null
                        ? Provider.of<UserDataInitializer>(context, listen: false)
                            .getUSER!
                            .uid
                        : null,
                  )
              ],
              //i don't want to return anything if the user_type != 'market'
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ]), */



/*BottomNavigationBar(
          backgroundColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1.0),
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
              
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: '',
            ),
            if (Provider.of<UserDataInitializer>(context, listen: false)
                    .getUserType ==
                'market')
              const BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: '',
              ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_sharp),
              label: '',
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromARGB(255, 0, 0, 0),
          unselectedItemColor: Colors.grey,
          onTap: onTapped,
        ),*/



/*void goToExplore() {
    Provider.of<UserDataInitializer>(context, listen: false).getUserType !=
            'market'
        ? pageController.jumpToPage(2)
        : pageController.jumpToPage(3);
  }

  void goToProfile() {
    Provider.of<UserDataInitializer>(context, listen: false).getUserType !=
            'market'
        ? pageController.jumpToPage(3)
        : pageController.jumpToPage(4);
  }

  void opendrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void goToHome() {
    if (pageController.page?.round() == 0) {
      setState(() {});
    } else {
      pageController.jumpToPage(0);
    }
  } */
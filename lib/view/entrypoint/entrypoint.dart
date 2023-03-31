import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/home/homepage_view.dart';
import 'package:jomla/view/search/search.dart';
import '../components/drawer.dart';
import '../cart/cart_view.dart';
import '../profile/profile_view.dart';
import 'appbar.dart';
import 'package:flutter/foundation.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void goToExplore() {
    setState(() {
      _selectedIndex = 2; // index of ExploreView
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    return Scaffold(
        backgroundColor: const Color(0xFF00235B),
        resizeToAvoidBottomInset: false,
        extendBody: true,
        appBar: isWeb
            ? AppBar(
                title: SizedBox(
                  height: 37.h,
                  child: Image.asset(
                      'assets/images/jomla logo1 no-slogon croped.png',
                      fit: BoxFit.contain),
                ),
                backgroundColor: const Color(0xFF00235B),
                actions: [
                  TextButton(
                    onPressed: () {
                      showSearch(
                          context: context, delegate: CustumSearchDeligate());
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onTapped(1);
                    },
                    child: Text(
                      'Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onTapped(2);
                    },
                    child: Text(
                      'Explore',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onTapped(3);
                    },
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              )
            : MyCustomAppBar(
                context: context,
              ),
        drawer: const NavigationDrawer(),
        body: Stack(children: [
          PageView(
            controller: pageController,
            children: [
              HomeView(goToExplore: goToExplore), // pass the function here
              CartScreen(),
              ExploreView(),
              ProfileScreen(),
            ],
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          if (!isWeb)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: null,
                height: 75,
                padding: const EdgeInsets.only(bottom: 10),
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black38,
                          spreadRadius: 0,
                          blurRadius: 10)
                    ]),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: const Color(0xFF00235B).withOpacity(0.85),
                      shadowColor: null,
                    ),
                    child: BottomNavigationBar(
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.home),
                          label: AppLocalizations.of(context)!.home,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.shopping_cart),
                          label: AppLocalizations.of(context)!.cart,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.explore),
                          label: AppLocalizations.of(context)!.explore,
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.person),
                          label: AppLocalizations.of(context)!.profile,
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.white,
                      unselectedItemColor: Colors.grey,
                      onTap: onTapped,
                    ),
                  ),
                ),
              ),
            ),
        ]));
  }
}

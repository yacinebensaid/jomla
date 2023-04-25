import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/view/add_product/adding_newproduct_view.dart';
import 'package:jomla/view/cart/cart_view.dart';
import 'package:jomla/view/components/appbar.dart';
import 'package:jomla/view/explore/explore.dart';
import 'package:jomla/view/home/homepage_view.dart';
import '../../services/crud/userdata_service.dart';
import '../components/drawer.dart';
import '../profile/profile_view.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    pageController.jumpToPage(index);
  }

  void goToExplore() {
    pageController.jumpToPage(2);
  }

  void opendrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: _selectedIndex == 1 ? MyCustomAppBar(context: context) : null,
        drawer: const NavigationDrawer(),
        body: Stack(children: [
          PageView(
            controller: pageController,
            children: [
              HomeView(
                opendrawer: opendrawer,
                goToExplore: goToExplore,
              ), // pass the function here
              CartScreen(),
              FutureBuilder(
                  future: DataService.getUserData(userUID!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data!.user_type == 'market') {
                      return AddProductPage();
                    } else {
                      return Container();
                    }
                  }),
              const ExploreView(),
              ProfileScreen(
                uid: userUID!,
              ),
            ],
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: null,
              height: getProportionateScreenHeight(68),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor:
                        const Color.fromARGB(255, 28, 26, 26).withOpacity(1.0),
                    shadowColor: null,
                  ),
                  child: FutureBuilder(
                      future: DataService.getUserData(userUID!),
                      builder: (context, snapshot) {
                        return BottomNavigationBar(
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.home),
                              label: AppLocalizations.of(context)!.home,
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.shopping_cart),
                              label: 'Cart',
                            ),
                            if (snapshot.hasData &&
                                snapshot.data!.user_type == 'market')
                              const BottomNavigationBarItem(
                                icon: Icon(Icons.add),
                                label: 'Add Product',
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
                        );
                      }),
                ),
              ),
            ),
          ),
        ]));
  }
}
